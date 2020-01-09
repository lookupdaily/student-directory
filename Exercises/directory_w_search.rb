#let's put all students into an array
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
    puts "Hobbies(separate multiple answers with ,):"
    hobbies = gets.chomp.strip.split(","||", ")
    puts "Country of birth:"
    country = gets.chomp
    #add the student hash to the array
    students << {name: name, cohort: :november, hobbies: hobbies, country: country}
    puts "Now we have #{students.count} students"
    # get another name from the user
    name = gets.chomp
  end
  #return the array of students
  students
end

#print methods
def print_header
  puts "The students of Villains Academy"
  puts "---------------"
end

def print(students)
  #each method:
  #students.each_with_index do |student, index|
  #  puts "#{index + 1}. #{student[:name]} (#{student[:cohort].capitalize} cohort)"
  #end

  #loop method
  i = 0
  while i < students.count
    puts "#{i + 1}. #{students[i][:name]} | (#{students[i][:cohort].capitalize} Cohort) | #{students[i][:hobbies].join(", ")} | #{students[i][:country]}"
    i += 1
  end

  #until loop method
  #until i == (students.count)
    #puts "#{i + 1}. #{students[i][:name]} (#{students[i][:cohort].capitalize} Cohort)"
  #  i += 1
  #end

end

def print_footer(students)
  puts "---------------"
  puts "Overall, we have #{students.count} great students"
end

#filter methods
def filter_by_length(students)
  rejected = students.select{|student| student[:name].length > 12}
  students.select!{|student| student[:name].length < 12}
  if !rejected.empty?
    puts "We can only accept names less than 12 characters long"
    puts "The following names have been rejected:"
    print(rejected)
  end
end

def filter(students)
  puts "Enter initial you would like to filter students by (first name)"
  letter = gets.chomp.to_s
  filtered_list = students.select {|student| student[:name].start_with?(letter)}
  puts "Search results:"
  puts "Showing students starting with '#{letter}'"
  print(filtered_list)
  puts "---------------"
  puts "#{filtered_list.count} out of #{students.count} students"
end

students = input_students
#calling methods to run program
filter_by_length(students)
print_header
print(students)
print_footer(students)
filter(students)
