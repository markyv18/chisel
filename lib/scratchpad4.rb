require './lib/chunk_formatter'
require './lib/chunk_maker'
require './lib/line_formatter'

class Chisel
  def initialize(markdown)
    @markdown = markdown
  end

  def to_html
    chunks      = ChunkMaker.new(@markdown).chunk
    html_chunks = chunks.map do |chunk|
      formatted = ChunkFormatter.new(chunk).format
      LineFormatter.new.formatting_to_html(formatted)
    end
    html_chunks.join("\n\n")
  end
end

if __FILE__   == $PROGRAM_NAME
  input_file  = ARGV[0]
  output_file = ARGV[1]

  markdown    = File.read(input_file)
  html        = Chisel.new(markdown).to_html
  File.write(output_file, html)
end

---------------------------------------------------
require './lib/header_processor'
require './lib/paragraph_processor'
require './lib/unorder_list_processor'
require './lib/order_list_processor'

class ChunkFormatter
  attr_reader :string, :paragraph_processor, :header_processor

  def initialize(chunk)
    @string                 = chunk
    @paragraph_processor    = ParagraphProcessor.new
    @unorder_list_processor = UnorderListProcessor.new
    @header_processor       = HeaderProcessor.new
    @order_list_processor   = OrderListProcessor.new
  end

  def format
    processor.format(@string)
  end

  def processor
    if string[0] == "#"
      return @header_processor
    elsif string[0] == "*"
      return @unorder_list_processor
    elsif leading_numbers.include?(string[0])
      return @order_list_processor
    else
      return @paragraph_processor
    end
  end

  def leading_numbers
    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end
end


--------------------------------------------------------
class ChunkMaker
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def chunk
    doc.split("\n\n")
  end
end

--------------------------------------------------------

class HeaderProcessor

  def format(string)
    count = string.count "#"
    string.insert(0, "<h#{count}>")
    string.insert(-1, "</h#{count}>")
    string.delete("#")
  end

  def type
    'header'
  end
end

--------------------------------------------------------
class LineFormatter

  def double_star_to_html(string)
    while string.include? "**"
    string.sub!("**", "<strong>")
    string.sub!("**", "</strong>")
    end
  end

  def star_to_html(string)
    string.sub!("*", "<em>")
    string.sub!("*", "</em>")
  end

  def formatting_to_html(string)
    while string.include? "*"
    double_star_to_html(string)
    star_to_html(string)
    end
    string
  end
end

---------------------------------------------------


class OrderListProcessor

  def ol_block_to_html(string)
    string.insert(0, "<ol>\n")
    string.insert(-1, "\n</ol>")
  end

  def ol_line_to_html(string)
    string.insert(0, '<li>')
    string.insert(-1, '</li>')
  end

  def format(string)
    lines = string.split("\n")
    lines.map do |line|
      delete_numbers(line)
      ol_line_to_html(line)
    end
    html_lines = lines.join("\n")
    ol_block_to_html(html_lines)
  end

  def leading_numbers
    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
  end

  def delete_numbers(string)
    while leading_numbers.include?(string[0])
      string.delete!(string[0])
    end
    return string
  end

end

---------------------------------------------

class ParagraphProcessor

  def format(string)
    string.insert(0, '<p>')
    string.insert(-1, '</p>')
  end

  def type
    'paragraph'
  end
end

----------------------------------------------
class UnorderListProcessor

  def ul_block_to_html(string)
    string.insert(0, "<ul>\n")
    string.insert(-1, "\n</ul>")
  end

  def ul_line_to_html(string)
    string.insert(0, '<li>')
    string.insert(-1, '</li>')
  end

  def format(string)
    lines = string.split("\n")
    lines.map do |line|
      line.delete!(line[0])
      ul_line_to_html(line)
    end
    html_lines = lines.join("\n")
    ul_block_to_html(html_lines)
  end
end
