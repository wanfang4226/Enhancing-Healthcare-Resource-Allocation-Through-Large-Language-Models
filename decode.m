function pop=decode(par1)%pop��һ������,N�д�����Ⱥ��ǰ6�д�������������д���Ŀ�꺯��f1,f2
%% �ṹ�崫�ݲ���
OR=par1.b;
Patient=par1.c;
day=par1.d;
patient=par1.h;
N=par1.o;
restrict=par1.t;
%% ����200����ʼ��
for i = 1 : N
    Line_all={};
    P_matrix=[];%���˾�����ţ����ڣ�������,ҽ��,����ʱ��
    no_service=1:Patient;
    To_EL=zeros(1,day);%ÿ���ü���������
    for d=1:day
        To_el=1;%��ǰ���ŵ����������
        Line_em_el=zeros(1,OR);%��day���������
        if isempty(no_service)
            break;
        end
        for j=1:length(no_service)%��ÿ���˰�������
            [~,No]=min(Line_em_el(1:To_el));%��С�ķ�.a������b��λ��;[a,b]=min()
            if Line_em_el(No)+patient(no_service(j),2)<=restrict%Line_em_el(To(d)+No)+today_pat(j,3)<=restrict*60
                %�����˷Ž�ȥ
                Line_em_el(No)=Line_em_el(No)+patient(no_service(j),2);                
                P_matrix=[P_matrix;no_service(j),d,No,patient(no_service(j),4)];%����
                no_service(j)=0;%������˰�����
            else %�¿�ʵ���һ��߰��ŵ���һ��
                r1=rand;
                if r1<0.8%�¿�
                    To_el=To_el+1;%��ǰ���ŵ����������
                    if To_el>OR                       
                        To_el=To_el-1;%�ӵ�1��ԭ
                        break;%������OR��Ŀ������,��һ��
                    else
                        Line_em_el(To_el)=patient(no_service(j),2);%�����¿�����OR                        
                        P_matrix=[P_matrix;no_service(j),d,To_el,patient(no_service(j),4)];%����
                        no_service(j)=0;%������˰�����
                    end
                end
            end
        end
        %�����˷Ž�������
        Line_all{1,d}=Line_em_el;%ÿ��ÿ�������ҵ�ʱ����
        no_service=no_service(~ismember(no_service,0));
        To_EL(d)=To_el;%
    end
    % �ز���δ�����ŵ�
    for j=1:length(no_service)
        day_rand=randperm(day,1);%�������һ��
        Line_em_el=Line_all{1,day_rand};
        To_el=To_EL(day_rand);
        [~,No]=min(Line_em_el(1:To_el));%��С�ķ�.a������b��λ��;[a,b]=min()
        Line_em_el(No)=Line_em_el(No)+patient(no_service(j),2);
        P_matrix=[P_matrix;no_service(j),day_rand,No,patient(no_service(j),4)];%����
    end

    %�ṹ�崫�ݲ���
    pop(i,:)=object(P_matrix,par1);%����������Ŀ�꺯��[f123,offer_bed]
end

