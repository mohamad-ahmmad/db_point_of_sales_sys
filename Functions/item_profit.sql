

--This function responsible of calculating 
--The profit of a specific item depends on weeks
--EXAMPLE: item_profit(1, 2, 1) -> calculate the profit of item with id one last two week.
-- n represent the type of the 'last_n' d->days, w->weeks, m->months
CREATE OR REPLACE FUNCTION item_profit ( item_id IN NUMBER, last_n IN INTEGER, n IN VARCHAR2 ) RETURN DATE
IS 
  begin_of_last_n_date DATE;
  profit NUMBER;
BEGIN
  IF n = 'y' THEN
    begin_of_last_n_date := ADD_MONTHS(SYSDATE, -12*last_n);
  ELSIF n = 'm' THEN
    begin_of_last_n_date := ADD_MONTHS(SYSDATE, -last_n);
  ELSIF n = 'd' THEN
    begin_of_last_n_date := SYSDATE - last_n;
  ELSE
    RAISE_APPLICATION_ERROR(-20000, 'Invalid input: ' || n || '. Please use y, m, or d.');
  END IF;

  RETURN begin_of_last_n_date;
  
  
END;
/

