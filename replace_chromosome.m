%������Ⱥ�����ѡ��õģ���������Ϊ��һ��
function next_generation= replace_chromosome(intermediate_chromosome,N)
[NZ,var] = size(intermediate_chromosome);
M =3;%Ŀ��
V=var-M-2;%����+Ŀ��+ǰ��+ӵ��
[~,index] = sort(intermediate_chromosome(:,M+V+1));%��ǰ��ֵ����
for i = 1 : NZ
    sorted_chromosome(i,:) = intermediate_chromosome(index(i),:);
end
max_rank = max(intermediate_chromosome(:,M+V+1));%����ǰ��ֵ
%% Start adding each front based on rank and crowing distance until the whole population is filled.
previous_index = 0;
for i = 1 : max_rank%��ÿ��ǰ�˼�����һ����
    current_index = max(find(sorted_chromosome(:,M+V+1) == i));%��ǰǰ�˵����һ����������
    if current_index >N
        remaining =N-previous_index;
        temp_pop =sorted_chromosome(previous_index + 1 : current_index, :);%�ڣ�ǰ�����и���
        [~,temp_sort_index] = sort(temp_pop(:,M + V + 2),'descend');%�ڣ�ǰ�˸����ӵ�����뽵������
        for j = 1 : remaining
          next_generation(previous_index + j,:) = temp_pop(temp_sort_index(j),:);
        end
        return;%breakҲ���ԣ���Ϊ��������ֱ�ӷ���next_generation�ˣ���ֱ����return��������Ҳ�޸�������ִ��
    elseif current_index <N%����ǰ��ȫ��������һ��
       next_generation(previous_index + 1 : current_index, :) =sorted_chromosome(previous_index + 1 : current_index, :);
    else%current_index=N
        next_generation(previous_index + 1 : current_index, :) = sorted_chromosome(previous_index + 1 : current_index, :);
        return; % �ں���������return����ֱ�ӴӴ˺�����������������������ֱ�ӷ��ؽ������break����ѭ�������--for��while��������������ѭ�����
 
    end
    previous_index = current_index;
end

%% ����������������
%break����ֱ��������ѭ��,ִ��ѭ�������򣩺�������
%continue����ֱ�ӽ���ò�ѭ������һ�ε���
%return����ֱ���˳��������������
%return>break>continue       
        
        
            





end

