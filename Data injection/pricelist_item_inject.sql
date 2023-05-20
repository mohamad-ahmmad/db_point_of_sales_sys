/* Formatted on 20-May-2023 11:36:14 (QP5 v5.276) */
--DROP TABLE pricelist_item_ext;

CREATE TABLE pricelist_item_ext
(
    pl_id     INTEGER,
    item_id   INTEGER,
    price     NUMBER (10, 3)
)
ORGANIZATION EXTERNAL
    (TYPE oracle_loader
          DEFAULT DIRECTORY dir_csv
              ACCESS PARAMETERS (
                  RECORDS DELIMITED BY NEWLINE
                  FIELDS
                      TERMINATED BY ','
                  MISSING FIELD VALUES ARE NULL
                  (pl_id CHAR(50), item_id CHAR(50), price CHAR(50))
              )
          LOCATION ('data_pricelist_item.csv'))
    PARALLEL 5
    REJECT LIMIT UNLIMITED;

INSERT INTO pricelist_item
    SELECT * FROM pricelist_item_ext;