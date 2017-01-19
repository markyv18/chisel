class Chisel
  attr_reader :incoming_text, :incoming

  def initialize
    markdown = File.open("./lib/my_input.markdown", "r")
    # markdown = File.open("", "r")  ARGV[0]
    @incoming = markdown.read
    @incoming_text = incoming.split("\n\n")
    markdown.close
    @headers_and_lists_added = []
    @strong_added = []
    @emphasis_addded = []
    @num = (1...100)
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
        # when "*"
        #   #call the unordered list method
        # when "#{@num}."
        #   # call the ordered list method
        # else
        #   paragraph #call paragraph method
        end
        @headers_and_lists_added << line.join(" ")
      end
    end

    def strong
      # working_line = []
      # strong_line = []
      @headers_and_lists_added.each do |lines|
        lines.include? (

        replace with </>
        then .find and replace first instance with ... <>
        )
        require "pry"; binding.pry
        working_line = lines.split(" ")
        working_line.each do |line|
          case
          when (line[0] == "*") && (line[-1] == "*")
            line[0].gsub!("*", "<em>")
            line[-1].gsub!("*","</em>")
          else
            line
          end
           strong_line << line
        end
      end
    end

    # def emphasis
    #   @strong_added.map do |lines|
    #
    # end



    # def paragraph
    #   @headers_added.map do |lines_become_ps|
    #
    #
    # end

    # def unordered
    #   @headers_added.map do |lines|
    #
    #
    # end

    # def ordered
    #   @headers_added.map do |lines|
    #
    #
    # end

  def output_html
    html_file = @headers_and_lists_added.join #change as needed per running of methods
    File.write("my_output.html", html_file)
    # File.write(ARGV[1], html_file) add this when ready to use with passed in file names on terminal line run

    p "Converted my_input.markdown (argv0-goes-here-later) (#{@incoming.lines.count} lines) to my_output.html (argv1-goes-here-later) (#{}  working on 'after' counter lines)"
       #{ARGV[0]} #{ARGV[1]} these go into the p line above

      #  p "press enter to open the converted file in a browser tab"
      #  gets.chomp
      # system("open my_output.html") these three lines prompt user to see the converted file in a browser tab
  end
  def parser
    header_and_list_converter
    # strong #have to run OL and UL before <em> and <strong>
    # emphasis
    require "pry"; binding.pry
    output_html
  end
end

file = Chisel.new
file.parser
