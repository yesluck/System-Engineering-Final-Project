function [pcs, cprs_data, cprs_c] = pca_compress(data, rerr)
    %   data:       输入的原始数据矩阵，每一行对应一个数据点
    %   rerr:       相对误差界限，即相对误差应当小于这个值，用于确定主成分个数
    %   pcs :       各个主成分，每一列为一个主成分
    %   cprs_data:  压缩后的数据，每一行对应一个数据点
    %   cprs_c:     压缩时的一些常数，包括数据每一维的均值和方差等
    %   利用以上三个变量应当可以恢复出原始的数据

    %% 读取数据，分解自变量与因变量
    %   M:  样本个数（即行数）
    %   D:  data列数
    %   N:  自变量维数
    %   X:  M行N列自变量矩阵
    %   Y:  M行1列因变量矩阵
    
    [~,N]=size(data);
    X(:,1:N)=data(:,1:N);

    %% 规范化
    %   X_zscore:   (经过转置)N行M列自变量矩阵
    
    X_zscore=zscore(X)';
    
    %% 确定特征值矩阵和特征向量矩阵
    %   A:  归一化样本数据协方差矩阵
    %   Q:  A的特征向量矩阵
    %   D:  A的特征值矩阵
    
    A=X_zscore*X_zscore';
    [Q,~]=eig(A);
    D=eig(A);
    
    %% 计算主成分
    %   Q_sort: 对特征值进行排序
    %   Qm:     前m个特征值所对应的特征向量
    %   Y:      各样本数据在主成分方向上的投影
    
    [D_sort,index]=sort(D,'descend');
    Q_sort=Q(:,index);
    
    for m=1:N-1
        if sum(D_sort(m+1:N))/sum(D_sort)<rerr
            break;
        end
    end
    
    Qm=Q_sort(:,1:m);           %计算Qm矩阵
    yt=Qm'*X_zscore;            %计算Y矩阵（投影）
    
    %% 输出结果
    pcs=Qm;                     %输出m个主成分分量，为N*m
    cprs_data=yt';              %输出m个主成分方向的投影，即压缩后的数据，为M*m（3114*11）
    cprs_c(1,:)=mean(X);        %输出样本均值
    cprs_c(2,:)=std(X);         %输出样本标准差
    
end
