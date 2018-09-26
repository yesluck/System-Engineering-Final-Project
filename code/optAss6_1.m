% 选做6
% 自学至少一种新的聚类分析方法（可以是SOM聚类方法），对同一时段各个路口的交通流量进行聚类分析。

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

train_ori=flow(:,1:days-1,:);
test_ori=flow(:,days,:);

train_a=reshape(train_ori(:,:,:),datapts*(days-1),links);
test_a=reshape(test_ori(:,:,:),datapts,links);

train_a=train_a';
test_a=test_a';

%% 设置SOM网络
N=10;
range=ones(50,2);
range(:,1)=zeros(50,1);
net=newsom(range,[N N]);        %建立som神经网络：10*10
net.trainParam.epochs=100;      %设置迭代次数
net=train(net,train_a);         %利用训练值进行训练
w=net.iw{1} ;                   %对应神经元的权值分量，获得训练结果，为100*50，即每个类50个路口流量情况

%% 绘制向量权值图
[X,Y]=meshgrid(1:size(w,1),1:size(w,2));
figure,surf(X,Y,w');
ylabel('路段名序列');xlabel('神经元');zlabel('权值大小')

%% 对第16天的数据进行训练
res=vec2ind(sim(net,test_a));   %利用SOM网络进行识别，result为对应的分类结果

%% 求均方根误差
for k=1:288                                      %比较分类结果和训练数据，得到均方根误差
    rmse(k)=sqrt((w(res(k),:)-test_a(:,k)')*(w(res(k),:)-test_a(:,k)')')/sqrt(test_a(:,k)'*(test_a(:,k)')');
end
ESS=sum(rmse)/datapts;
fprintf('聚类结果的均方根误差为：%d\n',ESS);

%% 读取需要预测的时间段
preTime = input('请输入你想要进行预测的时间段：');

%% 输出对比的训练结果
figure,plot(1:links,test_a(:,preTime),'b');     %绘制分类结果与训练数据的对比图
hold on,plot(1:links,w(res(preTime),:),'r');  
legend('训练数据','神经元');
xlabel('路段名序列');ylabel('流量值');

