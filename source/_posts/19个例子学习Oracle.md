---
title: 19个例子学习Oracle
date: 2021-11-25 23:10:27
cover: /images/20221002/f35873cf8054bdddd09e2c4825ab11f2.jpg
tags:
---

19个学习Oracle的例子

<!-- more -->

```sql
--p1
begin
dbms_output.put_line('你好 世界');
end;

--p2 引入变量
declare
    age number default 90;
    height number := 175;
begin
    dbms_output.put_line('年龄'||age||'身高'||height);
end;

--p3 变量开始运算
declare
    age number default 90;
    height number := 175;
begin
    dbms_output.put_line('年龄'||age||'身高'||height);
    age := age + 20;
    dbms_output.put_line('20年后年龄'||age||'岁');
end;


--p4 引入表达式
declare
    age number default 90;
    height number := 175;
begin
    if age>70 then
        dbms_output.put_line('古稀之年');
    else
        dbms_output.put_line('风华正茂');
    end if;
end;

--p5 流程控制
declare
    age number default 90;
    height number := 175;
    gender char(2) := '男';
begin
    if gender='男' then
        dbms_output.put_line('你可以和女性结婚');
    end if;

    if height>170 then
        dbms_output.put_line('可以打篮球');
    else 
        dbms_output.put_line('可以踢足球');
    end if;

    if age<20 then
        dbms_output.put_line('年轻小伙');
    elsif age <= 50 then
        dbms_output.put_line('年轻有为');
    elsif age <=70 then
        dbms_output.put_line('安享天伦');
    else  
        dbms_output.put_line('佩服佩服');
    end if;

end;


--p6 计算1-100的和
declare
    i number :=0;
    total number :=0;
begin
    loop
        i := i+1;
        total := total + i;

        if i=100 then
            exit;
        end if;
    end loop;

    dbms_output.put_line('总和'||total);

end;

-- p7: 跳出loop的方法
declare
    i number :=0;
    total number :=0;
begin
    loop
        i := i+1;
        total := total + i;

        exit when i>=100;
    end loop;

    dbms_output.put_line('总和'||total);

end;

--p8 whlie循环
declare
    i number :=0;
    total number :=0;
begin

    while i<100 loop
        
        i := i+1;
        total := total + i;
        
    end loop;

    dbms_output.put_line('总和'||total);

end;



--p9 for 循环
begin

    --for 循环变量 in 起始值..结束值 loop
    --xxxxx
    --end loop;

    for i in 1..9 loop
    
        dbms_output.put_line(i);

    end loop;

    for i in reverse 1..9 loop
    
        dbms_output.put_line(i);

    end loop;

end;



--p10 没有返回值的"函数"
--做一个求面积的过程
--declare
--    area number;
--    procedure 过程名(参数名 类型,...) is
--    begin
--        主体
--    end;
--begin
--end;

declare 
    area number;
    procedure mian(a number,b number) is
    begin
    
        area := a * b;
        dbms_output.put_line(a||'乘'||b||'的面积是'||area);
    
    end;
begin

    mian(5,4);
    mian(6,7);
    mian(3,7);

end;



--p11 做一个求面积的函数
--declare
--    area number;
--    function 过程名(参数名 类型,...) return 类型 is
--    begin
--        主体
--    end;
--begin
--end;

declare 
    area number;
    function mian(a number,b number) return number is
    begin
    
        area := a * b;
        
        return area;
    
    end;
begin

    dbms_output.put_line(mian(5,4));
    dbms_output.put_line(mian(3,7));
    dbms_output.put_line(mian(6,9));

end;


--p12 自定义变量类型 之记录类型

declare
    
    type student is record
    (
        sno char(5),
        name varchar2(10),
        age number
    );

    lisi student;

begin

    lisi.sno := 's1008';
    lisi.name := '李四';
    lisi.age := 19;

    dbms_output.put_line('我叫'||lisi.name||',我'||lisi.age||'岁,学号是'||lisi.sno);
end;




--p13 自定义类型之集合类型


declare 
 type answer is table of char(2);
 ans answer := answer('a','b','c','d');

begin

    dbms_output.put_line('共有'||ans.count()||'答案,分别是:');
    dbms_output.put_line(ans(1));
    dbms_output.put_line(ans(2));
    dbms_output.put_line(ans(3));
    dbms_output.put_line(ans(4));

end;

--p14 声明数据类型的第3个方法

declare
    age number;
    变量名 另一个变量%type;

    age 表名.列名%type; --声明和列一样的类型

    --简化声明record类型
    变量名 表名%rowtype;

begin
end;


--p15 测试一下rowtype

declare
    xg student%rowtype;
begin

    xg.sno := 123;
    xg.name := '小刚';

    dbms_output.put_line(xg.sno||xg.name);

end;



--p16 pl/sql操作数据库中的数据
--查询部门的名称及地区，及部门的总薪水与奖金

declare 

    depart dept%rowtype;
    total_sal number;
    total_comm number;

    procedure deptinfo(dno number)
    is
    begin
        select dname,loc into depart.dname,depart.loc from dept where deptno=dno;
        select sum(sal),sum(comm) into total_sal,total_comm from emp where deptno=dno;

        dbms_output.put_line('部门名称：'||depart.dname||'在'||depart.loc);
        dbms_output.put_line('这个部门每月工资及奖金各是'||total_sal||'和'||total_comm);
    end;

begin

    deptinfo(80);
    deptinfo(30); 
end;



--p17 引入异常处理

declare 

    depart dept%rowtype;
    total_sal number;
    total_comm number;

    procedure deptinfo(dno number)
    is
    begin
        select dname,loc into depart.dname,depart.loc from dept where deptno=dno;
        select sum(sal),sum(comm) into total_sal,total_comm from emp where deptno=dno;

        dbms_output.put_line('部门名称：'||depart.dname||'在'||depart.loc);
        dbms_output.put_line('这个部门每月工资及奖金各是'||total_sal||'和'||total_comm);
    end;

begin
    deptinfo(80);
    deptinfo(30);
exception
    when NO_DATA_FOUND then
       dbms_output.put_line('没有数据');
    when others then
       dbms_output.put_line('其他错误');
end;



--p18:递归过程或函数
--求1->N的和,N允许输入

declare
    m number;
    total number;

    function qiuhe(n number) return number
    is
    begin

        if n>1 then
            return n + qiuhe(n-1);
        else 
            return 1;
        end if;

    end;

begin

    dbms_output.put_line(qiuhe(10));

end;

--p19 存储过程/存储函数
create function qiuhe(n number) return number
is
begin

    if n>1 then
        return n + qiuhe(n-1);
    else 
        return 1;
    end if;

end;



```