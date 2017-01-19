class Chisel
  attr_reader :incoming_text, :incoming

  def initialize
    markdown = File.open("./lib/my_input.markdown", "r")
    # markdown = File.open("", "r")  ARGV[0]
    @incoming = markdown.read
    @incoming_text = incoming.split("\n\n")
    markdown.close
    @headers_and_lists_added = []
    @headers_and_lists_ems_strongs_added = []
    @num = (1...100)
    require "pry"; binding.pry
  end

  def header_and_list_converter
    if @incoming_text.join.include?(":*")
      unordered_list
    end

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
        # when "#{@num}."
           # call the ordered list method
        else
          line.insert(0, "<p>").insert(-1, "</p>\n")
        end
        @headers_and_lists_added << line.join(" ")
      end
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

  def unordered_list
    a = @incoming_text.join
    if a.include?(":*")
  end

    # def ordered
    #   @headers_added.map do |lines|
    #
    #
    # end

  def output_html
    html_file = @headers_and_lists_ems_strongs_added #change as needed per running of methods
    File.write("my_output.html", html_file[0])
    # File.write(ARGV[1], html_file) add this when ready to use with passed in file names on terminal line run

    # p "Converted my_input.markdown (argv0-goes-here-later) (#{@incoming.lines.count} lines) to my_output.html (argv1-goes-here-later) (#{}  working on 'after' counter lines)"
       #{ARGV[0]} #{ARGV[1]} these go into the p line above

      #  p "press enter to open the converted file in a browser tab"
      #  gets.chomp
      # system("open my_output.html") these three lines prompt user to see the converted file in a browser tab
  end
  def parser
    header_and_list_converter
    strong_em
    output_html
  end
end

file = Chisel.new
file.parser
