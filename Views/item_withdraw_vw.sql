
create or replace view item_withdraw_vw 
AS 
SELECT ITEM_NAME, sod.QUANTITY as sold, inv.QUANTITY as left_in_inv FROM MMS_HR.sales_order_details sod 
INNER JOIN MMS_HR.item i ON sod.item_id = i.item_id 
INNER JOIN mms_hr.inventory inv ON i.item_id = inv.item_id ORDER BY sod.quantity asc ;