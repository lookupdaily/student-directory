@students = []

def interactive_menu
  loop do
    print_menu
    process(gets.chomp)
  end
end

#menu methods
def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "9. Exit"
end

def show_students
  if !@students.empty?
    print_header
    print_students
  end
  print_footer
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "9"
      exit
    when "exit"
      exit
    else
      puts "error: enter 1-9"
  end
end

#input methods
def input_students
  puts "Please enter the names of the students"
  puts "To finish just hit return twice"
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    #add the student hash to the array
    @students << {name: name, cohort: :november}
    puts "Now we have #{@students.count} students"
    # get another name from the user
    puts "Full name:"
    name = gets.chomp
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
  if @students.count == 0
    puts "No students enrolled"
  elsif @students.count == 1
    puts "We have 1 great student enrolled"
  else
    puts "Overall, we have #{@students.count} great students"
  end
  puts "-" * 80
  puts ""
end

interactive_menu
