
SET SERVEROUTPUT ON

DECLARE
profit number;
d date;
BEGIN
d:= sysdate;
dbms_output.PUT_LINE(d);
d := item_profit(1,1,'y');


dbms_output.put_line('Output: '||d);

END;

/