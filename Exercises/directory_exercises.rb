#test students in array
#students = [["Dr. Hannibal Lecter", "M", "USA" , :november], ["Darth Vader", "M", "USA", :february], ["Nurse Ratched", "F", "UK", :november], ["Michael Corleone", "M", "USA", :january], ["Alex DeLarge", "M", "France", :november], ["The Wicked Witch of the West", "F", "Oz", :march], ["Terminator", "N", "UK", :january], ["Freddy Krueger", "M", "USA", :february], ["The Joker", "M", "USA", :february], ["Joffrey Baratheon", "M", "USA", :november], ["Norman Bates", "M", "UK", :december]]

#adding students
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
    puts "Hobbies (separate with ,):"
    hobbies = gets.chomp.strip.split(","||", ")
    #add the student hash to the array
    students << {name: name, gender: gender, country: country, hobbies: hobbies, cohort: month}
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

#print methods
def print_header
  puts "The students of Villains Academy".center(80)
  puts ""
  puts "-" * 80
  puts ""
end

def list(students)
  #iterator method:
  students.each_with_index do |student, index|
    print "#{index + 1}."
    print "#{student[:name]}".center(29)
    print "|"
    print "#{student[:gender]}".center(9)
    print "|"
    print "#{student[:country]}".center(9)
    print "|\n"
    #print "#{student[:cohort].capitalize} Cohort".center(20) + "\n"
  end

end

def list_by_cohort(students)
  cohorts = []

  students.each do |student|
    cohorts << student[:cohort] unless cohorts.include?(student[:cohort])
  end

  cohorts.each do |cohort|
    puts "#{cohort.capitalize} Cohort:"
    puts ""
    list(students.select {|student| student[:cohort] == cohort})
    puts "-" * 80
  end

end

  #loop method
  #i = 0
  #while i < students.count
  #  string = "#{i + 1}. #{students[i][:name]} | (#{students[i][:cohort].capitalize} Cohort) | #{students[i][:hobbies].join(", ")} | #{students[i][:country]}"
  #  puts string.center(80)
  #  i += 1
  #end

  #until loop method
  #until i == (students.count)
    #puts "#{i + 1}. #{students[i][:name]} (#{students[i][:cohort].capitalize} Cohort)"
  #  i += 1
  #end

def print_footer(students)
  puts ""
  puts "-" * 80
  puts ""
  puts "Overall, we have #{students.count} great students".center(80)
end

#filter methods
def filter_by_length(students)
  rejected = students.select{|student| student[:name].length > 12}
  students.select!{|student| student[:name].length < 12}
  if !rejected.empty?
    puts "We can only accept names less than 12 characters long"
    puts "The following names have been rejected:"
    list(rejected)
  end
end

def filter(students)
  puts "Enter initial you would like to filter students by (first name)"
  letter = gets.chomp.to_s
  filtered = students.select {|student| student[:name].start_with?(letter)}
  puts "Search results:"
  puts "Showing students starting with '#{letter}'"
  puts "-" * 80
  list(filtered)
  puts "-" * 80
  puts "#{filtered.count} out of #{students.count} students".center(80)
end

students = input_students
#calling methods to run program
#filter_by_length(students)
print_header
#list(students)
list_by_cohort(students)
print_footer(students)
#existing_cohorts(students)
#filter(students)
