create or replace package xx_mail_test is
  function run return boolean;
end;
/

create or replace  package body xx_mail_test is
  type t_case is record
  ( input varchar2(2000),
    result boolean
  ) ;
  type t_case_tab is table of t_case index by binary_integer;
  g_case_tab t_case_tab;
  g_ok_cnt pls_integer:=0;
  g_fail_cnt pls_integer:=0;
  
  procedure output(p_text varchar2) is
  begin
     dbms_output.put_line(p_text);
  end;
  
  procedure add_case(p_input varchar2, p_result boolean) is
  l_case t_case;
  begin
    l_case.input:=p_input;
    l_case.result:=p_result;
    g_case_tab(g_case_tab.count+1):=l_case;
  end;
  
  procedure add_success(p_case t_case) is
  begin
    g_ok_cnt:=g_ok_cnt+1;
    output(rpad('Case for ['||p_case.input||'] ',100,'-')||'> SUCCESS');
  end;
  
    procedure add_fail(p_case t_case,p_error varchar2 default null) is
  begin
    g_fail_cnt:=g_fail_cnt+1;
    output(rpad('Case for ['||p_case.input||'] ',100,'-')||'> FAILED');
    if p_error is not null then
        output('    with error:'||p_error);
    end if;
  end;

  
  procedure run_case(p_case t_case) is
   begin
        if xx_mail.is_valid(p_case.input)=p_case.result then
            add_success(p_case);
        else
            add_fail(p_case);
        end if;
   exception
        when others then
            add_fail(p_case,substr(sqlerrm,1,255));
   end;
  
  procedure run_cases is
  begin
    if g_case_tab is not null and g_case_tab.count>0 then
        for i in g_case_tab.first..g_case_tab.last loop
            run_case(g_case_tab(i));
        end loop;
    end if;
  end;
  
  procedure report is
  begin
    output('-------------REPORT-------------');
    output('Failed: '||g_fail_cnt);
    output('Success: '||g_ok_cnt);
    if g_fail_cnt=0 then
         output('Overall: SUCCESS');
    else
         output('Overall: FAILED');
    end if;
  end;
  
    procedure init_cases is
    l_long varchar2(32000);
  begin
    add_case(null,false);
   add_case(';;;',false);
    add_case('mchapleev@mail.ru',true);
    add_case('mchapleev@mail.ru;',true);
    -- correct delimeter
    add_case('mchapleev@mail.ru;mpetrov@mail.ru',true);
     add_case('mchapleev@gmail.com;mpetrov@gmail.com',true);
     add_case('mchapleev@gmail.com;mpetrov@gmail.com;',true);
     add_case('mchapleev@gmail.com;',true);
     add_case('mchapleev@gmail.com;;',true);
     add_case(';mchapleev@gmail.com;;',true);
     add_case(';mchapleev@gmail.com',true);
    -- wrong delimeter
     add_case('mchapleev@gmail.com,mpetrov@gmail.com',false);
     add_case('mchapleev@gmail.com,mpetrov@gmail.com;',false);
     add_case('mchapleev@gmail.com,',false);
     add_case(',mchapleev@gmail.com,,',false);
    --underscore
      add_case('mikhail_chapleev@gmail.com;mpetrov@gmail.com',true);
      add_case('mchapleev@gmail.com;maxim_petrov@gmail.com',true);
      add_case('mikhail_chapleev@gmail.com',true);
     --dot
      add_case('mikhail.chapleev@gmail.com;mpetrov@gmail.com',true);
      add_case('mikhail.chapleev@gmail.com',true);
      add_case('mchapleev@gmail.com;maxim.petrov@gmail.com',true);
       --cirillic
      add_case('михаил@gmail.com;mpetrov@gmail.com',false);
      add_case('mchapleev@gmail.com;максим@gmail.com',false);
      add_case('михаил@gmail.com',false);
      add_case('mchapleev@мэйл.com',false);
      -- bad  domain
      add_case('mchapleev@gmail.c',false);
      add_case('mchapleev@.com',false);
      add_case('mchapleev@gmail.1m',false);      
    --valid
      add_case('mchapleev@gmail.com',true);      
      add_case('mchapleev1980-1@mail.ru',true);    
      add_case('mchapleev@gmail.com.ru',true);    
      add_case('mchapleev@25.com',true);    
      add_case('mchapleev@25-test.com',true);  
     --at
      add_case('mchapleevgmail.com',false);  
      add_case('mchapleev@@gmail.com',false);  
      add_case('mikhail@chapleev@gmail.com',false);  
        -- special chars
      add_case('m{}chapleev@@gmail.com',false);  
      add_case('mikhail@chapleev@gmail.com',false);  
      add_case('mikhail chapleev@gmail.com',false);  
         --spaces
      add_case(' mchapleev@@gmail.com',false);  
      add_case('mikhail@chapleev@gmail.com ',false);  
      add_case(' mikhail@chapleev@gmail.com ',false);  
      add_case('mikhail chapleev@gmail.com',false);  
      add_case(' mikhail@chapleev@gmail.com ; mpetrov@gmail.com ',false);  
      
      loop
      l_long:=l_long||'mikhail@chapleev@gmail.com;';
      exit when length(l_long)>xx_mail.g_max_length ;
      end loop;
      add_case(l_long,false);  

  end;
  
  function run return boolean is
  begin
    g_case_tab.delete;
    g_fail_cnt:=0;
    g_ok_cnt:=0;
    init_cases();
    run_cases();
    report();
    return (g_fail_cnt=0);
  end;
end;
/