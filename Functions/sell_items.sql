CREATE OR REPLACE FUNCTION sell_items (
    item_obj item_info,
    p_sales_order_id Number
)
RETURN varchar2
IS

    item_quantity inventory.quantity%type;
    sales_order_rec sales_order%rowtype;
    sales_order_details_rec sales_order_details%rowtype;

    CURSOR items_requested IS
    SELECT *
    FROM inventory inv
    WHERE inv.item_id = item_obj.p_item_id
    ORDER BY inv.expiry_date ASC
    FOR UPDATE;

    message varchar2 (100);
    item_expire_quantity Number;
    item_row inventory%rowtype;

    TYPE profit_info IS RECORD (
        price Number,
        item_cost Number,
        pl_id Number
    );
    item_profit_row profit_info;

    p_quantity_copy Number := item_obj.p_quantity;

BEGIN

    -- Check if sum of quantity for requested item is sufficient.
    SELECT SUM(quantity)
    INTO item_quantity
    FROM inventory inv
    WHERE inv.item_id = item_obj.p_item_id;

    IF ( p_quantity_copy > item_quantity ) THEN
    BEGIN
        message := 'Not enough items in the inventory! ' || item_quantity || ' found';
        RETURN message;
    END;
    END IF;


    -- Loop through the set of item quantities to update their stock in the inventory.

    OPEN items_requested;
    LOOP
        -- Check if item quantity is less than the requested ammount.
        EXIT WHEN p_quantity_copy <= 0;

        FETCH items_requested INTO item_row;

        IF (item_row.quantity < p_quantity_copy) THEN
        BEGIN
            UPDATE inventory
            SET quantity = 0
            WHERE CURRENT OF items_requested;

        END;

        ELSE
            UPDATE inventory
            SET quantity = quantity - p_quantity_copy
            WHERE CURRENT OF items_requested;
        END IF;

        p_quantity_copy := p_quantity_copy - item_row.quantity;

    END LOOP;
    CLOSE items_requested;

    message := 'Items sold successfully! ';

    -- Fill the sales order details record to insert it.

    SELECT price, i_cost.item_cost, plist.pl_id
    INTO item_profit_row
    FROM
    (
        SELECT pl_id
        FROM pricelist
        WHERE event = item_obj.p_event
    ) plist

    INNER JOIN
    pricelist_item
    ON plist.pl_id = pricelist_item.pl_id

    INNER JOIN
    (
        SELECT i.item_id, i.item_cost
        FROM item i
    ) i_cost

    ON i_cost.item_id = pricelist_item.item_id WHERE pricelist_item.item_id = item_obj.p_item_id 
    AND rownum = 1;

    sales_order_details_rec.item_id := item_obj.p_item_id;
    sales_order_details_rec.so_id := p_sales_order_id;
    sales_order_details_rec.item_cost := item_profit_row.item_cost;
    sales_order_details_rec.price := item_profit_row.price;
    sales_order_details_rec.pl_id := item_profit_row.pl_id;
    sales_order_details_rec.quantity := item_obj.p_quantity;
    sales_order_details_rec.tax := item_obj.p_item_tax * item_profit_row.price;
    sales_order_details_rec.discount := item_obj.p_item_discount;

    INSERT INTO sales_order_details
    VALUES sales_order_details_rec;

    RETURN message;

END;