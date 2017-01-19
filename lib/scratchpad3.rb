require './lib/markdown_parser'

class Chisel
  def initialize(input, html)
    @markdown_file_name = input.split("/").last
    @html_file_name = html.split("/").last
    @input = File.read(input)
    @markdown_lines = @input.lines.count
    @html  = html
    @markdown_parser = MarkdownParser.new(@input)
  end

  def convert_and_save
    html_text = @markdown_parser.convert_to_html
    send_to_html_file(html_text)
  end

  def send_to_html_file(text)
    File.write(@html, text)
    html_lines = File.read(@html).lines.count
    puts "Converted #{@markdown_file_name} (#{@markdown_lines} lines) to #{@html_file_name} (#{html_lines} lines)"
  end
end

chisel = Chisel.new(ARGV[0], ARGV[1])
chisel.convert_and_save

------------------------------------------------

class Bold
  def initialize(input)
    @input = input
  end

  def bold_the_input
    @input.split("\n\n").map do |element|
        # **WORD**
        a = element.sub(">**", "><strong>")
        b = a.sub("**<", "</strong><")
        c = b.gsub(" **", " <strong>")
        d = c.gsub("** ", "</strong> ")
        e = d.gsub("**.", "</strong>.")
        f = e.gsub("**,", "</strong>,")
        g = f.gsub("\n**", "\n<strong>")
    end.join("\n\n")
  end
end

----------------------------------------------
class Header
  def create_header(line)
    hash_count = line.count("#")
    remove_hashes = line.gsub("#", "")
    remove_lead_space = remove_hashes.sub(" ", "")
    headers = remove_lead_space.insert(0, "<h#{hash_count}>").insert(-1, "</h#{hash_count}>\n")
  end
end

------------------------------------------------

class Italic
  def initialize(input)
    @input = input
  end

  def italicize_the_input
     @input.split("\n\n").map do |element|
        a = element.sub(">*", "><em>")
        b = a.sub("*<", "</em><")
        c = b.gsub(" *", " <em>")
        d = c.gsub("* ", "</em> ")
        e = d.gsub("*.", "</em>.")
        f = e.gsub("*,", "</em>,")
        g= f.gsub("\n*", "\n<em>")
     end.join("\n\n")
  end
end

-----------------------------------------------
require_relative 'header'
require_relative 'paragraph'
require_relative 'bold'
require_relative 'italic'

class MarkdownParser
  attr_accessor :header, :paragraph
  def initialize(input)
    @input = input
    @header = Header.new
    @paragraph = Paragraph.new
  end

  def convert_to_html
    @input.gsub!("\n\n\n", "\n\n")
    paragraphs = @input.split("\n\n")
    sections = paragraphs.chunk do |pg|
      pg.start_with?("#")
    end

    parsed_paragraph_and_headers = sections.map do |starts_with_header, lines|
      if starts_with_header
        compose_headers_and_paragraphs(lines)
      else
        compose_paragraphs(lines)
      end
    end.join("\n")

    parsed_bold = Bold.new(parsed_paragraph_and_headers).bold_the_input
    Italic.new(parsed_bold).italicize_the_input
  end

  def compose_paragraphs(lines_of_text)
    lines_of_text.map do |paragraph_text|
      paragraph.create_paragraph(paragraph_text)
    end.join("\n")
  end

  def compose_headers_and_paragraphs(lines_of_text)
    lines_of_text.map do |paragraph_text|
      paragraph_text.split("\n").map do |line|
        if header_line?(line)
          header.create_header(line)
        else
          paragraph.create_paragraph(line)
        end
      end
    end.join("\n")
  end

  def header_line?(line)
    line.start_with?("#")
  end
end

-------------------------------------------------
require_relative 'header'
require_relative 'paragraph'
require_relative 'bold'
require_relative 'italic'


class MarkdownParser3
  attr_accessor :header, :paragraph
  def initialize(input)
    @input = input
    @header = Header.new
    @paragraph = Paragraph.new
  end

  def convert_to_html
    new_input_array = @input.split("\n\n")

    parsed_paragraph_and_headers = new_input_array.map do |line|
      if line.include?("\n#") && !line.start_with?("\n#")
        line.gsub!("\n#", "\n\n#")
        new_lines = line.split("\n\n")
        new_lines.map do |element|
          header.create_header(element)
        end
      elsif line.include?("\n") && !line.start_with?("\n")
        if line.start_with?("#")
          new_lines = line.split("\n")
          new_lines.map do |element|
            if element.start_with?("#")
              header.create_header(element)
            else
              paragraph.create_paragraph(element)
            end
          end
        else
          paragraph.create_paragraph(line)
        end
      elsif line.start_with?("#")
        header.create_header(line)
      elsif line.start_with?("\n")
        line.slice!(0)
        if line.start_with?("#")
          header.create_header(line)
        else
          paragraph.create_paragraph(line)
        end
      elsif !line.start_with?("#")
        paragraph.create_paragraph(line)
      end
    end.join("\n")

    parsed_bold = Bold.new(parsed_paragraph_and_headers).bold_the_input
    Italic.new(parsed_bold).italicize_the_input
  end
end

----------------------------------------------------------

class Paragraph
  def create_paragraph(line)
    line.insert(0, "<p>").insert(-1, "</p>\n")
  end
end
