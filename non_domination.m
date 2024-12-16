function Tabu_obj_domination= non_domination(Tabu_obj) %pop是种群，共N行，前六列为变量，后两列为目标函数，此函数主要为目标函数排序;
%第一前端中所有个体适应度值为1，第二前端设为2 
front = 1;
[N,n] = size(Tabu_obj);
M =3;%目标函数
V =n-M;%变量个数,前V个代表路径(包括多的0)
%% 前端排序
F(front).f = [];%第一前端所有个体
individual = [];%是一个结构体，每个个体有两个属性，比自己好的数目，和比自己差的集合
for i = 1 : N %每只蚂蚁
    individual(i).n = 0;% 比自己好的数量，个体的属性
    individual(i).p = [];% 比自己差的集合
    for j = 1 : N %每一个都和其他的进行一个个的比较
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
       for k = 1 : M%三个目标函数
           if (Tabu_obj(i,V+k)<Tabu_obj(j,V+k))%目标函数都是越小越好
               dom_less = dom_less + 1;%比自己大反而更差
           elseif (Tabu_obj(i,V+k) ==Tabu_obj(j,V+k))
               dom_equal = dom_equal + 1;
           else
               dom_more = dom_more + 1; 
           end
       end

    if dom_less == 0 && dom_equal ~=M %不比自己差
         individual(i).n = individual(i).n + 1;%比自己好数目
    elseif dom_more == 0 && dom_equal ~=M%至少有一个比自己差
         individual(i).p = [individual(i).p j];%比自己差的集合
    end
    end
     
if individual(i).n == 0%所有个体都比较完毕，得到了 individual(i)矩阵及其属性
   Tabu_obj(i,M + V + 1) = 1;
   F(front).f = [F(front).f i];%第一前端所有个体
end
end

while ~isempty(F(front).f)%继续找第二前端个体
    Q = [];%第n前端所有个体
    for i = 1 : length(F(front).f)%遍历第一前端所有个体
        if ~isempty(individual(F(front).f(i)).p)%第一前端中每个个体的比自己差的集合
            for j = 1 : length(individual(F(front).f(i)).p)
                individual(individual(F(front).f(i)).p(j)).n =individual(individual(F(front).f(i)).p(j)).n - 1;%第一前端中每个个体的比自己差的集合中个体的比自己好的数目减１
                if individual(individual(F(front).f(i)).p(j)).n == 0%只有比自己好的数目变为０才能进行前端排序
                    Tabu_obj(individual(F(front).f(i)).p(j),M + V + 1) = front + 1;%前端个体适应度值
                    Q = [Q individual(F(front).f(i)).p(j)];%第二前端个体
                end
            end
        end
    end
    front = front + 1;
    F(front).f = Q;%第front前端所有个体
end
[~,index_of_fronts] = sort(Tabu_obj(:,M + V + 1)); %[B,I]=sort(A),I为返回的排序后元素在原数组中的行位置或列位置.B为排序（升序）后的列
for i = 1 :length(index_of_fronts)
    sorted_based_on_front(i,:) = Tabu_obj(index_of_fronts(i),:);%按照各自的前端值排序后的种群
end
current_index = 0;
%% Find the crowding distance for each individual in each front
 for front = 1 : (length(F) - 1)%每个前端都要求距离
     y = [];
     previous_index = current_index + 1;
     l=length(F(front).f);
     y= sorted_based_on_front(current_index+1:current_index+l,:);%第front前端的所有个体,M+V+1列，包含到前端值
     current_index = current_index + l;
% Sort each individual based on the objective
sorted_based_on_objective = [];
for i = 1:M%Ｍ个目标函数都要排序
    data=y(:,V+i);%取出第一个目标函数值
    data=data./(1+max(abs(data(isfinite(data)))));%将目标函数映射到（－１，１）之间。TF = isfinite(A),返回一个和A尺寸一样的数组， 如果A中某个元素不是inf， 则对应TF中元素是1， 否则TF中对应元素是0。
    [~, index_of_objectives] = sort(data);%对映射后的目标函数进行排序，优先级可以正常排序，目标距离中有ｉｎｆ依然不能排
    sorted_based_on_objective = [];
    for j = 1 : length(index_of_objectives)
        sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);%第１前端中按第一个目标函数升序排序的个体
    end
%% 一个前端中的第一个个体和最后一个个体的拥挤距离均为ｉｎｆ
y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i)= 1000;% Inf,一个很大的数
y(index_of_objectives(1),M + V + 1 + i) =1000;%1-6列为变量，７－８为目标函数，９为适应度函数，１０为第一个目标函数的拥挤距离，第１１列为第二个目标函数的拥挤距离
for j = 2 : length(index_of_objectives)-1%第２个个体的拥挤距离
    next_obj = sorted_based_on_objective(j + 1,V + i);
    previous_obj = sorted_based_on_objective(j - 1,V + i);
    y(index_of_objectives(j),M + V + 1 + i) =(next_obj - previous_obj);%所以拥挤距离在0-1之间?
    
end
end
distance = [];
distance(:,1)=zeros(length(F(front).f),1);
for i = 1 : M
    distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);%两个目标函数各自的拥挤距离想加就得最后的拥挤距离
end
y(:,M + V + 2) = distance;
y = y(:,1:M + V + 2);
z(previous_index:current_index,:) = y;%Z的1-6列为变量，７－８为目标函数，９为适应度函数，第１０列为拥挤距离的矩阵
 end
Tabu_obj_domination=z();
% Tabu_obj_domination(:,end-4)=-1*Tabu_obj_domination(:,end-4);%排序结束符号还原
% Tabu_obj_domination(:,end-2)=-1*Tabu_obj_domination(:,end-2);%排序结束符号还原




