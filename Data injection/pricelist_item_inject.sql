/* Formatted on 5/19/2023 11:08:56 PM (QP5 v5.276) */
--DROP TABLE pricelist_item_ext;

CREATE TABLE pricelist_item_ext
(
    pl_id integer,
item_id integer,
price number(10,3)
)
ORGANIZATION EXTERNAL
    (TYPE oracle_loader
          DEFAULT DIRECTORY dir_csv
              ACCESS PARAMETERS (
                  RECORDS DELIMITED BY NEWLINE
                  FIELDS
                      TERMINATED BY ','
                  MISSING FIELD VALUES ARE NULL
                  (pl_id CHAR(50),
item_id CHAR(50),
price CHAR(50))
              )
          LOCATION ('data_pricelist_item.csv'))
    PARALLEL 5
    REJECT LIMIT UNLIMITED;

--INSERT INTO pricelist_item
  --  SELECT * FROM pricelist_item_ext;