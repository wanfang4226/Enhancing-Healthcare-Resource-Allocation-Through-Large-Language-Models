function   P_matrix=valid_doc(P_matrix,par1)
day=par1.d;
P=par1.i;
doc_load=par1.z;

all_doc=unique(P_matrix(:,4));%所有的医生
%% 检查每个医生的工作日不超载
for r=1:length(all_doc)
    index=find(P_matrix(:,4)==all_doc(r));
    every_doc=P_matrix(index,:);%每天的情况
    workhour=zeros(1,day);
    for rr=1:size(every_doc,1)%找到每个医生所有工作日的工作时长
        switch every_doc(rr,2)
            case 1
                workhour(1)=workhour(1)+P(1,every_doc(rr,1));%医生每天的工作时间
            case 2
                workhour(2)=workhour(2)+P(1,every_doc(rr,1));
            case 3
                workhour(3)=workhour(3)+P(1,every_doc(rr,1));
            case 4
                workhour(4)=workhour(4)+P(1,every_doc(rr,1));%医生每天的工作时间
            case 5
                workhour(5)=workhour(5)+P(1,every_doc(rr,1));
        end
    end
    %医生自己的排班表
    loader_day=find(workhour>doc_load);
    if isempty(loader_day)
        break;%当前医生工作时间合适
    end
    reject_pa=[];%拒绝病人
    for t=1:length(loader_day)
        temp=find(every_doc(:,2)==loader_day(t));
        temp_patient=every_doc(temp,1);%超载当天的所有病人
        while workhour(loader_day(t))>doc_load
            [time,pla]=min(P(1,temp_patient));
            workhour(loader_day(t))=workhour(loader_day(t))-time;
            reject_pa=[reject_pa;temp_patient(pla)];%这个医生对应的病人
            temp_patient(pla)=[];
        end
    end
    %%  病人插入
    for u=1:length(reject_pa)
        place=find(P_matrix(:,1)==reject_pa(u));%找到病人的位置
        can_insert=find(workhour+P(1,reject_pa(u))<doc_load);%%%%可插入的医生工作时间
        if ~isempty(can_insert)%为医生换一个工作日期
            ra=randperm(length(can_insert));
            P_matrix(place,2)=can_insert(ra(1));%新天数赋值
            workhour(can_insert(ra(1)))=workhour(can_insert(ra(1)))+P(1,reject_pa(u));
        end
    end
end
