function f123=object(P_matrix,par1)%����������Ŀ�꺯��
% load('P_matrix.mat')
% load('par1.mat')
%% �ṹ�崫�ݲ���

OR=par1.b;
Patient=par1.c;
day=par1.d;
doc=par1.e;
Cost=par1.f;
patient=par1.h;
a=par1.r;
P=par1.i;

%% ����ÿ�������ҿ���ʱ�䣬ҽ������ʱ�䣬ÿ��Ĵ�λռ��
OR_open=zeros(day,OR);%������ÿ��Ŀ���ʱ��
for d=1:day
    ind=find(P_matrix(:,2)==d);%ͳ��ÿ���ʱ��
    temp=P_matrix(ind,:);
    x=zeros(1,OR);%ÿ��������ʱ��
    for i=1:size(temp,1)
        y=temp(i,3);%�����ң�������
        switch y
            case 1%��1��������
                x(1)=x(1)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 2%��2��������
                x(2)=x(2)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 3%��3��������
                x(3)=x(3)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 4%��4��������
                x(4)=x(4)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 5%��4��������
                x(5)=x(5)+P(temp(i,1));%��ͬ������ͬ�ۼ�
        end       
    end
    OR_open(d,:)=x;
end

%% ����ҽ��ÿ�칤��ʱ��
sur=doc;%ҽ����Ŀ
surgeon_work=zeros(day,sur);%ҽ��ÿ��Ĺ���ʱ��
for d=1:day
    ind=find(P_matrix(:,2)==d);%ͳ��ÿ���ʱ��
    temp=P_matrix(ind,:);
    x=zeros(1,sur);%ÿ��ҽ������ʱ��
    for i=1:size(temp,1)
        y=temp(i,4);%ҽ�����
        switch y
            case 1%��1��������
                x(1)=x(1)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 2%��2��������
                x(2)=x(2)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 3%��3��������
                x(3)=x(3)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 4%��4��������
                x(4)=x(4)+P(temp(i,1));%��ͬ������ͬ�ۼ�
            case 5%��4��������
                x(5)=x(5)+P(temp(i,1));%��ͬ������ͬ�ۼ�
        end       
    end
    surgeon_work(d,:)=x;
end

%% ����ÿ��Ĵ�λ
%����ÿ��Ĳ�������
ele_patient_num1=zeros(1,day);%ÿ�����ڲ��˵Ĵ�λ����
for i=1:size(P_matrix,1)%ÿ�����˶��ж�һ��
    out1=min(day,P_matrix(i,2)+patient(P_matrix(i,1),3)-1);%��Ժ�����½�
    in_out1=P_matrix(i,2):1:out1;%���Ժ����
    for m=1:length(in_out1)%ÿ��ҽԺ�����ڲ�������
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

%% ���������Ŀ�꺯�� 1.�����ҿ���+�Ӱ� 2.ҽ���Ӱ�ʱ�� 3.��λ��
% f1
t_temp=0;
for i=1:size(OR_open,1)
    for j=1:size(OR_open,2)
        if(OR_open(i,j)-8>0)
            t_temp=t_temp+OR_open(i,j)-8;%�Ӱ�
        end
    end
end
o_temp=0;%�Ӱ����
for i=1:day%����ÿ��Ľ��
     close=length(find(OR_open(i,:)==0));%δ���ŵ�������
     o_temp=o_temp+(OR-close);
end
f1=a*t_temp+Cost*o_temp;%�Ӱ����

%f2
f2=0;
for i=1:size(surgeon_work,1)
    for j=1:size(surgeon_work,2)
        if(surgeon_work(i,j)-8>0)
            f2=f2+surgeon_work(i,j)-8;%�Ӱ�
        end
    end
end

%f3
f3=max(ele_patient_num1);

%% ������������ڱ���
P_vector=zeros(1,size(P_matrix,1)*size(P_matrix,2));
for jj=1:size(P_matrix,2)
    P_vector((jj-1)*Patient+1:jj*Patient)=P_matrix(1:Patient,jj);
end

f123=[P_vector,f1,f2,f3];%������������ڴ洢
