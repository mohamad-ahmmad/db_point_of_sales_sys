CREATE OR REPLACE FUNCTION sell_items_list (
    item_arr item_info_array 
)
RETURN messages_type

IS 
    sales_order_rec sales_order%rowtype;
    message varchar2(100);
    messages messages_type := messages_type();
BEGIN

    -- DEFINE A NEW RECORD OF SALES ORDER WITH A SEQ.NEXTVAL
    sales_order_rec.so_id := sales_order_seq.NEXTVAL;

    INSERT INTO sales_order (so_id)
    VALUES (sales_order_rec.so_id);
    -- LOOP OVER THE ARRAY IN THE PARAMTER    
    FOR i IN 1 .. item_arr.COUNT
    LOOP
    -- FOR EACH ELEMENT, CALL THE SELL_ITEMS() AND PASS THAT ELEMENT ALONG WITH SEQ.CURVAL
        message := sell_items(item_arr(i), sales_order_rec.so_id);
        messages := messages MULTISET UNION messages_type(message);
    END LOOP;
    -- AFTER THE LOOP, FILL THE REST OF THE SALES ORDER RECORD WITH THE APPROPRIATE DATA
    
    -- 1. NET_AMOUNT = SUM( PRICE ) FOR SALES ORDER DETAILS 
    SELECT SUM(PRICE)
    INTO sales_order_rec.net_amount
    FROM sales_order_details
    WHERE so_id = sales_order_rec.so_id;
    
    
    -- 2. SALES_AMOUNT = SUM( QUANTITY ) FOR SALES ORDER DETAILS
    SELECT SUM(quantity)
    INTO sales_order_rec.sales_amount
    FROM sales_order_details
    WHERE so_id = sales_order_rec.so_id;
    
    -- 3. DATE IS SYSDATE
    sales_order_rec.so_date := sysdate;
    
    -- 4. DISCOUNT IS SUM OF DISCOUNTS FOR ITEMS, SUM OF( QUANTITY * DISCOUNT ) FOR EACH ITEM
    SELECT SUM(net_discount)
    INTO sales_order_rec.discount
    FROM
    ( 
        SELECT (quantity * discount) net_discount
        FROM sales_order_details
        WHERE so_id = sales_order_rec.so_id  
    );

     -- 5. TAX IS THE SAME AS DISCOUNT
    SELECT SUM(net_tax)
    INTO sales_order_rec.tax
    FROM 
    (
        SELECT (quantity * tax) net_tax
        FROM sales_order_details
        WHERE so_id = sales_order_rec.so_id
    );
    
    UPDATE sales_order
    SET so_date = sales_order_rec.so_date
    WHERE so_id = sales_order_rec.so_id;
    
    UPDATE sales_order
    SET sales_amount = sales_order_rec.sales_amount
    WHERE so_id = sales_order_rec.so_id;
    
    UPDATE sales_order
    SET net_amount = sales_order_rec.net_amount
    WHERE so_id = sales_order_rec.so_id;
    
    UPDATE sales_order
    SET discount = sales_order_rec.discount
    WHERE so_id = sales_order_rec.so_id;
    
    UPDATE sales_order
    SET tax = sales_order_rec.tax
    WHERE so_id = sales_order_rec.so_id;
    
    RETURN messages;
    

END;
/