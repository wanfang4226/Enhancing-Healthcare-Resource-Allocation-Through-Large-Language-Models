function pool1=valid(pool,par1)
%% �ṹ�崫�ݲ���

Patient=par1.c;

pool1=[];
[N,~] = size(pool); %����+Ŀ�꺯��
for j=1:N
    P_matrix=[];%���˾�����ţ����ڣ�������,ҽ��   
    ind_num=pool(j,:);%ֻҪĿ�꺯��
    % ��������ɾ���
    for i=1:4
        P_matrix(:,i)=ind_num(((i-1)*Patient+1):i*Patient);
    end
   %% ��֤�������ѡ����ִ��   
   %% ҽ���Ű��ѯ
   r2=rand;
   if r2<0.7
       P_matrix=valid_doc(P_matrix,par1);
   end
   %% ÿ�첻ͬ�����ҵĹ���ʱ��,����ʱ���������12
   r3=rand;
   if r3<0.7
       P_matrix=valid_time(P_matrix,par1);
   end
   
%% �ṹ�崫�ݲ���
pool1(j,:)=object(P_matrix,par1);%����������Ŀ�꺯��


end

