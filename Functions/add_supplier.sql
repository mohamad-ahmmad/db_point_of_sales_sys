CREATE FUNCTION add_supplier  (id IN number, sup_name IN varchar2(30), phone_number IN varchar2(10),  email IN varchar(50) )



BEGIN

--POSSIBLE CHECK STATEMENTS IN THE FUTURE

INSERT INTO mms_hr.supplier VALUES (id, sup_name, phone_number, email);

END

/