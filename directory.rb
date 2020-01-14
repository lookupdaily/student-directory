require 'CSV'
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
    #@title = "New Student Directory"
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
    puts "4. Load a new directory" 
    # puts "5. Search Directory"
    # puts "6. View records"
    # puts "7. Rename directory"
    # puts "8. Clear directory"
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
        show_students
      when "3"
        header("Save Directory")
        save_students
      when "4"
        header("Load Students")
        save_prompt
        load_file
        # should this start a new session? 
        # user should be prompted to save work
      when "9"
        header("Exit")
        save_prompt
        puts "Exiting Directory..."
        exit
        # user should be prompted to save work
      when "exit"
        header("Exit")
        save_prompt
        puts "Exiting Directory..."
        exit
        # user should be prompted to save work
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

    CSV.open(@filename, "w") do |csv|
      @students.each do |student|
        csv << [student[:name], student[:cohort]]
      end
    end
    puts "#{student_count} saved to #{@filename}"
  end

  def save_prompt
    puts "This option will cause you to lose any unsaved changes." 
    puts "Do you want to save your directory first?"
    loop do
      puts "enter yes -y) / no -n / cancel -c)"
      user_input = gets.chomp

      if user_input == "yes" || user_input == "y" || user_input == "-y"
        save_students
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

  def load_file
    print "To load #{@filename} hit return. Or "
    enter_filename 

    if File.exist?(@filename)
      CSV.foreach(@filename) do |row|
        name, cohort = row
        add(name)
      end
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

