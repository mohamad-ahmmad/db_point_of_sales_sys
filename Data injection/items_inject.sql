/* Formatted on 19-May-2023 13:56:33 (QP5 v5.276) */
DROP TABLE items_ext;

CREATE TABLE items_ext
(
    item_id       INTEGER,
    item_name     VARCHAR2 (20),
    category      VARCHAR2 (20),
    item_cost     NUMBER (10, 3),
    supplier_id   INTEGER,
    item_image    VARCHAR2 (50),
    barcode       VARCHAR2 (15),
    location      VARCHAR2 (30)
)
ORGANIZATION EXTERNAL
    (TYPE oracle_loader
          DEFAULT DIRECTORY dir_csv
              ACCESS PARAMETERS (
                  RECORDS DELIMITED BY NEWLINE
                  FIELDS
                      TERMINATED BY ','
                  MISSING FIELD VALUES ARE NULL
                  (item_id CHAR(100),
                   item_name CHAR(100),
                   category CHAR(100),
                   item_cost CHAR(100),
                   supplier_id CHAR(100),
                   item_image CHAR(100),
                   barcode CHAR(100),
                   location CHAR(100))
              )
          LOCATION ('data_items.csv'))
    PARALLEL 5
    REJECT LIMIT UNLIMITED;

INSERT INTO item
    SELECT * FROM items_ext;