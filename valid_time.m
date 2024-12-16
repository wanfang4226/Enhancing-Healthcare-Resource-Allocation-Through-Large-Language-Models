function P_matrix=valid_time(P_matrix,par1)

OR=par1.b;
day=par1.d;
P=par1.i;
restrict=par1.t;

Work_Time=zeros(day,OR);
all_day=unique(P_matrix(:,2));%所有的日期
rest_patient=[];
for f=1:length(all_day)%找到每一天的手术室情况
    index=find(P_matrix(:,2)==all_day(f));
    every_day=P_matrix(index,:);%每天的情况
    all_ORs=unique(every_day(:,3));%所有的手术室
    every_day_OR=[1:1:OR;zeros(1,OR)];
    for e=1:length(all_ORs)%计算每个手术室工作时间
        every_ORs_patient=find(every_day(:,3)==all_ORs(e));
        worktime=0;
        for n=1:length(every_ORs_patient)
            worktime=worktime+P(every_day(every_ORs_patient(n),1));
        end
        while (worktime>restrict) && (~isempty(every_ORs_patient))
            all_time=P(every_day(every_ORs_patient,1));
            [time,pat]=min(all_time);%从最小手术时间的病人去掉开始
                worktime=worktime-time;
                rest_patient=[rest_patient;every_day(every_ORs_patient(pat),1)];%需要改变手术号的病人
                every_ORs_patient(pat)=[];%去掉已经加入的点
        end
        every_day_OR(2,all_ORs(e))=worktime;
    end
    Work_Time(f,:)=every_day_OR(2,:);
end

for e=1:length(rest_patient) %修改每个病人的手术室和手术日期
    Row=find(P_matrix(:,1)==rest_patient(e));%病人在第几行
    % info=[P_matrix(Row,:),P(rest_patient(e)),W(rest_patient(e)),L(rest_patient(e)),U(rest_patient(e))];
    date1=P_matrix(Row,2);
    index=find(Work_Time(date1,:)~=0);
    can_add=find(Work_Time(date1,index)<restrict);
    if ~isempty(can_add)%当天有空间加入
        [time,pla]=min(Work_Time(date1,index(can_add)));
        Or_new=index(can_add(pla));
        P_matrix(Row,3)=Or_new;
        Work_Time(date1,Or_new)=Work_Time(date1,Or_new)+P(rest_patient(e));
        rest_patient(e)=0;%改成功后变成0，便于后续查没成功的个体
    else%没有空间加入，换一天
        Timewindow=[];
        for i=1:length(all_day)%找到可以插入的日期
            ind=find(Work_Time(all_day(i),:)<restrict);
            if ~isempty(ind)
                Timewindow=[Timewindow,all_day(i)];
            end

        end
        for n=1:length(Timewindow)
            index=find(Work_Time(Timewindow(n),:)~=0);
            can_add=find(Work_Time(Timewindow(n),index)<restrict);
            if ~isempty(can_add)%如果空了就不用管
                [time,pla]=min(Work_Time(Timewindow(n),index(can_add)));
                P_matrix(Row,3)=index(can_add(pla));%更改手术室
                P_matrix(Row,2)=Timewindow(n);%更改手术日期
                Work_Time(Timewindow(n),P_matrix(Row,3))=Work_Time(Timewindow(n),P_matrix(Row,3))+P(rest_patient(e));
                rest_patient(e)=0;%改成功后变成0，便于后续查没成功的个体
                break;
            end
        end
    end
end
% still_patient=rest_patient(find(rest_patient~=0));%剩下的病人，没放进去，重插入
% P_matrix=re_insert(still_patient,Work_Time,P_matrix,par1);


