#create each student to add to the directory
class Student
  def initialize(name, cohort)
    @name, @cohort = name, cohort
  end

  def record
    return {name: @name, cohort: @cohort.to_sym}
  end

end

#add class for visual environment? menu, print, layout
#add separate classes for session and database?

#load, view, edit, and save the directory
class Directory
  def initialize
    @students = []
    @filename = nil
    try_load_students
    header
    interactive_menu
  end

  def interactive_menu
    loop do
      print_menu
      process(STDIN.gets.chomp)
    end
  end

  #menu methods
  def print_menu
    puts ""
    puts " MENU ".center(18, "-")
    puts "\n" + "(enter 1-9)".center(18) + "\n\n"
    puts "1. Input students"
    puts "2. View students"
    puts "3. Save the list"
    puts "4. Load a list"
    puts "9. Exit"
  end

  def process(selection)
    selection.gsub!(".", "") if selection.include?(".")
    case selection
      when "1"
        header("Input Students")
        input_students
      when "2"
        header("Show Students")
        puts ""
        show_students
      when "3"
        header("Save Directory")
        save_students
      when "4"
        header("Load Students")
        load_file
        show_students
      when "9"
        puts "Exiting Directory..."
        exit
      when "exit"
        puts "Exiting Directory..."
        exit
      else
        puts "error: enter 1-9"
    end
    
  end
  
  def input_students
    puts "Please enter the names of the students"
    puts "To finish just return twice or hit #"

    loop do
      name = STDIN.gets.chomp
      break if name.size < 1 || name == "#"
      add(name)
    end
    puts "Now we have #{student_count}"
  end

  def show_students
    print_students unless @students.empty?
    print_footer
  end

  def enter_filename
    puts "enter new filename:"
    answer = gets.chomp
    @filename = answer unless answer.size < 1
    #@filename += ".csv" unless @filename.include?(".csv") 
  end

  def save_students
    print "To save students to #{@filename} hit return. Or "
    enter_filename 

    file = File.open(@filename, "w")

    @students.each do |student|
      student_data = [student[:name], student[:cohort]]
      csv_line = student_data.join(",")
      file.puts csv_line
    end
    file.close
    puts "#{student_count} saved to #{@filename}"
  end

  def load_file
    print "To load #{@filename} hit return. Or "
    enter_filename 

    if File.exist?(@filename)
      file = File.open(@filename, "r")
      file.readlines.each do |line|
        name, cohort = line.chomp.split(",")
        add(name)
      end
      file.close
      puts "#{student_count} loaded from #{@filename}\n\n"
    else
      puts "Sorry, #{@filename} doesn't exist." 
      return
    end
  
  end

  private
  def try_load_students
    @filename = ARGV.first || "students.csv"
    load_file
    puts "Loaded blank directory" if !File.exist?(@filename)
  end

  def add(name)
    student = Student.new(name, :november)
    @students << student.record
  end

  def student_count
    if @students.count == 1
      "1 student"
    else
      "#{@students.count} students"
    end
  end

  def header(title = "The Students of Villains Academy")
    puts ""
    puts "-" * 80
    puts ""
    puts title.center(80)
    puts ""
    puts "-" * 80
    puts ""
  end

  def print_students
    @students.each_with_index do |student, index|
      puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
    end
    puts ""
  end

  def print_footer
    puts "Showing #{@students.count} out of #{student_count}"
    puts "-" * 80
    puts ""
  end

end

Directory.new

