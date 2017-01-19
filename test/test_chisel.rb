require "minitest/autorun"
require "minitest/pride"
require "./lib/chisel.rb"
require "my_input.markdown"

class ChiselTest < Minitest::Test

  def initialize
    markdown = File.open("./my_input.markdown", "r")
    @incoming = markdown.read
    @incoming_text = incoming.split("\n\n")
    markdown.close
  end

# to run tests, comment out lines 6/118 and enable line 5/117

  def test_odd_chars
    file = Chisel.new
    a = file.odd_chars
    assert a[2].include?("&amp;")
  end

  def test_header_and_list_convert
    file = Chisel.new
    a = file.header_and_list_converter
    assert_equal "<h1>", a[0][0][0..3]
  end

  def test_strong_em
    skip
    file = Chisel.new
    a = file.strong_em
    assert_equal "<em>", a
    assert_equal "<strong>", a
  end

  def test_paragraph
    file = Chisel.new(@incoming_text)
    a = file.paragraph
    assert_equal "<p>", a[3][0][0..2]
  end

  def test_ordered_list
    skip
    file = Chisel.new
    a = file.header_and_list_converter
    assert_equal "<h1>", a[0][0][0..3]
  end

  def test_unordered_list
    skip
    file = Chisel.new
    a = file.header_and_list_converter
    assert_equal "<h1>", a[0][0][0..3]
  end



end
