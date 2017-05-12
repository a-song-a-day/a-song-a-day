# https://github.com/vmg/redcarpet/issues/184#issuecomment-13154383
module MarkdownHelper
  def markdown(content)
    @@markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    @@markdown.render(content)
  end
end
