function recon_data = kpca_reconstruct(pcs, cprs_data, cprs_c, ctr, flag)
    %   pcs:         �������ɷ֣�ÿһ��Ϊһ�����ɷ�
    %   cprs_data:   ѹ��������ݣ�ÿһ�ж�Ӧһ�����ݵ�
    %   cprs_c:      ѹ��ʱ��һЩ��������������ÿһά�ľ�ֵ�ͷ���ȡ�����������������Ӧ�����Իָ���ԭʼ������
    %   recon_data:  �ָ����������ݣ�ÿһ�ж�Ӧһ�����ݵ�
    
    %% �ع�ѹ��ǰ����
    X_zscore=cprs_data*pcs';
    
    meanX=cprs_c(1,:);
    stdX=cprs_c(2,:);
    
    med_data=X_zscore.*stdX+meanX;
    
    [M,N]=size(X_zscore);
    sigma=200;
    recon_data=zeros(size(flag));
    for i=1:N
        for j=1:M
            if flag(j,i)>0
                recon_data(j,i)=abs((-log(med_data(j,i))*(2*sigma^2)).^0.5)+ctr(1,i);
            else
                recon_data(j,i)=-abs((-log(med_data(j,i))*(2*sigma^2)).^0.5)+ctr(1,i);
            end
        end
    end
    
end
