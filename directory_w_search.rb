#let's put all students into an array
def input_students
  puts "Please enter the names of the students"
  puts "To finish just hit return twice"
  # create an empty array
  students = []
  #get the first name
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    #add the student hash to the array
    students << {name: name, cohort: :november}
    puts "Now we have #{students.count} students"
    # get another name from the user
    name = gets.chomp
  end
  #return the array of students
  students
end

def print_header
  puts "The students of Villains Academy"
  puts "---------------"
end

def print(students)
  students.each_with_index do |student, index|
    puts "#{index + 1}. #{student[:name]} (#{student[:cohort].capitalize} cohort)"
  end
end

def filter(students)
  puts "Enter letter you would like to filter students by (first name)"
  letter = gets.chomp.to_s
  filtered_list = students.select {|student| student[:name].start_with?(letter)}
  puts "Search results:"
  puts "---------------"
  print(filtered_list)
  puts "---------------"
  puts "Showing #{filtered_list.count} out of #{students.count} students"
end

def print_footer(students)
  puts "---------------"
  puts "Overall, we have #{students.count} great students"
end


students = input_students
#calling methods to run program
print_header
print(students)
print_footer(students)
filter(students)
