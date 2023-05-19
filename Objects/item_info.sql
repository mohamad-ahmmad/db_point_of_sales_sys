CREATE OR REPLACE TYPE item_info AS OBJECT (
    p_item_id Number,
    p_quantity Number,
    p_item_discount Number,
    p_item_tax Number,
    p_event varchar2(30 byte)
);