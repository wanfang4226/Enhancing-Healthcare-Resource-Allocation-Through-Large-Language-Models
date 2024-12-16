%Tournament Selection,选择
function pool= selection(pop,pool_size,tour_size)
%pop是当代种群，在进行锦标赛选择（二选择）之后，好的个体被选中以形成大小为“pool_size”的交配池，比赛池大小为“tour_size”
[N,variables] = size(pop); %[pop,variables] = size(chromosome);; 
rank = variables - 1;%前端值
distance= variables;
for i = 1 : pool_size%选100次
    for j = 1 : tour_size%j=1,2
        candidate(j) = round(N*rand(1));
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1%产生的第２个个体时          
            while ~isempty(find(candidate(1 : j - 1) == candidate(j)))%新产生的随机数是否和已有的（前几个）重复
                candidate(j) = round(N*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;
                end
            end
        end
    end
    for j = 1 : tour_size
        c_obj_rank(j) =pop(candidate(j),rank);%rank代表适应度值和前端数
        c_obj_distance(j) =pop(candidate(j),distance);%rank代表拥挤距离
    end
    min_candidate=find(c_obj_rank == min(c_obj_rank));%两个比较个体的前端值
    if length(min_candidate) ~= 1%两个在同一前端的情况
        max_candidate =find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        if length(max_candidate) ~= 1%两个个体拥挤距离相同
            max_candidate = max_candidate(1);
        end
        pool(i,:) = pop(candidate(min_candidate(max_candidate)),:);  
    else
        pool(i,:) =pop(candidate(min_candidate(1)),:);%选择两个中的好的

    end        
end
%can_num;最终选择的序号

           
        
        
