
CREATE OR REPLACE VIEW item_profit_vw AS
  SELECT sod.item_id, sod.price-(sod.item_cost+sod.discount) AS profit, so.so_date AS Sold_in FROM mms_hr.sales_order so
    INNER JOIN mms_hr.sales_order_details sod ON so.so_id = sod.so_id;
    