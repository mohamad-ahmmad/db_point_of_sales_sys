/* Formatted on 19-May-2023 14:23:29 (QP5 v5.276) */
ALTER SESSION SET nls_date_format = 'YYYY-MM-DD';

DROP TABLE inventory_ext;

CREATE TABLE inventory_ext
(
    item_id       INTEGER,
    expiry_date   DATE,
    quantity      INTEGER
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
                   expiry_date DATE 'YYYY-MM-DD',
                   quantity CHAR(100))
              )
          LOCATION ('data_inventory.csv'))
    PARALLEL 5
    REJECT LIMIT UNLIMITED;

INSERT INTO inventory
    SELECT * FROM inventory_ext;