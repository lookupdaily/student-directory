def interactive_menu
  students = []
  loop do
    #1. print the menu and ask the user what to do
    puts "1. Input the students"
    puts "2. Show the students"
    puts "9. Exit"
    #2. read the input and save it into a variable
    selection = gets.chomp
    #3. do what the user has asked
    case selection
      when "1"
        students = input_students
      when "2"
        if !students.empty?
          print_header
          list(students)
        end
        print_footer(students)
      when "9"
        exit
      when "exit"
        exit
      else
        puts "error: enter 1-9"
    end
  end
end


#input methods
def input_students
  puts "Please enter details of students"
  puts "To continue/complete hit return (twice to finish)"
  # create an empty array
  students = []
  #get the first name
  puts "Full name:"
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    puts "Cohort (month starting on site):"
    input = gets.chomp.downcase
    month = select_cohort(input)
    puts "Gender (M/F/N):"
    gender = gets.chomp
    puts "Country of birth:"
    country = gets.chomp
    #add the student hash to the array
    students << {name: name, gender: gender, country: country, cohort: month}
    puts "Now we have #{students.count} students"
    # get another name from the user
    puts "Full name:"
    name = gets.chomp
  end
  #return the array of students
  students
end

#validate inputs
def select_cohort(input)
  months = [
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

  while true do
    if input == ""
      selected_month = ["undeclared"]
    else
      selected_month = months.select {|month| month.include?(input)}.flatten!
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

def print_header
  puts "The Students of Villains Academy".center(80)
  puts ""
  puts "-" * 80
  puts ""
end

def list(students)
  students.each_with_index do |student, index|
    puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer(students)
  if students.count == 0
    puts "No students enrolled"
  elsif students.count == 1
    puts "We have 1 great student enrolled".center(80)
  else
    puts "Overall, we have #{students.count} great students".center(80)
  end
end

interactive_menu
