module MarkdownHelper

	class MarkdownRenderer
    def initialize()
    	redcarpet_renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
			@renderer = Redcarpet::Markdown.new(redcarpet_renderer, no_intra_emphasis: true, :autolink => true, :space_after_headers => true, :underline => true)
    end

    def renderer
    	@renderer
    end
  end

	@@markdown = MarkdownRenderer.new()

	def render_markdown(text)
		@@markdown.renderer.render text
	end
end
