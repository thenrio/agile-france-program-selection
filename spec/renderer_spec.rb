require "spec_helper"
require 'renderer'
require 'nokogiri'
require 'ostruct'
require 'rr'

describe 'Renderer' do
  before do
    @renderer = Renderer.new
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

describe Renderer::Erb do
  before do
    @renderer = Renderer::Erb.new
    @speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe')
    @sessions = [Session.new(:title => 'diner', :speaker => @speaker)]
  end

  describe 'render' do
    before do
      @got = nil
      @content = @renderer.render('sessions-with-your-hands.html.erb', :sessions => @sessions) do |content|
        @got = content
      end
    end

    it 'should have diner session' do
      doc = Nokogiri::HTML(@content)
      doc.search('//h3').first.content.should == 'diner'
    end

    it 'should yield content' do
      @got.should == @content
    end
  end

  describe 'inject_locals' do
    it 'should make available hash values under hash keys' do
      @renderer.inject_locals(:foo => 'foo').should == @renderer
      @renderer.foo.should == 'foo'
    end
  end
end

describe Renderer::Hml do
  before do
    @renderer = Renderer::Hml.new
    @company = OpenStruct.new(:name => 'ha')
    invoiceable = OpenStruct.new(:invoice_item_id => 'ID', :quantity => 10, :price => 200)
    @invoice = OpenStruct.new(:invoiceables => [invoiceable])

    @invoice.invoiceables.first.quantity.should == 10
  end

  describe 'render' do
    it 'should render haiku' do
      content = @renderer.render('xero/invoice.xml.haml', :company => @company, :invoice => @invoice)
      doc = Nokogiri::XML(content)
      doc.search('/Invoice/Type').first.content.should == 'ACCREC'
    end
  end
end
