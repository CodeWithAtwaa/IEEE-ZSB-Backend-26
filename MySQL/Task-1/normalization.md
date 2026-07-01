# The Normalization Challenge single table into 3rd Normal Form (3NF)


## Single table: `Student_Grade_Report`

#### Columns: 
* Student_Name
* Student_Phone
* Student_Address
* Course_Title
* Instructor_Name
* Instructor_Dept 
*  Dept_Building
*  Grade

The Table contain legacy data (step 0) to convert it into **3NR**

## Step 1 `1 NF`

### Rules
* Remove the multi-valued
* split compostie


## Table after 1NF

### student
* id
* name
* Zip
* city
* street

### student_phone
* std_id
* phone

----------



## Step 2 `2 NF`

### Rules
* must be in `1NF`
* every none-prime depend on prime (PK --> none-prime)
* PK (std_name, Course_titel)


## Table after 2NF

### course
* id 
* title
* inst_name
* inst_dept

### Enrollment
* std_id
* course_id
* grade


------------


## Step 3 `3 NF`

### Rules
* must be in `2NF`
* every none-prime depend on none-prime (none-prie ----> PK ---> none-prime)
* Transtive


## Table after 3NF

### department
* id
* name
* location

### instuctor
* id
* name
* dep_id


--------------------------------

# final tables after Normaliztion


### student
* id
* name
* Zip
* city
* street

### student_phone
* std_id
* phone


### course
* id 
* title
* instr_id

### Enrollment
* std_id
* course_id
* grade


### department
* id
* name
* location

### instuctor
* id
* name
* dep_id









