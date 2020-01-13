#create each student to add to the directory
class Student
  def initialize(name, cohort)
    @name, @cohort = name, cohort
  end

  def record
    return {name: @name, cohort: @cohort.to_sym}
  end

end

#load, view, edit, and save the directory
class Directory
  def initialize
    @students = []
    try_load_students
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
    puts "1. Input the students"
    puts "2. Show the students"
    puts "3. Save the list"
    puts "4. Load the list"
    puts "9. Exit"
  end

  def process(selection)
    selection.gsub!(".", "") if selection.include?(".")
    case selection
      when "1"
        input_students
      when "2"
        show_students
      when "3"
        save_students
      when "4"
        load
      when "9"
        exit
      when "exit"
        exit
      else
        puts "error: enter 1-9"
    end
  end

  def input_students
    puts "Please enter the names of the students"
    puts "To finish just hit #"

    loop do
      name = STDIN.gets.chomp
      break if name == "#"
      add(name)
    end
    puts "Now we have #{student_count}"
  end

  def show_students
    unless @students.empty?
      print_header
      print_students
    end
    print_footer
  end

  def save_students
    file = File.open("students.csv", "w")

    @students.each do |student|
      student_data = [student[:name], student[:cohort]]
      csv_line = student_data.join(",")
      file.puts csv_line
    end
    file.close
    puts "#{student_count} saved to 'students.csv'"
  end

  def load(filename = "students.csv")
    file = File.open(filename, "r")
    file.readlines.each do |line|
      name, cohort = line.chomp.split(",")
      add(name)
    end
    file.close
    puts "#{student_count} loaded from #{filename}"
  end

  private
  def try_load_students
    filename = ARGV.first || "students.csv"

    if File.exist?(filename)
      load(filename)
    else
      puts "Sorry, #{filename} doesn't exist." unless filename == "students.csv"
      puts "Loaded blank directory"
      return
    end
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

  def print_header
    puts "The Students of Villains Academy".center(80)
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
    puts "We have #{student_count} enrolled."
    puts "-" * 80
    puts ""
  end

end

Directory.new

