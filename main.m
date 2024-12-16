tic    %开始计算的时间
clc;clear;
N=100; %种群个体
gen =200; %迭代次数
Q=8;%正常工作时间8h
OR=5;%手术室j
Patient=50;%病人i
day=5;%工作日期t
Cost=1000;%每个手术打开需要固定费用
a=200;%每个手术室加班一个小时的费用
% fe=500;%违背医生排班的费用
restrict=10;%加班时间不允许超过4小时
load('patient.mat');
% P=[5,4,4,3,4,2,6,5,6,4,4,2,3,4,6,4,6,5,4,3,5,2,5,5,5,6,6,5,4,6,4,2,2,3,4,6,3,4,5,2,5,3,2,4,2,2,3,2,2,2,5,3,4,5,4,4,4,2,4,6,1,3,3,4,5,4,3,6,2,2,2,2,5,4,2,6,5,5,2,6,1,2,6,5,4,2,3,2,2,6,3,3,3,4,5,2,6,4,6,3];
P=patient(:,2)';%持续时间
%% 10个医生,每个医生都有自己的排班表
doc=5;%doctors=10;
doc_load=8;%每个医生工作时间不超过8小时
%% 结构体传递参数
par1.a=Q;
par1.b=OR;
par1.c=Patient;
par1.d=day;
par1.e=doc;
par1.f=Cost;
% par1.g=fe;
par1.h=patient;
par1.i=P;
% par1.j=W;
% par1.k=L;
% par1.l=U;
% par1.m=doctors;
% par1.n=emer_num;
par1.o=N;
par1.p=gen;
% par1.q=Pat_Doc;
par1.r=a;
% par1.s=ICU_num;
par1.t=restrict;
% par1.u=restrict_cost;
% par1.v=reject;
% par1.w=LOS;
% par1.x=Risk;
% par1.y=em_num;
par1.z=doc_load;

%% 解码
pop=decode(par1); %初始种群 
pop_pareto= non_domination(pop);%支配排序，pop的1-6列为变量，７－８为目标函数，９为适应度函数，第１０列为拥挤距离的矩阵
%% 开始迭代
obj_convergence=[];%5个目标收敛情况，每次迭代前端值为1的目标函数平均值
%% 开始迭代
for i = 1 :gen
  %% 选择
  pool_size = round(N/2);
  tour_size = 2;
  %% 一个个体一个P，每天产生的急诊人数随机
  pool=selection(pop_pareto,pool_size,tour_size);%父种群，包括目标函数和帕累托排序
  %% 变异,找到所选择个体对应的,变异和交叉不会改变P,只是插入可选病人
  poolmu=mutation(pool,par1);
  %% 交叉
  poolcr=cross(poolmu,par1);%子种群　只有目标函数  
  %% 父子两个种群融合　种群大小约为１．５Ｎ 
  intermediate_chromosome=[pop_pareto(:,1:end-2);poolcr];%变量+目标函数
  %% 删掉不可行解
  temp=valid(intermediate_chromosome,par1);
  %% 对融合种群进行非支配排序
  intermediate_chromosome_temp =non_domination(temp);%顺序改变
  %% 重选择
  next_generation= replace_chromosome(intermediate_chromosome_temp,N);%顺序改变，目标函数和帕累托排序 
  %% 下一次迭代开始
  pop_pareto=next_generation;%包括目标函数，帕累托排序
  %% 3个目标收敛情况
  index=find(next_generation(:,end-1)==1);%每次迭代前端值为1的目标函数平均值
  obj=3;%3个目标函数
  obj_avg=[];
  for d=1:obj
      obj_avg(d)=mean(next_generation(index,4*Patient+d));
  end
  obj_convergence=[obj_convergence;obj_avg];
  disp(['共迭代',num2str(gen),'次,现在为：',num2str(i)]);
end

 

for re=1:1%%%只要1个解
    display(['-------------第',num2str(re),'个解情况如下:--------------------']);   
    %显示目标函数
    ind_num=next_generation(re,1:end-2);%只要目标函数
    P_matrix=[];
    % 将向量变成矩阵
    for i=1:4
        P_matrix(:,i)=ind_num(((i-1)*Patient+1):i*Patient);
    end
    
    %% 按照天和手术室排列，方便画图
      P_matrix=sortrows(P_matrix,[2,3]);

    %% 每天不同手术室的工作时间
    Work_Time=zeros(day,OR);
    all_day=unique(P_matrix(:,2));%所有的日期
    for i=1:length(all_day)%找到每一天的手术室情况
        index=find(P_matrix(:,2)==all_day(i));
        every_day=P_matrix(index,:);%每天的情况
        all_ORs=unique(every_day(:,3));%所有的手术室
        every_day_OR=[1:1:OR;zeros(1,OR)];
        for m=1:length(all_ORs)%计算每个手术室工作时间
            every_ORs_patient=find(every_day(:,3)==all_ORs(m));
            worktime=0;
            for n=1:length(every_ORs_patient)
                worktime=worktime+P(every_day(every_ORs_patient(n),1));
            end
            every_day_OR(2,all_ORs(m))=worktime;
        end
        Work_Time(i,:)=every_day_OR(2,:);
    end   
    C2t=array2table(Work_Time,'RowNames',{'Day1','Day2','Day3','Day4','Day5'},'VariableNames',{'OR1','OR2','OR3','OR4','OR5'});
    display('原始手术时间表'); 
    display(C2t);  
    %结果展示
    t_temp=0;
    for i=1:size(Work_Time,1)
        for j=1:size(Work_Time,2)
            if(Work_Time(i,j)-8>0)
                t_temp=t_temp+Work_Time(i,j)-8;%加班
            end
        end
    end
    o_temp=0;%加班费用
    for i=1:day%计算每天的结果
        close=length(find(Work_Time(i,:)==0));%未开放的手术室
        o_temp=o_temp+(OR-close);
    end
    f1=a*t_temp+Cost*o_temp;%加班费用     
    % display(['手术室总费用',num2str(f1),'加班总时间为：',num2str(t_temp),',','开放的手术室为：',num2str(o_temp)]);
    
    %% 显示每个医生的每天最长的工作时间8小时   
    all_doc=unique(P_matrix(:,4));
    doc_timetalble=zeros(doc,day);
    for r=1:length(all_doc)%检查每个医生
        index=find(P_matrix(:,4)==all_doc(r));
        every_doc=P_matrix(index,:);%每天的情况
        workhour=zeros(1,day);
        for rr=1:size(every_doc,1)%找到每个医生所有工作日的工作时长
            switch every_doc(rr,2)
                case 1
                    workhour(1)=workhour(1)+P(1,every_doc(rr,1));%医生每天的工作时间
                case 2
                    workhour(2)=workhour(2)+P(1,every_doc(rr,1));
                case 3
                    workhour(3)=workhour(3)+P(1,every_doc(rr,1));
                case 4
                    workhour(4)=workhour(4)+P(1,every_doc(rr,1));%医生每天的工作时间
                case 5
                    workhour(5)=workhour(5)+P(1,every_doc(rr,1));
            end
        end
        doc_timetalble(all_doc(r),:)=workhour;     
    end
    F2t=array2table(doc_timetalble,'VariableNames',{'Day1','Day2','Day3','Day4','Day5'},'RowNames',{'Doc1','Doc2','Doc3','Doc4','Doc5'});
    % display('医生每天的工作时间');    
    display(F2t);
    %结果展示
    f2=0;
    for i=1:size(doc_timetalble,1)
        for j=1:size(doc_timetalble,2)
            if(doc_timetalble(i,j)-8>0)
                f2=f2+doc_timetalble(i,j)-8;%加班
            end
        end
    end
    display(['医生总加时间:',num2str(f2)]);
    
    %便于输出
    P_matrix=[P_matrix,P(P_matrix(:,1))'];
    %% 3个目标
    % display(['目标1，医院手术室开放及加班成本为：',num2str(ind_num(end-2))]);
    display(['手术室总费用',num2str(f1),'加班总时间为：',num2str(t_temp),',','开放的手术室为：',num2str(o_temp)]);
    display(['目标2，医生排班违背情况：',num2str(ind_num(end-1))]);
    display(['目标3，一周的满足风险指数的总最小床位为：',num2str(ind_num(end))]);

end

toc;


