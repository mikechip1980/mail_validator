create or replace package apps.xx_mail is
    g_delimiter constant varchar2(1):=';';
    g_max_length constant number:=1024;
    function is_valid(p_mail_list varchar2) return boolean;
end;
/


create or replace package body xx_mail is
    g_mail_template constant varchar2(100):='^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*(\.[A-Za-z]{2,})$';
    subtype t_list is  varchar2(1024); 
    
    function is_valid_address(p_address varchar2) return boolean is
    begin
        if trim(p_address) is null then 
            return false;
        end if;
        return REGEXP_LIKE(p_address,g_mail_template);
    end;
    
    function is_valid_list(p_mail_list varchar2) return boolean is
        l_value t_list;
        l_tail t_list:=p_mail_list;
        l_ind pls_integer:=0;
        l_end pls_integer;
    begin
        if trim(p_mail_list) is null then 
            return false;
        end if; 
        loop
              l_ind:= instr(l_tail,g_delimiter); 
              if l_ind=0 then l_end:=length(l_tail)+1;
                else l_end:=l_ind;
              end if;
              l_value:=substr(l_tail,1,l_end-1);
              l_tail:=substr(l_tail,l_end+1);
              if not is_valid_address(l_value) then
                return false;
              end if;
              exit when l_ind=0; 
        end loop;
        return true;
    end;
    
    
    function is_valid(p_mail_list varchar2) return boolean is
    begin
        if p_mail_list is null 
            or length(p_mail_list)>g_max_length then
                    return false;
        end if;    
        return is_valid_list(rtrim(ltrim(trim(p_mail_list),g_delimiter),g_delimiter));
    end;
end;
/