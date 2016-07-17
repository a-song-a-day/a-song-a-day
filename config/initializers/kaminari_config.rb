Kaminari.configure do |config|
  # config.default_per_page = 25
  # config.max_per_page = nil
  config.window = 2
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end

# Make the number of links in the paginator consistent
# http://stackoverflow.com/a/15843865/212330
module Kaminari
  module Helpers
    class Paginator < Tag
      def relevant_pages(options)
        1..options[:total_pages]
      end

      class PageProxy
        def inside_window?
          if @options[:current_page] <= @options[:window]
            @page <= (@options[:window] * 2) + 1
          elsif (@options[:total_pages] - @options[:current_page].number) < @options[:window]
            @page >= (@options[:total_pages] - (@options[:window] * 2))
          else
            (@options[:current_page] - @page).abs <= @options[:window]
          end
        end
      end
    end
  end
end
