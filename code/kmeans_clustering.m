function [label,J,centers] = kmeans_clustering(data, num)
    %% ��ȡ���ݲ����г�ʼ�趨
    [N,p]=size(data);
    data=zscore(data);
    delta=0.01;
    
    a1=3;
    a2=2*a1;
    surrond=zeros(N,1);     %����ÿ������Χ�ĵ���
    centers=zeros(num,p);   %����������������ĵ�����
    distance=zeros(N,N);    %����ÿ����֮��ľ���
    
    %% ����ÿ����֮��ľ����ÿ���㡰��Χ���ĵ���
    for i=1:N
        for j=i+1:N
            temp=dista(data(i,:),data(j,:));
            distance(i,j)=temp;
            distance(j,i)=temp;
            if distance(i,j)<a1
                surrond(i,1)=surrond(i,1)+1;    %����ÿ������Χ�ĵ���
                surrond(j,1)=surrond(j,1)+1;
            end
        end
    end
    
    %% ���ա���Χ���������ٽ�������ѡȡ��һ���ĵ�
    [~,index]=sort(surrond,'descend');
    centers(1,:)=data(index(1),:);      %��һ���ĵ�
    ctr_num=1;                          %��ȷ�������ĵ����
    
    %% ѡȡ�ڶ���������num�����ĵ�
    for i=2:N
        able=1;
        for j=1:ctr_num
            if dista(centers(j,:),data(index(i),:))<a2
                able=0;                 %����õ���֮ǰ�����ĵ������������ܵ������ĵ�
            end
        end
        if able==1
            ctr_num=ctr_num+1;
            centers(ctr_num,:)=data(index(i),:);
        end
        if ctr_num==num
            break;
        end
        if ctr_num<num && i==N
            fprintf('�Ҳ�����%d�����ĵ㣬�����������\n',ctr_num+1);
        end
    end
    
    %% ����
    dis_ctr=zeros(num,N);           %ÿ���������ĵ�ľ���
    iter=0;
    while true
        iter=iter+1;
        %����������ĵ�ԭ����з���
        for i=1:num
            for j=1:N
                dis_ctr(i,j)=dista(centers(i,:),data(j,:));
            end
        end
        [~,index2]=sort(dis_ctr,1);
        label=zeros(N,1);
        label(:)=index2(1,:);       %����ĳ���ĵ�������ͽ���ֵ���һ��
        
        %�޸����ĵ�
        change=0;
        for i=1:num
            oldctr(:)=centers(i,:);
            [siz,~]=size(data(label==i,1));
            centers(i,:)=sum(data(label==i,:))/siz;    %����µ����ĵ�
            if dista(oldctr(:)',centers(i,:))>delta
               change=1;            %����¾����ĵ��������Ҫ�������и���
            end
        end
        if change==0
            break;                  %����Ѿ�û����Ҫ�仯���ˣ���ֹͣ����
        end
    end
    
    %% ����Ŀ�꺯��ֵ
    J=0;
    for i=1:N
        J=J+dista(centers(label(i),:),data(i,:));
    end
end
