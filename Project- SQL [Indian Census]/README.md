
# Indian Census 2011 Data

In this project I have taken 2 dataset and will try to extract certain data with the help of SQL queries. 

## Tech Stack

Used MYSQL Workbench for performing the SQL Queries.


## Challenges

Below are some Challenges that occured after importing the dataset:

1) While checking the datatypes of variables in files using the below mentioned command, it was found that datatype are not correct then taken the neccessary action for correcting the datatype.

    describe data1;

    describe data2;


 2) While checking the content of files using the below mentioned command, it was found that there are some unnecessary characters like ('%' ',') that will create issue while performing queries on data, so removed those unnecessary characters.


    select * from data1;

    select * from data2;




## Documentation

For the output screenshots of the commands, the answers for the related questions is attached in below mentioned document.

[Outputs](https://github.com/jayantjy9/SQL/blob/main/Project-%20SQL%20%5BIndian%20Census%5D/Outputs.docx)


## Appendix

Take reference from below two sites for the dataset1 and dataset2.

1. https://www.census2011.co.in/district.php
2. https://www.census2011.co.in/literacy.php

## Authors

- [@jayant_yadav](https://www.github.com/jayantjy9)

