% 选做5
% 自学概率主成分分析、贝叶斯主成分分析、核主成分分析等方法中的一种或者多种，对上述数据进行压缩和解压缩。
% 与课堂讲授方法在压缩比、压缩精度等参数上进行对比分析。

% flow_50link	流量数据，50个检测器16天（2006.10.22~2006.11.6）的数据，每天的数据点为288个（5分钟一个数据）
% occ_50link	占有率数据，采集方式同上
% link_info     50个检测器的相关信息，包括检测器id，路口号，路口名等信息
% time_link     16天每天288个数据对应的检测时间

clc
clear
close all

%% 读取数据
data=load('data_16d.mat');
flow=data.flow_50link;
[datapts,days,links]=size(flow);

%% 提取该路口16天的数据为288*16*50的矩阵，并将其变为4608*50的矩阵
a=reshape(flow(:,:,:),datapts*days,links);

%% 进行数据分析
[M,N]=size(a);
ctr=zeros(1,N);
for i=1:N
   ctr(i)=sum(a(:,i))/M;
end
flag(:,1:N)=sign(a(:,1:N)-ctr(1,1:N));

%% 进行KPCA数据压缩
rerr=0.05;
[pcs, cprs_data, cprs_c] = kpca_compress(a, ctr, rerr);
recon_data = kpca_reconstruct(pcs, cprs_data, cprs_c, ctr, flag);

%% 进行数据分析
% 压缩比
den=size(pcs,1)*size(pcs,2)+size(cprs_data,1)*size(cprs_data,2)+size(cprs_c,1)*size(cprs_c,2)+size(ctr,2);
nom=size(a,1)*size(a,2);
CR=nom/den;

% 均方根误差
rmse=sqrt(sum(sum((recon_data-a).*(recon_data-a))))/sqrt(sum(sum(recon_data.*a)));

% 输出结果
fprintf('压缩比为%f，均方根误差为%f\n',CR,rmse);

%% 读取需要显示的路口
preCrs = input('请输入你想要进行图像显示压缩结果的路口：');
figure,plot(a(:,preCrs),'b');hold on;plot(real(recon_data(:,preCrs)),'r');
legend('原始数据','压缩并复原后的数据');title('进行KPCA数据压缩前后的比较结果');xlabel('数据点');ylabel('流量值');
