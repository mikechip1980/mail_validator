set serveroutput on;
@XX_MAIL.sql
@XX_MAIL_TEST.sql

declare
 l_result boolean;
begin
    l_result:=xx_mail_test.run;
end;
/