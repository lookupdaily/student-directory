module Info
  COHORTS = [
    ["january", "jan", 1],
    ["february", "feb", 2],
    ["march", "mar", 3],
    ["april", "apr", 4],
    ["may", 5],
    ["june", "jun", 6],
    ["july", "jul", 7],
    ["august", "aug", 8],
    ["september", "sep", 9],
    ["october", "oct", 10],
    ["november", "nov", 11],
    ["december", "dec", 12]
  ]

  STUDENT_INFO = ["Forename", "Surname", "Gender", "Cohort", "Nationality", "Hobbies"]
end

require 'CSV'
#create each student to add to the directory
class Student
  include Info
  attr_accessor :name, :surname, :gender, :cohort, :country, :hobbies

  def initialize(info = {})
    if info.size < 1
      create
    else 
      @name = info.fetch(:name)
      @surname = info.fetch(:surname)
      @gender = info.fetch(:gender)
      @cohort = info.fetch(:cohort)
      @country = info.fetch(:country)
      @hobbies = info.fetch(:hobbies)
    end
  end

  def create
    puts "\n" + "-" * 40
    print "\nFirst name: "
    @name = STDIN.gets.chomp
    return if name.size < 1 || name == "#"
    print "Surname: "
    @surname = STDIN.gets.chomp
    print "Cohort (month starting on site): "
    @cohort = select_cohort(gets.chomp.downcase)
    print "Gender (M/F/N): "
    @gender = STDIN.gets.chomp
    print "Country of birth: "
    @country = STDIN.gets.chomp
    print "Favourite hobby: " 
    @hobbies = STDIN.gets.chomp
  end

  def load

  end

  def record
    return {name: @name.downcase, surname: @surname.downcase, gender: @gender.downcase, cohort: @cohort.downcase, country: @country.downcase, hobbies: @hobbies.downcase} unless @name.empty?
  end

  def select_cohort(input)
    while true do
      if input == ""
        selected_month = ["undeclared"]
      else
        selected_month = COHORTS.select {|month| month.include?(input)}.flatten!
      end
  
      if selected_month == nil
        puts "You entered an invalid month. Please enter again"
        input = gets.chomp.downcase
      else
        break
      end
  
    end
  
    cohort = selected_month[0].to_sym
  
  end

end

#add class for visual environment? menu, print, layout
class Interface
  include Info

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
    puts "2. Load students from file"
    print "\nenter 1 or 2: "
    loop do
      user_input = STDIN.gets.chomp
      if user_input == '1'
        puts "Loading blank directory..."
        break
      elsif user_input == '2' 
        @directory.load_file
        break
      else 
        print "Sorry i don't understand. Please enter 1 or 2: "
      end
    end
  end

  def interactive_menu
    loop do
      print_menu
      process(STDIN.gets.chomp)
    end
  end

  MENU = ["","Add Students","View Students","Filter Students","View Cohorts","Save Directory","Rename Directory","New Directory","Load Directory","Exit"]

  #menu methods
  def print_menu
    puts ""
    puts " MENU ".center(18, "-")
    puts ""
    MENU.each_with_index do |item, index|
      print "#{index}. " unless index == 0
      puts item
    end
    puts ""
    print "enter 1-9: "
  end

  def process(selection)
    selection.gsub!(".", "") if selection.include?(".")
    item = selection.to_i
    header(MENU[item]) if item > 0 && item < 10
    case item
      when 1
        @directory.input_students
      when 2
        show_students
      when 3
        filter_menu
      when 4
        sort_by_cohort  
      when 5
        @directory.save_students 
      when 6
        @directory.set_title
        puts "Academy title updated to: #{@directory.title}"
        header(@directory.title)
      when 7
        prompt_to_save if @directory.unsaved? 
        @directory = Directory.new  
      when 8
        prompt_to_save if @directory.unsaved? 
        @directory = Directory.new
        @directory.load_file 
      when 9
        prompt_to_save if @directory.unsaved? 
        puts "Exiting Directory..."
        exit
      else
        puts "error: enter 1-9"
    end
  end

  def header(title = "New")
    puts ""
    puts "-" * 80
    puts ""
    puts "#{@directory.title} Student Directory".center(80)
    puts ""
    puts title.upcase.center(80) unless title.empty?
    puts "" unless title.empty?
    puts "-" * 80
    puts ""
  end

  def list_fields
    puts ""
    STUDENT_INFO.each_with_index { |info, index| puts "#{index + 1}. #{info}"}
    puts ""
  end

  def sort_by_cohort
    COHORTS.each do |cohort|
      @directory.filter_by_cohort(cohort[0])
    end
    @directory.list_count
  end

  def filter_menu
    puts "Which information would you like to filter students by?"
    list_fields
    loop do
      print "enter 1-6: "
      input = STDIN.gets.chomp
      case input
      when "1"
        @directory.filter_by(:name)
        break
      when "2"
        @directory.filter_by(:surname)
        break
      when "3"
        @directory.filter_by(:gender)
        break
      when "4"
        @directory.filter_by(:cohort)
        break
      when "5"
        @directory.filter_by(:country)
        break
      when "6"
        @directory.filter_by(:hobbies)
        break
      else 
        print "Sorry I don't understand. Please "
      end 
    end
    # filter_students(field)
  end

  def show_students
    @directory.list_students 
    @directory.list_count
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
      student = Student.new 
      break if student.record.nil?
      @students << student.record
      #add(name)
    end
    puts "END INPUT"
    puts "Now we have #{student_count}"
  end

  def filter_by(field)
    puts "\nEnter search term: "
    search = STDIN.gets.chomp.downcase
    if search.size == 1
      filtered = @students.select {|student| student[field].start_with?(search)}
    else 
      filtered = @students.select {|student| student[field].include?(search)}
    end
    show_results(search, filtered)
  end

  def filter_by_cohort(cohort)
    filtered = @students.select {|student| student[:cohort] == cohort}
    puts "#{cohort.capitalize} Cohort:"
    puts ""
    if !filtered.empty?
      list_students(filtered) 
    else
      puts "No students enrolled in cohort yet."
    end
    puts "-" * 80
  end

  def show_results(search, search_results)
    puts "\nSearch results for '#{search}':"
    puts "-" * 80
    list_students(search_results)
    list_count(search_results)
  end
  
    
  def save_students
    puts "To save students to '#{@@filename}' hit return."
    print "Or "
    enter_filename 

    CSV.open(@@filename, "w") do |csv|
      csv.truncate(0)
      compile_to(csv)
    end
    puts "#{student_count} saved to #{@@filename}"
  end


  def choose_file
    puts "To load #{@@filename} hit return."
    print "Or "
    enter_filename 
  end

  def load_file
    choose_file

    if File.exist?(@@filename)
      CSV.foreach(@@filename) do |row|
        name , surname , gender , cohort , country , hobbies = row
        break if name.nil?
        student = Student.new(name: name, surname: surname, gender: gender, cohort: cohort, country: country, hobbies: hobbies)
        @students << student.record
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

  def compile_to(destination)
    @students.each do |student|
      student_array = []
      student.each_value {|value| student_array.push(value.to_s)}
      destination << student_array
    end
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

  def list_students(students = @students)
    students.each_with_index do |student, index|
      puts "#{index + 1}. #{student[:name].capitalize} #{student[:surname].capitalize}, #{student[:cohort].capitalize} Cohort, #{student[:gender].capitalize}, #{student[:country].upcase}"
    end
  end

  def list_count(students = @students)
    puts ""
    if students.count > 0  
      puts "Showing #{students.count} out of #{student_count}".center(80, "-")
    else
      puts "There are currently no students to show.".center(80, "-")
    end
    puts ""
  end

  private

  # def add()
  #   student = Student.new(name, surname, gender, cohort, country, hobbies)
  #   @students << student.record
  # end

  def student_count
    if @students.count == 1
      "1 student"
    else
      "#{@students.count} students"
    end
  end

  def session_data
    student_data = []
    compile_to(student_data)
    student_data
  end

end
session = Interface.new

