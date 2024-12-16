function poolmu=mutation(pool,par1)%%变异操作，将没安排完整的客户重新插入床位
%% 结构体传递参数

OR=par1.b;
Patient=par1.c;
day=par1.d;

M=3;
poolmu=pool(:,1:end-2);%预先赋值
% Offer_bed=P_Pro;
%% 开始变异
[N,~] = size(pool); %[pop,variables] = size(chromosome);
for j=1:N
    r=rand;
    if r<0.8%20%的个体变异
        continue;
    end
    % 将向量变成矩阵
    for i=1:4
        P_matrix(:,i)=pool(j,((i-1)*Patient+1):i*Patient);
    end
    %随机改变病人的手术日期及手术室，医生不能变
    for i=1:Patient
        if rand<0.2%20%的客户进行变异
            P_matrix(i,2)=randperm(day,1);%随机在时间窗中选择一天
            P_matrix(i,3)=randperm(OR,1);%随机选择一个手术室
        end
    end  

%% 计算变异后的个体目标,结构体传递参数
temp=object(P_matrix,par1);%包括变量和目标函数

%% 变异后至少两个目标更好才交换
index=find(temp(1,end-M+1:end)<=pool(j,end-M-1:end-2));
if length(index)>=ceil(M/2)
    poolmu(j,:)=temp;
end

end
