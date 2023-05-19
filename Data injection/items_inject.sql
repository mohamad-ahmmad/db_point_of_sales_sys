drop table items_ext;
CREATE TABLE items_ext
(
item_id integer,
item_name varchar2(20),
category varchar2(20),
item_cost number(10,3),
supplier_id integer ,
item_image varchar2(50),
barcode varchar2(15),
location varchar2(30)
)
ORGANIZATION EXTERNAL
(TYPE oracle_loader
DEFAULT DIRECTORY dir_csv
ACCESS PARAMETERS (
RECORDS DELIMITED BY NEWLINE
FIELDS
TERMINATED BY ','
MISSING FIELD VALUES ARE NULL
(item_id CHAR(10),
item_name CHAR(10),
category CHAR(10),
item_cost CHAR(10),
supplier_id CHAR(10) ,
item_image CHAR(10),
barcode CHAR(10),
location CHAR(10))
)
LOCATION ('data_items.csv'))
PARALLEL 5
REJECT LIMIT UNLIMITED;