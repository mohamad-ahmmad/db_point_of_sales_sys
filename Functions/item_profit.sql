/* Formatted on 01-May-2023 17:43:09 (QP5 v5.276) */
--This function responsible of calculating
--The profit of a specific item depends on weeks
--EXAMPLE: item_profit(1, 2, 1) -> calculate the profit of item with id one last two week.
-- n represent the type of the 'last_n' d->days, w->weeks, m->months
--data : SO_ID To that satisfie the condition of the date then join and find all data about the items 
--then filter it based on the item_id -> parameter in the function. 
CREATE OR REPLACE FUNCTION item_profit (item_id   IN NUMBER,
                                        last_n    IN INTEGER,
     
                                        n         IN VARCHAR2)
    RETURN DATE
IS
    begin_of_last_n_date   DATE;
    profit                 NUMBER;
    data_cursor SYS_REFCURSOR;
BEGIN
    --STARTING DATE CALCULATING:-
    IF n = 'y'
    THEN
        begin_of_last_n_date := ADD_MONTHS (SYSDATE, -12 * last_n);
    ELSIF n = 'm'
    THEN
        begin_of_last_n_date := ADD_MONTHS (SYSDATE, -last_n);
    ELSIF n = 'd'
    THEN
        begin_of_last_n_date := SYSDATE - last_n;
    ELSE
        raise_application_error (
            -20000,
            'Invalid input: ' || n || '. Please use y, m, or d.');
    END IF;
    
    --Open cursor :
    OPEN data_cursor FOR
    SELECT * FROM mms_hr.sales_order so
    INNER JOIN mms_hr.sales_order_details sod ON so.so_id = sod.so_id
    WHERE sod.item_id = item_id AND so.so_date >= begin_of_last_n_date;  
    
    

    RETURN begin_of_last_n_date;
END;
/