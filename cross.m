function poolco=cross(poolmu,par1)%����Ⱥ��ֻ��Ŀ�꺯��
%% �ṹ�崫�ݲ���

Patient=par1.c;
poolco=poolmu;%Ԥ�ȸ�ֵ
% Offer_bed=P_Pro;

M=3;%���Ŀ�꺯��
%% ��ʼ����
[N,~] = size(poolmu); %[pop,variables] = size(chromosome);
for j=1:N
    r=rand;
    if r<0.8%20%�ĸ��彻��
        continue;
    end
    % ��������ɾ���
    for i=1:4
        P_matrix(:,i)=poolmu(j,((i-1)*Patient+1):i*Patient);
    end
    %����ı䲡�˵��������ڼ������ң�ҽ�����ܱ�
    for i=1:Patient
        r1=rand;
        if r1<0.1%20%�Ŀͻ����н���
            %ѡ����һ���ͻ�����
            patient1=randi([1,Patient],1);%�͵ڼ��еĿͻ�����
            temp1=P_matrix(patient1,1);%���������˵ı�ż�ҽ��
            temp2=P_matrix(patient1,4);
            P_matrix(patient1,1)=P_matrix(i,1);
            P_matrix(patient1,4)=P_matrix(i,4);
            P_matrix(i,1)=temp1;
            P_matrix(i,4)=temp2;
        end
    end  
%% ��������ĸ���Ŀ��
temp=object(P_matrix,par1);%����������Ŀ�꺯��[f123,offer_bed]

%% �������������Ŀ����òŽ���
index=find(temp(1,end-M+1:end)<=poolmu(j,end-M+1:end));
if length(index)>=ceil(M/2)
    poolco(j,:)=temp;
end

 
end

