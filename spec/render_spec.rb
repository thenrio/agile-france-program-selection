require "spec"
require 'render'

describe 'Renderer' do
  before do
    @renderer = Renderer.new
  end
  describe 'clear' do
    it "should be true each 3" do
      @renderer.clear(0).should be_true
      @renderer.clear(1).should be_false
      @renderer.clear(2).should be_false
      @renderer.clear(3).should be_true
    end
  end

  describe 'render_sessions_with_template' do
    before do
      @speaker = Speaker.new
      @sessions = []
    end
    it 'should ' do

    end
  end
end
