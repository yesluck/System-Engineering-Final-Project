function [label,J,centers] = kmeans_clustering(data, num)
    %% 读取数据并进行初始设定
    [N,p]=size(data);
    data=zscore(data);
    delta=0.01;
    
    a1=3;
    a2=2*a1;
    surrond=zeros(N,1);     %代表每个点周围的点数
    centers=zeros(num,p);   %代表两个聚类的中心点坐标
    distance=zeros(N,N);    %代表每个点之间的距离
    
    %% 计算每个点之间的距离和每个点“周围”的点数
    for i=1:N
        for j=i+1:N
            temp=dista(data(i,:),data(j,:));
            distance(i,j)=temp;
            distance(j,i)=temp;
            if distance(i,j)<a1
                surrond(i,1)=surrond(i,1)+1;    %更新每个点周围的点数
                surrond(j,1)=surrond(j,1)+1;
            end
        end
    end
    
    %% 按照“周围”点数多少进行排序并选取第一中心点
    [~,index]=sort(surrond,'descend');
    centers(1,:)=data(index(1),:);      %第一中心点
    ctr_num=1;                          %已确定的中心点个数
    
    %% 选取第二（乃至第num）中心点
    for i=2:N
        able=1;
        for j=1:ctr_num
            if dista(centers(j,:),data(index(i),:))<a2
                able=0;                 %如果该点与之前的中心点距离过近，则不能当做中心点
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
            fprintf('找不到第%d个中心点，请调整参数！\n',ctr_num+1);
        end
    end
    
    %% 分类
    dis_ctr=zeros(num,N);           %每个点与中心点的距离
    iter=0;
    while true
        iter=iter+1;
        %按照最近中心点原则进行分类
        for i=1:num
            for j=1:N
                dis_ctr(i,j)=dista(centers(i,:),data(j,:));
            end
        end
        [~,index2]=sort(dis_ctr,1);
        label=zeros(N,1);
        label(:)=index2(1,:);       %距离某中心点最近，就将其分到这一类
        
        %修改中心点
        change=0;
        for i=1:num
            oldctr(:)=centers(i,:);
            [siz,~]=size(data(label==i,1));
            centers(i,:)=sum(data(label==i,:))/siz;    %获得新的中心点
            if dista(oldctr(:)',centers(i,:))>delta
               change=1;            %如果新旧中心点差距过大，需要继续进行更换
            end
        end
        if change==0
            break;                  %如果已经没有需要变化的了，就停止迭代
        end
    end
    
    %% 计算目标函数值
    J=0;
    for i=1:N
        J=J+dista(centers(label(i),:),data(i,:));
    end
end
