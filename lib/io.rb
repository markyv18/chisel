class Chisel
  attr_reader :incoming_text

  def initialize
    markdown = File.open("my_input.markdown", "r")
    # markdown = File.open("", "r")  ARGV[0]
    @incoming_text = markdown.read
    markdown.close
  end

  def playing_around
    print "Enter your grade: "
    grade = gets.chomp
    case grade
    when "A"
      puts 'Well done!'
    when "B"
      puts 'Try harder!'
    when "C"
      puts 'You need help!!!'
    else
      puts "You just making it up!"
    end

    print "Enter your grade: "
    grade = gets.chomp
    case grade
    when "A", "B"
      puts 'You pretty smart!'
    when "C", "D"
      puts 'You pretty dumb!!'
    else
      puts "You can't even use a computer!"
    end

    print "Enter a string: "
    some_string = gets.chomp
    case
    when some_string.match(/\d/)
      puts 'String has numbers'
    when some_string.match(/[a-zA-Z]/)
      puts 'String has letters'
    else
      puts 'String has no numbers or letters'
    end

  def output_html
    html_file = @incoming_text   # var thing that carries value of converted markdown
    File.write("my_output.html", html_file)
    # File.write(ARGV[1], html_file)
       p "Converted argv0-goes-here (#{incoming_text.lines.count} lines) to argv1-goes-here (#{html_file.lines.count} lines)"
       #{ARGV[0]}
       #{ARGV[1]}
       puts
       p "press enter to open the converted file in a browser tab"
       gets.chomp
      system("open my_output.html")
  end

end

fart = Chisel.new
fart.output_html
