module NavLinkToHelper
  def nav_link_to(name, options={}, active_options={})
    url = url_for(options)
    active_options[:active] = :prefix unless active_options.has_key?(:active)

    link_class = 'nav-item nav-link'
    link_class += ' active' if is_active_link?(url, active_options[:active])

    link_to(name, url, class: link_class)
  end

  private

  def is_active_link?(url, condition)
    path = URI::parse(url).path
    case condition
    when :exact
      request.fullpath == url
    when :prefix
      !request.fullpath.match(/^#{Regexp.escape(path).chomp('/')}(\/.*|\?.*)?$/).blank?
    end
  end
end
