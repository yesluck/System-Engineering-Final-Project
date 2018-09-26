function recon_data = pca_reconstruct(pcs, cprs_data, cprs_c)
    %   pcs:         �������ɷ֣�ÿһ��Ϊһ�����ɷ�
    %   cprs_data:   ѹ��������ݣ�ÿһ�ж�Ӧһ�����ݵ�
    %   cprs_c:      ѹ��ʱ��һЩ��������������ÿһά�ľ�ֵ�ͷ���ȡ�����������������Ӧ�����Իָ���ԭʼ������
    %   recon_data:  �ָ����������ݣ�ÿһ�ж�Ӧһ�����ݵ�
    
    %% �ع�ѹ��ǰ����
    X_zscore=cprs_data*pcs';
    
    meanX=cprs_c(1,:);
    stdX=cprs_c(2,:);
    
    recon_data=X_zscore.*stdX+meanX;
    
end
