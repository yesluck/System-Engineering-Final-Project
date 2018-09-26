% 选做4
% 自学至少一种新的交通流预测方法，仍以最后两天的数据为预测值，之前的数据为训练值，
% 给出分时段（5分钟，10分钟和15分钟）预测结果，与课堂讲授方法在预测精度方面进行对比分析。

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

%% 读取需要预测的路口
preCrs = input('请输入你想要进行预测的路口：');

%% 数据初始化
Y_pre=zeros(datapts,2);
Y_pre(1,1)=flow(1,15,preCrs);
Y_pre(1,2)=flow(1,16,preCrs);

Y_actual=zeros(datapts,2);
Y_actual(:,1)=flow(:,15,preCrs);
Y_actual(:,2)=flow(:,16,preCrs);

%% 进行预测
for i=1:datapts-1
    % 训练前14天数据
    Y=flow(i+1,1:14,preCrs)';
    X=flow(1:i,1:14,preCrs)';
    model=svmtrain(Y,X);
    
    % 预测第15天数据
    X_pre1=flow(1:i,15,preCrs)';
    [Y_pre(i+1,1),~,~]=svmpredict(Y_actual(i+1,1),X_pre1,model);
    
    % 预测第16天数据
    X_pre2=flow(1:i,16,preCrs)';
    [Y_pre(i+1,2),~,~]=svmpredict(Y_actual(i+1,2),X_pre2,model);
    
end

err=abs(Y_pre-Y_actual)./Y_actual;
err_percent=sum(err)/datapts;
fprintf('以5分钟为1个时段进行预测，第%d个路口：第15天的预测平均相对误差%f%%，第16天的预测平均相对误差为%f%%\n',preCrs,100*err_percent(1),100*err_percent(2));

figure,plot(1:1:datapts,Y_actual(:,1),'b');hold on;plot(1:1:datapts,Y_pre(:,1),'r');
legend('实际值','预测值');title('以5分钟为1个时段进行预测，第15天的预测结果');xlabel('数据点');ylabel('流量值');

figure,plot(1:1:datapts,Y_actual(:,2),'b');hold on;plot(1:1:datapts,Y_pre(:,2),'r');
legend('实际值','预测值');title('以5分钟为1个时段进行预测，第16天的预测结果');xlabel('数据点');ylabel('流量值');


%% 以10分钟为1个时段进行预测
flow_ori=flow;
datapts=datapts/2;
flow=zeros(datapts,days,links);
for i=1:datapts
    flow(i,:,:)=flow_ori(2*i-1,:,:)+flow_ori(2*i,:,:);
end

% 数据初始化
Y_pre=zeros(datapts,2);
Y_pre(1,1)=flow(1,15,preCrs);
Y_pre(1,2)=flow(1,16,preCrs);

Y_actual=zeros(datapts,2);
Y_actual(:,1)=flow(:,15,preCrs);
Y_actual(:,2)=flow(:,16,preCrs);

% 进行预测
for i=1:datapts-1
    % 训练前14天数据
    Y=flow(i+1,1:14,preCrs)';
    X=flow(1:i,1:14,preCrs)';
    model=svmtrain(Y,X);
    
    % 预测第15天数据
    X_pre1=flow(1:i,15,preCrs)';
    [Y_pre(i+1,1),~,~]=svmpredict(Y_actual(i+1,1),X_pre1,model);
    
    % 预测第16天数据
    X_pre2=flow(1:i,16,preCrs)';
    [Y_pre(i+1,2),~,~]=svmpredict(Y_actual(i+1,2),X_pre2,model);
    
end

err=abs(Y_pre-Y_actual)./Y_actual;
err_percent=sum(err)/datapts;
fprintf('以10分钟为1个时段进行预测，第%d个路口：第15天的预测平均相对误差%f%%，第16天的预测平均相对误差为%f%%\n',preCrs,100*err_percent(1),100*err_percent(2));

figure,plot(1:1:datapts,Y_actual(:,1),'b');hold on;plot(1:1:datapts,Y_pre(:,1),'r');
legend('实际值','预测值');title('以10分钟为1个时段进行预测，第15天的预测结果');xlabel('数据点');ylabel('流量值');

figure,plot(1:1:datapts,Y_actual(:,2),'b');hold on;plot(1:1:datapts,Y_pre(:,2),'r');
legend('实际值','预测值');title('以10分钟为1个时段进行预测，第16天的预测结果');xlabel('数据点');ylabel('流量值');

%% 以15分钟为1个时段进行预测
datapts=datapts*2/3;
flow=zeros(datapts,days,links);
for i=1:datapts
    flow(i,:,:)=flow_ori(3*i-2,:,:)+flow_ori(3*i-1,:,:)+flow_ori(3*i,:,:);
end

% 数据初始化
Y_pre=zeros(datapts,2);
Y_pre(1,1)=flow(1,15,preCrs);
Y_pre(1,2)=flow(1,16,preCrs);

Y_actual=zeros(datapts,2);
Y_actual(:,1)=flow(:,15,preCrs);
Y_actual(:,2)=flow(:,16,preCrs);

% 进行预测
for i=1:datapts-1
    % 训练前14天数据
    Y=flow(i+1,1:14,preCrs)';
    X=flow(1:i,1:14,preCrs)';
    model=svmtrain(Y,X);
    
    % 预测第15天数据
    X_pre1=flow(1:i,15,preCrs)';
    [Y_pre(i+1,1),~,~]=svmpredict(Y_actual(i+1,1),X_pre1,model);
    
    % 预测第16天数据
    X_pre2=flow(1:i,16,preCrs)';
    [Y_pre(i+1,2),~,~]=svmpredict(Y_actual(i+1,2),X_pre2,model);
    
end

err=abs(Y_pre-Y_actual)./Y_actual;
err_percent=sum(err)/datapts;
fprintf('以15分钟为1个时段进行预测，第%d个路口：第15天的预测平均相对误差%f%%，第16天的预测平均相对误差为%f%%\n',preCrs,100*err_percent(1),100*err_percent(2));

figure,plot(1:1:datapts,Y_actual(:,1),'b');hold on;plot(1:1:datapts,Y_pre(:,1),'r');
legend('实际值','预测值');title('以15分钟为1个时段进行预测，第15天的预测结果');xlabel('数据点');ylabel('流量值');

figure,plot(1:1:datapts,Y_actual(:,2),'b');hold on;plot(1:1:datapts,Y_pre(:,2),'r');
legend('实际值','预测值');title('以15分钟为1个时段进行预测，第16天的预测结果');xlabel('数据点');ylabel('流量值');
