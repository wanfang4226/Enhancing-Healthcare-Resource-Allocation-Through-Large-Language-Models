function pop=decode(par1)%pop是一个矩阵,N行代表种群，前6列代表变量，后两列代表目标函数f1,f2
%% 结构体传递参数
OR=par1.b;
Patient=par1.c;
day=par1.d;
patient=par1.h;
N=par1.o;
restrict=par1.t;
%% 产生200个初始解
for i = 1 : N
    Line_all={};
    P_matrix=[];%病人矩阵：序号，日期，手术室,医生,手术时长
    no_service=1:Patient;
    To_EL=zeros(1,day);%每天用几个手术室
    for d=1:day
        To_el=1;%当前开放的最大手术号
        Line_em_el=zeros(1,OR);%第day天的手术线
        if isempty(no_service)
            break;
        end
        for j=1:length(no_service)%对每个人安排手术
            [~,No]=min(Line_em_el(1:To_el));%最小的放.a是数，b是位置;[a,b]=min()
            if Line_em_el(No)+patient(no_service(j),2)<=restrict%Line_em_el(To(d)+No)+today_pat(j,3)<=restrict*60
                %将病人放进去
                Line_em_el(No)=Line_em_el(No)+patient(no_service(j),2);                
                P_matrix=[P_matrix;no_service(j),d,No,patient(no_service(j),4)];%分配
                no_service(j)=0;%这个病人安排了
            else %新开实验室或者安排到下一天
                r1=rand;
                if r1<0.8%新开
                    To_el=To_el+1;%当前开放的最大手术号
                    if To_el>OR                       
                        To_el=To_el-1;%加的1还原
                        break;%超过总OR数目就跳出,下一天
                    else
                        Line_em_el(To_el)=patient(no_service(j),2);%插入新开发的OR                        
                        P_matrix=[P_matrix;no_service(j),d,To_el,patient(no_service(j),4)];%分配
                        no_service(j)=0;%这个病人安排了
                    end
                end
            end
        end
        %将病人放进手术室
        Line_all{1,d}=Line_em_el;%每天每个手术室的时间线
        no_service=no_service(~ismember(no_service,0));
        To_EL(d)=To_el;%
    end
    % 重插入未被安排的
    for j=1:length(no_service)
        day_rand=randperm(day,1);%随机插入一天
        Line_em_el=Line_all{1,day_rand};
        To_el=To_EL(day_rand);
        [~,No]=min(Line_em_el(1:To_el));%最小的放.a是数，b是位置;[a,b]=min()
        Line_em_el(No)=Line_em_el(No)+patient(no_service(j),2);
        P_matrix=[P_matrix;no_service(j),day_rand,No,patient(no_service(j),4)];%分配
    end

    %结构体传递参数
    pop(i,:)=object(P_matrix,par1);%包括变量和目标函数[f123,offer_bed]
end

