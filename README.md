# student-directory #

The student directory script allows you to create and manage the list of students enrolled at Villains Academy.

## How to use ##

To run main directory:

```shell
ruby directory.rb
```

### Loading existing data into the directory ###

You can also load a file containing existing students when running the app:

```shell
ruby directory.rb <filename.csv>
```  
The directory can only take csv files, and data must be saved in the following format (no column headers):

| name | surname | gender | cohort | country | hobby |
| ---- | ------- | ------ | ------ | ------- | ----- |
| name | surname | gender | cohort | country | hobby |
| name | surname | gender | cohort | country | hobby |


If no file is given, a new file is created when selecting 'save' from within the app. You can also load data files at any point from within the app. 

A populated file has been provided within this repo as an example. You can load it by typing `ruby directory.rb students.csv` in the command line, or the file is given as an option when selecting 'load' within the app.