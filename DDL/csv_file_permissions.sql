--These permissions are given by the dbms administrator
--granting the user priviliges from system as sysdba
create or replace directory dir_csv as 'c:\oracle_data\';
grant read on DIRECTORY dir_csv to MMS_HR;
grant write on DIRECTORY dir_csv to MMS_HR;
grant read, write on directory dir_csv to MMS_HR;
