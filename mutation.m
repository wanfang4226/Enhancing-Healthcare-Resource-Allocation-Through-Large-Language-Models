function poolmu=mutation(pool,par1)%%�����������û���������Ŀͻ����²��봲λ
%% �ṹ�崫�ݲ���

OR=par1.b;
Patient=par1.c;
day=par1.d;

M=3;
poolmu=pool(:,1:end-2);%Ԥ�ȸ�ֵ
% Offer_bed=P_Pro;
%% ��ʼ����
[N,~] = size(pool); %[pop,variables] = size(chromosome);
for j=1:N
    r=rand;
    if r<0.8%20%�ĸ������
        continue;
    end
    % ��������ɾ���
    for i=1:4
        P_matrix(:,i)=pool(j,((i-1)*Patient+1):i*Patient);
    end
    %����ı䲡�˵��������ڼ������ң�ҽ�����ܱ�
    for i=1:Patient
        if rand<0.2%20%�Ŀͻ����б���
            P_matrix(i,2)=randperm(day,1);%�����ʱ�䴰��ѡ��һ��
            P_matrix(i,3)=randperm(OR,1);%���ѡ��һ��������
        end
    end  

%% ��������ĸ���Ŀ��,�ṹ�崫�ݲ���
temp=object(P_matrix,par1);%����������Ŀ�꺯��

%% �������������Ŀ����òŽ���
index=find(temp(1,end-M+1:end)<=pool(j,end-M-1:end-2));
if length(index)>=ceil(M/2)
    poolmu(j,:)=temp;
end

end
