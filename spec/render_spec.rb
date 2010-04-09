require "spec_helper"
require 'render'
require 'nokogiri'

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
      @speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe')
      @sessions = [Session.new(:title => 'diner')]
    end
    it 'should render diner session' do
      output = Renderer.new.render_sessions_with_template(@sessions, 'atelier-longs.html.erb')
      doc = Nokogiri::HTML(output)
      doc.search('//h1').first.content.should == 'diner'
    end
  end
end
