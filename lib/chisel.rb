class Chisel
  attr_reader :incoming_text, :incoming

  def initialize
    # markdown = File.open("./my_input.markdown", "r")
    markdown = File.open(ARGV[0], "r")
    @incoming = markdown.read
    @incoming_text = incoming.split("\n\n")
    markdown.close
    @headers_and_lists_added = []
    @headers_and_lists_ems_strongs_added = []
  end

  def odd_chars
    @incoming_text.map do |line|
      if line.include?("&")
        line.gsub!("&", "&amp;")
      else
        line
      end
    end
  end

  def header_and_list_converter
     @incoming_text.map do |lines|
       line = lines.split(" ")
       case line[0]
       when "#"
         line[0].gsub!("#", "<h1>")
         line << "</h1>"
        when "##"
          line[0].gsub!("##", "<h2>")
          line << "</h2>"
        when "###"
          line[0].gsub!("###", "<h3>")
          line << "</h3>"
        when "####"
          line[0].gsub!("####", "<h4>")
          line << "</h4>"
        when "#####"
          line[0].gsub!("#####", "<h5>")
          line << "</h5>"
        when "######"
          line[0].gsub!("######", "<h6>")
          line << "</h6>"
        when "1." || "2." || "3." || "4."
          ordered_list(line)
        when "*"
          unordered_list(line)
        else
          paragraph(line)
        end
        @headers_and_lists_added << line.join(" ")
      end
    end

    def paragraph(line)
      line.insert(0, "<p>").insert(-1, "</p>\n")
    end

    def unordered_list(line)
      line.map do |word|
        if word == "*"
          word.gsub!("*", "<li>")
        else
           word << "</li>"
        end
      end
      line.unshift("<ul>")
      line.push("</ul>")
    end

    def ordered_list(line)
      line.map do |word|
        if word == "1."
          word.gsub!("1.", "<li>")
        elsif word == "2."
          word.gsub!("2.", "<li>")
        elsif word == "3."
          word.gsub!("3.", "<li>")
        else
          word << "</li>"
        end
        # require "pry"; binding.pry
      end
      line.unshift("<ol>")
      line.push("</ol>")
    end

    def strong_em
      split = @headers_and_lists_added.map do |lines|
        lines.split(" ")
      end
      add_strong_and_em = split.flatten.map do |word|
        if word.include?("**")
          word.gsub("**", "<strong>")
        elsif word.include?("*")
          word.gsub("*", "<em>")
        else
          word
        end
      end
      change_end_tag = add_strong_and_em.map do |word|
        if word.end_with?("<strong>")
          word.chomp("<strong>") + "</strong>"
        elsif word.end_with?("<em>")
          word.chomp("<em>") + "</em>"
        else
          word
        end
      end
      @headers_and_lists_ems_strongs_added << change_end_tag.join(" ")
   end

  def output_html
    html_file = @headers_and_lists_ems_strongs_added
    # File.write("my_output.html", html_file[0])
    File.write(ARGV[1], html_file[0])
    p "Converted #{ARGV[0]} (#{@incoming.lines.count} lines) to #{ARGV[1]} (#{} lines)."
    system("open #{ARGV[1]}")
  end
  def parser
    odd_chars
    header_and_list_converter
    strong_em
    output_html
  end
end

file = Chisel.new
file.parser
