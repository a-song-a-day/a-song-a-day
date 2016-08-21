require 'net/http'
require 'csv'

desc 'Import CSV database'
task import_csv: :environment do
  url = ENV['CSV_URL']
  if url.blank?
    $stderr.puts "Missing CSV_URL environment variable"
    next
  end

  uri = URI(url)
  unless uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS
    $stderr.puts "Invalid CSV_URL '#{url}': must be http or https"
    next
  end

  data = Net::HTTP.get(uri).force_encoding('utf-8') # ugh
  options = { headers: true, converters: :numeric, header_converters: :symbol }
  rows = CSV.parse(data, options)

  puts "Parsed #{rows.size} rows"

  random = Curator.random
  curators = Curator.nonrandom.includes(:user).all

  def find_curator(name, curators, random)
    name_map = {
      "Alex Mantheir" => "Alex Manthei",
      "Colby Black" => "Colby Angus Black",
      "Laura" => "Laura Gluhanich",
      "Laura GLuhanich" => "Laura Gluhanich",
      "Mallory" => "Mallory Johns",
      "Rebecca Feinberg" => "Rebecca Fainberg",
      "Rey" => "Rey Campos"
    }

    return random if name === "Random"

    name = name_map.fetch(name) if name_map.has_key? name

    curators.find {|c| c.user.name.unicode_normalize == name.unicode_normalize }
  end

  def join_name(first_name, last_name)
    [first_name, last_name].map(&:presence).compact.join(" ")
  end

  progressbar = ProgressBar.create(title: 'Users',
                                   total: rows.count,
                                   format: "%a %e %P% Processed: %c from %C")

  rows.each do |row|
    confirmed_at = DateTime.parse(row[:confirm_time]) rescue DateTime.now
    attributes = {
      email: row[:email_address],
      name: join_name(row[:first_name], row[:last_name]),
      extra_information: row[:additional_info].presence,
      confirmed_email: true,
      created_at: confirmed_at
    }

    User.transaction do
      user = User.find_by_email(attributes[:email]) || User.new
      user.attributes = attributes
      user.save!

      curator = find_curator(row[:curator_name], curators, random)

      raise "Missing curator: #{row[:curator_name]}" if curator.nil?

      if user.subscriptions.where(curator_id: curator.id).empty?
        user.subscriptions.create!(curator_id: curator.id)
      end

      progressbar.increment
    end
  end
end
