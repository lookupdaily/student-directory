require 'CSV'
#create each student to add to the directory
class Student
  attr_accessor :name, :cohort

  def initialize(name, cohort)
    @name, @cohort = name, cohort
  end

  def record
    return {name: @name, cohort: @cohort.to_sym}
  end

end

#add class for visual environment? menu, print, layout
class Interface


  def initialize
    try_load_students
    header(@directory.title)
    interactive_menu
  end

  def try_load_students
    cli_argument = ARGV.first
    puts "\nWelcome to the Student Directory app"
    puts "-" * 37
    @directory = Directory.new
    if cli_argument.nil?
      welcome
    elsif File.exist?(cli_argument)
      @@filename = cli_argument.to_s
      @directory.load_file
    else 
      puts "Sorry, couldn't locate file: #{cli_argument}."
      welcome
    end
  end
  
  def welcome
    puts "\nWhat would you like to do?\n\n"
    puts "1. Load blank directory"
    puts "2. Load students from 'students.csv'"
    puts "3. Load students from another file"
    print "\nenter 1-3: "
    loop do
      user_input = STDIN.gets.chomp
      if user_input == '1'
        puts "Loading blank directory..."
        break
      elsif user_input == '2' 
        @directory.load_file
        break
      elsif user_input == '3'
        @directory.enter_filename
        @directory.load_file
        break
      else 
        print "Sorry i don't understand. Please enter 1-3: "
      end
    end
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
    puts ""
    puts "1. Input students"
    puts "2. View students"
    puts "3. Save the list"
    puts "4. Load a new directory" 
    # puts "5. Search Directory"
    # puts "6. View records"
    # puts "7. Rename directory"
    # puts "8. Clear directory"
    puts "9. Exit" 
    puts ""
    print "enter 1-9: "
  end

  def process(selection)
    selection.gsub!(".", "") if selection.include?(".")
    case selection
      when "1"
        header("Input Students")
        @directory.input_students
      when "2"
        header("Show Students")
        show_students
      when "3"
        header("Save Directory")
        @directory.save_students 
      when "4"
        header("Load Students")
        prompt_to_save if @directory.unsaved? 
        @directory = Directory.new
        @directory.load_file 
      when "9"
        header("Exit")
        prompt_to_save if @directory.unsaved? 
        puts "Exiting Directory..."
        exit
      else
        puts "error: enter 1-9"
    end
  end

  def header(title)
    puts ""
    puts "-" * 80
    puts ""
    puts title.center(80)
    puts ""
    puts "-" * 80
    puts ""
  end

  def show_students
    @directory.list_count
    @directory.list_students 
  end

  def prompt_to_save
    puts "You have unsaved changes." 
    puts "Do you want to save your directory first?"
    puts ""
    loop do
      print "enter yes -y / no -n / cancel -c: "
      user_input = STDIN.gets.chomp

      if user_input == "yes" || user_input == "y" || user_input == "-y"
        @directory.save_students
        break
      elsif user_input == "no" || user_input == "n" || user_input == "-n"
        break 
      elsif user_input == "cancel" || user_input == "c" || user_input == "-c"
        interactive_menu
        break
      else 
        puts "Not an option. Try again."
      end 
    end
    return
  end

end
#add separate classes for session and database?

#load, view, edit, and save the directory
class Directory
  attr_accessor :students, :filename, :title 

  def initialize(academy = "Villains Academy")
    @students = []
    @@filename = "students.csv"
    @title = nil
    # header
    # interactive_menu
  end  
  
  def set_title
    print "Enter academy title: "
    @academy = STDIN.gets.chomp

    @academy = "New Student Directory" if @academy.size < 1
  end

  def title
    set_title if @academy.nil?
    @academy
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

  def save_students
    puts "To save students to '#{@@filename}' hit return."
    print "Or "
    enter_filename 

    CSV.open(@@filename, "w") do |csv|
      csv.truncate(0)
      @students.each do |student|
        csv << [student[:name], student[:cohort]]
      end
    end
    puts "#{student_count} saved to #{@filename}"
  end

  def load_file
    puts "To load #{@@filename} hit return."
    print "Or "
    enter_filename 

    if File.exist?(@@filename)
      CSV.foreach(@@filename) do |row|
        name, cohort = row
        break if name.nil?
        add(name)
      end
      puts "#{student_count} loaded from #{@@filename}\n\n"
    else
      puts "Couldn't locate file: #{@@filename}"
      return
    end
  end

  def enter_filename
    print "enter filename: "
    answer = STDIN.gets.chomp
    @@filename = answer unless answer.size < 1
  end

  def session_data
    student_data = []
    @students.each do |student|
      student_data << [student[:name], student[:cohort].to_s]
    end
    student_data
  end

  def unsaved?
    if !File.exist?(@@filename)
      true
    elsif session_data != CSV.read(@@filename) 
      true
    else
      false
    end
  end

  def list_students
    @students.each_with_index do |student, index|
      puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
    end
    puts ""
  end

  def list_count
    if @students.count > 0  
      puts "Showing #{@students.count} out of #{student_count}".center(80, "-")
    else
      puts "There are currently no students in Villains Academy".center(80, "-")
    end
    puts ""
  end

  private

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


end
# puts File.read(__FILE__)
session = Interface.new

