function [c,c0] = linear_regression(Y,X,rerr)
    [N,~]=size(Y);
    
    %% 在回归分析之前对样本数据进行归一化
    X_zscore=zscore(X)';
    Y_zscore=zscore(Y)';
    
    %% 计算回归方程
    A=X_zscore*X_zscore';   %计算A矩阵
    [n,~]=size(A);
    [Q,~]=eig(A);           %计算Q矩阵（特征向量矩阵）
    D=eig(A);               %计算D矩阵（特征值矩阵）
    [D_sort,index]=sort(D,'descend');
    Q_sort=Q(:,index);
    
    %计算最小的m值使逼近误差可以接受
    for m=1:n
        if sum(D_sort(m+1:n))/sum(D_sort)<rerr
            break;
        end
    end
    
    Qm=Q_sort(:,1:m);           %计算Qm矩阵
    Z=Qm'*X_zscore;             %计算Z矩阵
    d=inv(Z*Z')*Z*Y_zscore';    %计算d矩阵
    c_zscore=Qm*d;
    c=c_zscore.*sqrt(var(Y))./sqrt(var(X))';    %计算c矩阵
    c0=-sum(mean(X)'.*c)+mean(Y);   %计算常数项

end
