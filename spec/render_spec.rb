require "spec_helper"
require 'render'
require 'nokogiri'
require 'rr'

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

  describe 'render' do
    before do
      @speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe')
      @sessions = [Session.new(:title => 'diner', :speaker => @speaker)]
    end

    describe 'render_sessions_with_template' do
      before do
        @got = nil
        @content = @renderer.render_sessions_with_template(@sessions, 'sessions.html.erb') do |content|
          @got = content 
        end
      end

      it 'should render diner session' do
        doc = Nokogiri::HTML(@content)
        doc.search('//h1').first.content.should == 'diner'
      end

      it 'should yield content' do
        @got.should == @content
      end
    end


    describe 'write_to_file' do
      before do
        @file_name = 'some-sessions.html'
        @io = StringIO.new
        mock(File).open(File.join(@renderer.output_dir, @file_name), 'w+').yields(@io)
      end

      it 'should write to file' do
        @renderer.write('foo', @file_name)
        @io.string.should == 'foo'
      end
    end
  end
end
