function   P_matrix=valid_doc(P_matrix,par1)
day=par1.d;
P=par1.i;
doc_load=par1.z;

all_doc=unique(P_matrix(:,4));%���е�ҽ��
%% ���ÿ��ҽ���Ĺ����ղ�����
for r=1:length(all_doc)
    index=find(P_matrix(:,4)==all_doc(r));
    every_doc=P_matrix(index,:);%ÿ������
    workhour=zeros(1,day);
    for rr=1:size(every_doc,1)%�ҵ�ÿ��ҽ�����й����յĹ���ʱ��
        switch every_doc(rr,2)
            case 1
                workhour(1)=workhour(1)+P(1,every_doc(rr,1));%ҽ��ÿ��Ĺ���ʱ��
            case 2
                workhour(2)=workhour(2)+P(1,every_doc(rr,1));
            case 3
                workhour(3)=workhour(3)+P(1,every_doc(rr,1));
            case 4
                workhour(4)=workhour(4)+P(1,every_doc(rr,1));%ҽ��ÿ��Ĺ���ʱ��
            case 5
                workhour(5)=workhour(5)+P(1,every_doc(rr,1));
        end
    end
    %ҽ���Լ����Ű��
    loader_day=find(workhour>doc_load);
    if isempty(loader_day)
        break;%��ǰҽ������ʱ�����
    end
    reject_pa=[];%�ܾ�����
    for t=1:length(loader_day)
        temp=find(every_doc(:,2)==loader_day(t));
        temp_patient=every_doc(temp,1);%���ص�������в���
        while workhour(loader_day(t))>doc_load
            [time,pla]=min(P(1,temp_patient));
            workhour(loader_day(t))=workhour(loader_day(t))-time;
            reject_pa=[reject_pa;temp_patient(pla)];%���ҽ����Ӧ�Ĳ���
            temp_patient(pla)=[];
        end
    end
    %%  ���˲���
    for u=1:length(reject_pa)
        place=find(P_matrix(:,1)==reject_pa(u));%�ҵ����˵�λ��
        can_insert=find(workhour+P(1,reject_pa(u))<doc_load);%%%%�ɲ����ҽ������ʱ��
        if ~isempty(can_insert)%Ϊҽ����һ����������
            ra=randperm(length(can_insert));
            P_matrix(place,2)=can_insert(ra(1));%��������ֵ
            workhour(can_insert(ra(1)))=workhour(can_insert(ra(1)))+P(1,reject_pa(u));
        end
    end
end
