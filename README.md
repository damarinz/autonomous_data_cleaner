# About this tool

Data cleansing tool for Oracle Autonomous Data Warehouse CSV file.

This tool can remove contaminated data in your csv.

example:  "aabbccdd","None","---","..." in Number column.

# Licence

MIT

# Usage

1. clone from github
2. install Ruby 2.6.0 or later(might be work 2.1 or later)

```bazaar
% ruby lib/adw_data_cleaner.rb <create_table_sql_file> <csv_data_file>
```

```example

% ruby lib/adw_data_cleaner.rb ./test/sample_schema.sql ~/Downloads/foobar.csv

```



You can download "CREATE TABLE" schema from SQL Developer.

```sample_schema.sql
        CREATE TABLE KOURIKAKAKU
           (column0 number(2),
           column1 varchar2(10),
           column2 varchar2(6),
           column3 varchar2(80),
           column4 varchar2(5),
           column5 varchar2(30),
           column6 number(12),
           column7 varchar2(12),
           column8 varchar2(10),
           column9 number(8),
           column10 varchar2(20),
           column11 number(8),
           column12 varchar2(80),
           column13 varchar2(20),
           column14 varchar2(20)
           )
        ;

```


## Copyright / Author

Bungo Tamari

the test data from e-stat.go.jp


