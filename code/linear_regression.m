function [c,c0] = linear_regression(Y,X,rerr)
    [N,~]=size(Y);
    
    %% �ڻع����֮ǰ���������ݽ��й�һ��
    X_zscore=zscore(X)';
    Y_zscore=zscore(Y)';
    
    %% ����ع鷽��
    A=X_zscore*X_zscore';   %����A����
    [n,~]=size(A);
    [Q,~]=eig(A);           %����Q����������������
    D=eig(A);               %����D��������ֵ����
    [D_sort,index]=sort(D,'descend');
    Q_sort=Q(:,index);
    
    %������С��mֵʹ�ƽ������Խ���
    for m=1:n
        if sum(D_sort(m+1:n))/sum(D_sort)<rerr
            break;
        end
    end
    
    Qm=Q_sort(:,1:m);           %����Qm����
    Z=Qm'*X_zscore;             %����Z����
    d=inv(Z*Z')*Z*Y_zscore';    %����d����
    c_zscore=Qm*d;
    c=c_zscore.*sqrt(var(Y))./sqrt(var(X))';    %����c����
    c0=-sum(mean(X)'.*c)+mean(Y);   %���㳣����

end
