function Tabu_obj_domination= non_domination(Tabu_obj) %pop����Ⱥ����N�У�ǰ����Ϊ������������ΪĿ�꺯�����˺�����ҪΪĿ�꺯������;
%��һǰ�������и�����Ӧ��ֵΪ1���ڶ�ǰ����Ϊ2 
front = 1;
[N,n] = size(Tabu_obj);
M =3;%Ŀ�꺯��
V =n-M;%��������,ǰV������·��(�������0)
%% ǰ������
F(front).f = [];%��һǰ�����и���
individual = [];%��һ���ṹ�壬ÿ���������������ԣ����Լ��õ���Ŀ���ͱ��Լ���ļ���
for i = 1 : N %ÿֻ����
    individual(i).n = 0;% ���Լ��õ����������������
    individual(i).p = [];% ���Լ���ļ���
    for j = 1 : N %ÿһ�����������Ľ���һ�����ıȽ�
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
       for k = 1 : M%����Ŀ�꺯��
           if (Tabu_obj(i,V+k)<Tabu_obj(j,V+k))%Ŀ�꺯������ԽСԽ��
               dom_less = dom_less + 1;%���Լ��󷴶�����
           elseif (Tabu_obj(i,V+k) ==Tabu_obj(j,V+k))
               dom_equal = dom_equal + 1;
           else
               dom_more = dom_more + 1; 
           end
       end

    if dom_less == 0 && dom_equal ~=M %�����Լ���
         individual(i).n = individual(i).n + 1;%���Լ�����Ŀ
    elseif dom_more == 0 && dom_equal ~=M%������һ�����Լ���
         individual(i).p = [individual(i).p j];%���Լ���ļ���
    end
    end
     
if individual(i).n == 0%���и��嶼�Ƚ���ϣ��õ��� individual(i)����������
   Tabu_obj(i,M + V + 1) = 1;
   F(front).f = [F(front).f i];%��һǰ�����и���
end
end

while ~isempty(F(front).f)%�����ҵڶ�ǰ�˸���
    Q = [];%��nǰ�����и���
    for i = 1 : length(F(front).f)%������һǰ�����и���
        if ~isempty(individual(F(front).f(i)).p)%��һǰ����ÿ������ı��Լ���ļ���
            for j = 1 : length(individual(F(front).f(i)).p)
                individual(individual(F(front).f(i)).p(j)).n =individual(individual(F(front).f(i)).p(j)).n - 1;%��һǰ����ÿ������ı��Լ���ļ����и���ı��Լ��õ���Ŀ����
                if individual(individual(F(front).f(i)).p(j)).n == 0%ֻ�б��Լ��õ���Ŀ��Ϊ�����ܽ���ǰ������
                    Tabu_obj(individual(F(front).f(i)).p(j),M + V + 1) = front + 1;%ǰ�˸�����Ӧ��ֵ
                    Q = [Q individual(F(front).f(i)).p(j)];%�ڶ�ǰ�˸���
                end
            end
        end
    end
    front = front + 1;
    F(front).f = Q;%��frontǰ�����и���
end
[~,index_of_fronts] = sort(Tabu_obj(:,M + V + 1)); %[B,I]=sort(A),IΪ���ص������Ԫ����ԭ�����е���λ�û���λ��.BΪ�������򣩺����
for i = 1 :length(index_of_fronts)
    sorted_based_on_front(i,:) = Tabu_obj(index_of_fronts(i),:);%���ո��Ե�ǰ��ֵ��������Ⱥ
end
current_index = 0;
%% Find the crowding distance for each individual in each front
 for front = 1 : (length(F) - 1)%ÿ��ǰ�˶�Ҫ�����
     y = [];
     previous_index = current_index + 1;
     l=length(F(front).f);
     y= sorted_based_on_front(current_index+1:current_index+l,:);%��frontǰ�˵����и���,M+V+1�У�������ǰ��ֵ
     current_index = current_index + l;
% Sort each individual based on the objective
sorted_based_on_objective = [];
for i = 1:M%�͸�Ŀ�꺯����Ҫ����
    data=y(:,V+i);%ȡ����һ��Ŀ�꺯��ֵ
    data=data./(1+max(abs(data(isfinite(data)))));%��Ŀ�꺯��ӳ�䵽������������֮�䡣TF = isfinite(A),����һ����A�ߴ�һ�������飬 ���A��ĳ��Ԫ�ز���inf�� ���ӦTF��Ԫ����1�� ����TF�ж�ӦԪ����0��
    [~, index_of_objectives] = sort(data);%��ӳ����Ŀ�꺯�������������ȼ�������������Ŀ��������У�����Ȼ������
    sorted_based_on_objective = [];
    for j = 1 : length(index_of_objectives)
        sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);%�ڣ�ǰ���а���һ��Ŀ�꺯����������ĸ���
    end
%% һ��ǰ���еĵ�һ����������һ�������ӵ�������Ϊ����
y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i)= 1000;% Inf,һ���ܴ����
y(index_of_objectives(1),M + V + 1 + i) =1000;%1-6��Ϊ������������ΪĿ�꺯������Ϊ��Ӧ�Ⱥ���������Ϊ��һ��Ŀ�꺯����ӵ�����룬�ڣ�����Ϊ�ڶ���Ŀ�꺯����ӵ������
for j = 2 : length(index_of_objectives)-1%�ڣ��������ӵ������
    next_obj = sorted_based_on_objective(j + 1,V + i);
    previous_obj = sorted_based_on_objective(j - 1,V + i);
    y(index_of_objectives(j),M + V + 1 + i) =(next_obj - previous_obj);%����ӵ��������0-1֮��?
    
end
end
distance = [];
distance(:,1)=zeros(length(F(front).f),1);
for i = 1 : M
    distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);%����Ŀ�꺯�����Ե�ӵ��������Ӿ͵�����ӵ������
end
y(:,M + V + 2) = distance;
y = y(:,1:M + V + 2);
z(previous_index:current_index,:) = y;%Z��1-6��Ϊ������������ΪĿ�꺯������Ϊ��Ӧ�Ⱥ������ڣ�����Ϊӵ������ľ���
 end
Tabu_obj_domination=z();
% Tabu_obj_domination(:,end-4)=-1*Tabu_obj_domination(:,end-4);%����������Ż�ԭ
% Tabu_obj_domination(:,end-2)=-1*Tabu_obj_domination(:,end-2);%����������Ż�ԭ




