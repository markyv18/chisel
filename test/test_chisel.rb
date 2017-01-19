require "minitest/autorun"
require "minitest/pride"
require "./lib/chisel.rb"

class ChiselTest < Minitest::Test

  def test_file_is_brought_in
    file = Chisel.new
    assert file.incoming_text.to_s.include?(" ")
  end

  def test_lines_in_the_file
    file = Chisel.new
    assert_equal 18, file.incoming_text.lines.count
  end

  def test_does_file_include_elements_of_a_markdown_file
    file = Chisel.new
    assert file.incoming_text.to_s.include?("\n")
    assert file.incoming_text.to_s.include?("#")
    assert file.incoming_text.to_s.include?("**")
  end

  def test_call_h1_on_example_markdowns_and_convert_expressed_elements_to_html
skip
      example = "# header 1"
      assert_equals "<h1>header 1</h1>", example.headerconvertermethod
  end

  def test_call_h6_on_example_markdowns_and_convert_expressed_elements_to_html
    skip
      example = "###### header 6"
      assert_equals "<h6>header 6</h6>", example.headerconvertermethod
  end

  def test_call_asterick_on_example_markdowns_and_convert_expressed_elements_to_html
    skip
      example = "**thing**"
      assert_equals "<em>thing</em>", example.asterickconvertermethod
  end

  def test_call_paragraph_on_example_markdowns_and_convert_expressed_elements_to_html
    skip
      example = "hello my name is"
      file = Chisel.new
      assert_equals "<p>hello my name is</p>", example.paragraphconvertermethod
  end


  def test_do_html_elements_exist_after_conversions
    skip
    file = Chisel.new
    assert file.method that changes a thing.to_s include? ("<p>")
    assert file.method that changes a thing.to_s include? ("</p>")
    assert file.method that changes a thing.to_s include? ("<h1>")
    assert file.method that changes a thing.to_s include? ("</h1>")
    assert file.method that changes a thing.to_s include? ("<em>")
    assert file.method that changes a thing.to_s include? ("</em>")
    assert file.method that changes a thing.to_s include? ("<strong>")
    assert file.method that changes a thing.to_s include? ("</strong>")
    assert file.method that changes a thing.to_s include? ("<ol>")
    assert file.method that changes a thing.to_s include? ("</ol>")
    assert file.method that changes a thing.to_s include? ("<ul>")
    assert file.method that changes a thing.to_s include? ("</ul>")
  end
end
