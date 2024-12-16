%父子种群混合再选择好的２００个作为下一代
function next_generation= replace_chromosome(intermediate_chromosome,N)
[NZ,var] = size(intermediate_chromosome);
M =3;%目标
V=var-M-2;%变量+目标+前端+拥挤
[~,index] = sort(intermediate_chromosome(:,M+V+1));%对前端值排序
for i = 1 : NZ
    sorted_chromosome(i,:) = intermediate_chromosome(index(i),:);
end
max_rank = max(intermediate_chromosome(:,M+V+1));%最大的前端值
%% Start adding each front based on rank and crowing distance until the whole population is filled.
previous_index = 0;
for i = 1 : max_rank%将每个前端加入下一代中
    current_index = max(find(sorted_chromosome(:,M+V+1) == i));%当前前端的最后一个个体的序号
    if current_index >N
        remaining =N-previous_index;
        temp_pop =sorted_chromosome(previous_index + 1 : current_index, :);%第ｉ前端所有个体
        [~,temp_sort_index] = sort(temp_pop(:,M + V + 2),'descend');%第ｉ前端个体的拥挤距离降序排列
        for j = 1 : remaining
          next_generation(previous_index + j,:) = temp_pop(temp_sort_index(j),:);
        end
        return;%break也可以，因为函数可以直接返回next_generation了（故直接用return），下面也无更多命令执行
    elseif current_index <N%将本前端全部加入下一代
       next_generation(previous_index + 1 : current_index, :) =sorted_chromosome(previous_index + 1 : current_index, :);
    else%current_index=N
        next_generation(previous_index + 1 : current_index, :) = sorted_chromosome(previous_index + 1 : current_index, :);
        return; % 在函数中遇见return；则直接从此函数中跳出，结束整个函数直接返回结果，而break用于循环语句中--for，while，作用是跳出次循环语句
 
    end
    previous_index = current_index;
end

%% 几个跳出函数区别
%break就是直接跳出该循环,执行循环（程序）后面的语句
%continue就是直接进入该层循环的下一次迭代
%return就是直接退出程序或函数返回了
%return>break>continue       
        
        
            





end

