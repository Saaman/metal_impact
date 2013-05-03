require 'spec_helper'

describe MarkdownHelper do

  describe "render_markdown" do
    it 'should render html' do
      render_markdown('This is _underlined_ but this is still *italic*').should be_start_with '<p>This is <u>underlined</u> but this is still <em>italic</em></p>'
    end
  end
end
