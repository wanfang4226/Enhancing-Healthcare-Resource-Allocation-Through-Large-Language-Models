%Tournament Selection,ѡ��
function pool= selection(pop,pool_size,tour_size)
%pop�ǵ�����Ⱥ���ڽ��н�����ѡ�񣨶�ѡ��֮�󣬺õĸ��屻ѡ�����γɴ�СΪ��pool_size���Ľ���أ������ش�СΪ��tour_size��
[N,variables] = size(pop); %[pop,variables] = size(chromosome);; 
rank = variables - 1;%ǰ��ֵ
distance= variables;
for i = 1 : pool_size%ѡ100��
    for j = 1 : tour_size%j=1,2
        candidate(j) = round(N*rand(1));
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1%�����ĵڣ�������ʱ          
            while ~isempty(find(candidate(1 : j - 1) == candidate(j)))%�²�����������Ƿ�����еģ�ǰ�������ظ�
                candidate(j) = round(N*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;
                end
            end
        end
    end
    for j = 1 : tour_size
        c_obj_rank(j) =pop(candidate(j),rank);%rank������Ӧ��ֵ��ǰ����
        c_obj_distance(j) =pop(candidate(j),distance);%rank����ӵ������
    end
    min_candidate=find(c_obj_rank == min(c_obj_rank));%�����Ƚϸ����ǰ��ֵ
    if length(min_candidate) ~= 1%������ͬһǰ�˵����
        max_candidate =find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        if length(max_candidate) ~= 1%��������ӵ��������ͬ
            max_candidate = max_candidate(1);
        end
        pool(i,:) = pop(candidate(min_candidate(max_candidate)),:);  
    else
        pool(i,:) =pop(candidate(min_candidate(1)),:);%ѡ�������еĺõ�

    end        
end
%can_num;����ѡ������

           
        
        
