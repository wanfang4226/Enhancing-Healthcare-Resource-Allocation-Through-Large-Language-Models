function f123=object(P_matrix,par1)%包括变量和目标函数
% load('P_matrix.mat')
% load('par1.mat')
%% 结构体传递参数

OR=par1.b;
Patient=par1.c;
day=par1.d;
doc=par1.e;
Cost=par1.f;
patient=par1.h;
a=par1.r;
P=par1.i;

%% 计算每个手术室开放时间，医生工作时间，每天的床位占用
OR_open=zeros(day,OR);%手术室每天的开放时间
for d=1:day
    ind=find(P_matrix(:,2)==d);%统计每天的时间
    temp=P_matrix(ind,:);
    x=zeros(1,OR);%每个手术室时间
    for i=1:size(temp,1)
        y=temp(i,3);%手术室，纵坐标
        switch y
            case 1%第1个手术室
                x(1)=x(1)+P(temp(i,1));%不同天数不同累计
            case 2%第2个手术室
                x(2)=x(2)+P(temp(i,1));%不同天数不同累计
            case 3%第3个手术室
                x(3)=x(3)+P(temp(i,1));%不同天数不同累计
            case 4%第4个手术室
                x(4)=x(4)+P(temp(i,1));%不同天数不同累计
            case 5%第4个手术室
                x(5)=x(5)+P(temp(i,1));%不同天数不同累计
        end       
    end
    OR_open(d,:)=x;
end

%% 计算医生每天工作时间
sur=doc;%医生数目
surgeon_work=zeros(day,sur);%医生每天的工作时间
for d=1:day
    ind=find(P_matrix(:,2)==d);%统计每天的时间
    temp=P_matrix(ind,:);
    x=zeros(1,sur);%每个医生工作时间
    for i=1:size(temp,1)
        y=temp(i,4);%医生编号
        switch y
            case 1%第1个手术室
                x(1)=x(1)+P(temp(i,1));%不同天数不同累计
            case 2%第2个手术室
                x(2)=x(2)+P(temp(i,1));%不同天数不同累计
            case 3%第3个手术室
                x(3)=x(3)+P(temp(i,1));%不同天数不同累计
            case 4%第4个手术室
                x(4)=x(4)+P(temp(i,1));%不同天数不同累计
            case 5%第4个手术室
                x(5)=x(5)+P(temp(i,1));%不同天数不同累计
        end       
    end
    surgeon_work(d,:)=x;
end

%% 计算每天的床位
%生成每天的病人数量
ele_patient_num1=zeros(1,day);%每天择期病人的床位需求
for i=1:size(P_matrix,1)%每个病人都判断一次
    out1=min(day,P_matrix(i,2)+patient(P_matrix(i,1),3)-1);%出院日期下界
    in_out1=P_matrix(i,2):1:out1;%入出院日期
    for m=1:length(in_out1)%每天医院有择期病人数量
        switch in_out1(m)
            case 1
                ele_patient_num1(1)=ele_patient_num1(1)+1;
            case 2
                ele_patient_num1(2)=ele_patient_num1(2)+1;
            case 3
                ele_patient_num1(3)=ele_patient_num1(3)+1;
            case 4
                ele_patient_num1(4)=ele_patient_num1(4)+1;
            case 5
                ele_patient_num1(5)=ele_patient_num1(5)+1;
        end
    end
end

%% 计算出三个目标函数 1.手术室开发+加班 2.医生加班时间 3.床位数
% f1
t_temp=0;
for i=1:size(OR_open,1)
    for j=1:size(OR_open,2)
        if(OR_open(i,j)-8>0)
            t_temp=t_temp+OR_open(i,j)-8;%加班
        end
    end
end
o_temp=0;%加班费用
for i=1:day%计算每天的结果
     close=length(find(OR_open(i,:)==0));%未开放的手术室
     o_temp=o_temp+(OR-close);
end
f1=a*t_temp+Cost*o_temp;%加班费用

%f2
f2=0;
for i=1:size(surgeon_work,1)
    for j=1:size(surgeon_work,2)
        if(surgeon_work(i,j)-8>0)
            f2=f2+surgeon_work(i,j)-8;%加班
        end
    end
end

%f3
f3=max(ele_patient_num1);

%% 矩阵变向量便于保存
P_vector=zeros(1,size(P_matrix,1)*size(P_matrix,2));
for jj=1:size(P_matrix,2)
    P_vector((jj-1)*Patient+1:jj*Patient)=P_matrix(1:Patient,jj);
end

f123=[P_vector,f1,f2,f3];%变成向量，便于存储
