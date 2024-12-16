function poolco=cross(poolmu,par1)%子种群　只有目标函数
%% 结构体传递参数

Patient=par1.c;
poolco=poolmu;%预先赋值
% Offer_bed=P_Pro;

M=3;%五个目标函数
%% 开始变异
[N,~] = size(poolmu); %[pop,variables] = size(chromosome);
for j=1:N
    r=rand;
    if r<0.8%20%的个体交叉
        continue;
    end
    % 将向量变成矩阵
    for i=1:4
        P_matrix(:,i)=poolmu(j,((i-1)*Patient+1):i*Patient);
    end
    %随机改变病人的手术日期及手术室，医生不能变
    for i=1:Patient
        r1=rand;
        if r1<0.1%20%的客户进行交叉
            %选择另一个客户交换
            patient1=randi([1,Patient],1);%和第几行的客户交换
            temp1=P_matrix(patient1,1);%被交换病人的编号及医生
            temp2=P_matrix(patient1,4);
            P_matrix(patient1,1)=P_matrix(i,1);
            P_matrix(patient1,4)=P_matrix(i,4);
            P_matrix(i,1)=temp1;
            P_matrix(i,4)=temp2;
        end
    end  
%% 计算变异后的个体目标
temp=object(P_matrix,par1);%包括变量和目标函数[f123,offer_bed]

%% 变异后至少两个目标更好才交换
index=find(temp(1,end-M+1:end)<=poolmu(j,end-M+1:end));
if length(index)>=ceil(M/2)
    poolco(j,:)=temp;
end

 
end

