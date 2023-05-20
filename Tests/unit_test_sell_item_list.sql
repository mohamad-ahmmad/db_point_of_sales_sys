-- PROGRAM UNIT TO TEST SELL_ITEM_LIST() FUNCTION

DECLARE
    items_info item_info_array := item_info_array();
    
    -- 1. CREATE A RELATION OF JOINS AND SELECTS FROM DATA STORED IN DATABASE
    CURSOR gathered_items IS
    SELECT 
    pl_i.item_id p_item_id,
    floor(dbms_random.VALUE * 20) + 1 p_quantity,
    1 p_item_discount,
    0.1 p_item_tax,
    event p_event
    FROM 
    pricelist_item pl_i INNER JOIN pricelist pl ON pl_i.pl_id = pl.pl_id WHERE ROWNUM <= 1000;
    
    item_row item_info := item_info(1,1,1,1,'hi');
    messages messages_type := messages_type();
    
BEGIN
    ------------- FILL A TABLE OF ITEM_INFO ------------------
    
    -- 2. USE A CURSOR TO INSERT THIS DATA INTO THE ITEM_INFO_ARRAY
    OPEN gathered_items;
    LOOP 
    EXIT WHEN gathered_items%NOTFOUND;
        FETCH gathered_items INTO 
        item_row.p_item_id,
         item_row.p_quantity,
          item_row.p_item_discount, 
          item_row.p_item_tax, 
          item_row.p_event;
        items_info := items_info MULTISET UNION item_info_array(
        item_info(
            item_row.p_item_id,
         item_row.p_quantity,
          item_row.p_item_discount, 
          item_row.p_item_tax, 
          item_row.p_event)
        );
        --INSERT INTO items_info
        --VALUES item_row;
        
        
    END LOOP;
    CLOSE gathered_items;
    
    -- 3. CALL THE SELL_ITEM_LIST() AND PASS THE TABLE TO IT
    messages := sell_items_list(items_info);
    
    FOR i IN 1 .. messages.COUNT - 1
    LOOP
        dbms_output.put_line(messages(i));
    END LOOP;

END;
/