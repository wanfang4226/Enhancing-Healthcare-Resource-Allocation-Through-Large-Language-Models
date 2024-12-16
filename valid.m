function pool1=valid(pool,par1)
%% 结构体传递参数

Patient=par1.c;

pool1=[];
[N,~] = size(pool); %变量+目标函数
for j=1:N
    P_matrix=[];%病人矩阵：序号，日期，手术室,医生   
    ind_num=pool(j,:);%只要目标函数
    % 将向量变成矩阵
    for i=1:4
        P_matrix(:,i)=ind_num(((i-1)*Patient+1):i*Patient);
    end
   %% 验证函数随机选择多个执行   
   %% 医生排班查询
   r2=rand;
   if r2<0.7
       P_matrix=valid_doc(P_matrix,par1);
   end
   %% 每天不同手术室的工作时间,工作时间最长不超过12
   r3=rand;
   if r3<0.7
       P_matrix=valid_time(P_matrix,par1);
   end
   
%% 结构体传递参数
pool1(j,:)=object(P_matrix,par1);%包括变量和目标函数


end

