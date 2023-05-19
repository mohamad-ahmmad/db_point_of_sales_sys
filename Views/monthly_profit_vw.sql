/* Formatted on 5/20/2023 1:00:02 AM (QP5 v5.276) */
CREATE OR REPLACE VIEW monthly_profit_vw
AS
    SELECT EXTRACT (YEAR FROM so.so_date) AS so_year,
           EXTRACT (MONTH FROM so.so_date) AS so_month,
           (  SUM (net_amount)
            - SUM (sales_amount)
            - SUM (discount)
            - SUM (tax))
               AS profit
      FROM sales_order so
    GROUP BY  EXTRACT (MONTH FROM so.so_date), EXTRACT (YEAR FROM so.so_date);