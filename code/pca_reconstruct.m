function recon_data = pca_reconstruct(pcs, cprs_data, cprs_c)
    %   pcs:         各个主成分，每一列为一个主成分
    %   cprs_data:   压缩后的数据，每一行对应一个数据点
    %   cprs_c:      压缩时的一些常数，包括数据每一维的均值和方差等。利用以上三个变量应当可以恢复出原始的数据
    %   recon_data:  恢复出来的数据，每一行对应一个数据点
    
    %% 重构压缩前数据
    X_zscore=cprs_data*pcs';
    
    meanX=cprs_c(1,:);
    stdX=cprs_c(2,:);
    
    recon_data=X_zscore.*stdX+meanX;
    
end
