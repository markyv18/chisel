
class Chisel

  def initialize
    markdown = File.open("my_input.markdown", "r")
    # markdown = File.open("", "r")  ARGV[0]
    @incoming_text = markdown.read
    markdown.close
  end

  def parse
    @ordered_list = false
    @skip_paragraphs = false
    @list = false
    @input_lines = @incoming_text.split("\n\n")
    @input_lines.each_index do |index|
      if @input_lines[index].start_with? "#"
        split_on_line(index)
        @input_line.each_index do |index_line|
          @input_line[index_line] = "<h#{number(index_line)}>#{string(index_line)}</h#{number(index_line)}>"
        end
        @input_lines = @input_line
      else
        split_on_line(index)
        @input_line.each_index do |index_line|
          god_language(index_line)
        end
        if @list == false && @skip_paragraphs == false
          @input_line = "<p>#{@input_line.join}</p>"
        end
        @skip_paragraphs = false
        @input_lines[index] = @input_line
      end
    end
    @incoming_text = @input_lines.join
    #package_output_file
  end

  def split_on_line(index)
    @input_line = @input_lines[index].split("\n")
  end

  def god_language(index_line)
    ordered_logic(index_line)
    strong_logic(index_line)
    single_star_logic(index_line)
  end

  def ordered_logic(index_line)
    check_ordered_logic(index_line)
    if @input_line.length == (index_line + 1)
      ordered_list_end(index_line)
    end
  end

  def check_ordered_logic(index_line)
    if @input_line[index_line][1] == "."
      number_check = @input_line[index_line][0].to_i
      if number_check.class == Fixnum
        @input_line[index_line].slice!(0..1)
        list_line(index_line)
        if @ordered_list == false
          @input_line[index_line].insert(0, "<ol>")
          @ordered_list = true
          @skip_paragraphs = true
        end
      end
    else
      if @ordered_list == true
        ordered_list_end(index_line)
      end
    end
  end

  def ordered_list_end(index_line)
    if @ordered_list == true
      @input_line[index_line] = "#{@input_line[index_line]}</ol>"
      @ordered_list = false
      @skip_paragraphs = true
    end
  end

  def strong_logic(index_line)
    @input_line[index_line].count("**").times do |i|
      replacement = i.even? ? '<strong>' : '</strong>'
      @input_line[index_line].sub!("**", replacement)
    end
  end

  def single_star_logic(index_line)
    if @input_line[index_line][0] == "*"
      if @input_line[index_line].count("*").odd?
        list_line(index_line)
        unordered_list_beginning(index_line)
        if @input_line.length == (index_line + 1)
          unordered_list_end(index_line)
        end
      end
    elsif @list == true
      unordered_list_end(index_line)
    end
    @input_line[index_line].count("*").times do |i|
      replacement = i.even? ? '<em>' : '</em>'
      @input_line[index_line].sub!("*", replacement)
    end
  end

  def unordered_list_end(index_line)
    @input_line[index_line] = "#{@input_line[index_line]}</ul>"
    @list = false
    @skip_paragraphs = true
  end

  def unordered_list_beginning(index_line)
    if @list == false
      @input_line[index_line].insert(0, "<ul>")
    end
    @input_line[index_line] = @input_line[index_line].delete"*"
    @list = true
  end

  def list_line(index_line)
    @input_line[index_line] = "<li>#{@input_line[index_line]}</li>"
  end

  def number(index_line)
    counter = 0
    @input_line[index_line].chars.each do |hash|
      if hash == "#"
       counter += 1
      end
    end
    counter
  end

  def string(index_line)
    info = @input_line[index_line].chars[number(index_line)..-1]
    if info.nil?
      info = ""
    else
      info.join.lstrip
    end
  end

  def package_output_file
    output_file = File.open("my_output.html", 'w')
    output_file.write(parse)
    puts "Converted #{input_file} (#{input_file.size} lines) to my_output.html (#{output_file.size} lines)."
  end

end
