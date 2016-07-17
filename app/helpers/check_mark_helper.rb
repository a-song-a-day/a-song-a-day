module CheckMarkHelper
  def check_mark(bool)
    if bool
      content_tag 'span', '&#x2714;'.html_safe, class: 'text-success'
    else
      content_tag 'span', '&#x2718;'.html_safe, class: 'text-danger'
    end
  end
end
