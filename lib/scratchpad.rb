class Chisel
  
  def initialize(markdown_input) #markdown input must come in as one line only, so will need to parse chunks
    @markdown_array = markdown_input.chars
  end

  def read_file
    file = File.open("my_input.markdown", "r")
    text = file.read
    text.chomp
  end

  def convert_headers
    if markdown_array[0..1] == '# '.chars
      markdown_array.delete_at(1)
      markdown_array[0] = "<h1>"
      markdown_array.push("</h1>")

    elsif markdown_array[0..2] == '## '.chars
      markdown_array.delete_at(2)
      markdown_array[0..1] = "<h2>"
      markdown_array.push("</h2>")

    elsif markdown_array[0..3] == '### '.chars
      markdown_array.delete_at(3)
      markdown_array[0..2] = "<h3>"
      markdown_array.push("</h3>")

    elsif markdown_array[0..4] == '#### '.chars
      markdown_array.delete_at(4)
      markdown_array[0..3] = "<h4>"
      markdown_array.push("</h4>")

    elsif markdown_array[0..5] == '##### '.chars
      markdown_array.delete_at(5)
      markdown_array[0..4] = "<h5>"
      markdown_array.push("</h5>")

    elsif markdown_array[0] != '#'.chars
      # binding.pry
      markdown_array.unshift("<p>")
      markdown_array.push("</p>")
    end
    markdown_array.join
  end

  def convert_emphases


  end

  # markdown_input[0] = "<h1>"
  # markdown_input + "</h1>"
end
