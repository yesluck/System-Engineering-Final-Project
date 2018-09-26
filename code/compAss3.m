% 必做3
% 基于课堂讲授的K-means或系统聚类等聚类分析方法，选取早高峰时段（早7:00-9:00）的数据，
% 对相同时段各个路口的交通流量进行聚类分析（将路段进行聚类分析研究）；
% 要求：若选择K均值聚类，则聚类数目可变化；如选择系统聚类，则要求绘制聚类谱系图。

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
flow_rshr=flow(85:108,:,:);
[rshrpts,~,~]=size(flow_rshr);
a=reshape(flow_rshr(:,:,:),rshrpts*days,links);
a=a';

%% 探索聚类数目和目标函数的关系
J=zeros(25,1);
labels=zeros(25,50);
for num=2:25
    [labels(num,:),J(num)]=kmeans_clustering(a, num);
end
figure,plot(2:25,J(2:25));

%% 进行聚类
num = input('请输入聚类数目：');
[label,~,centers] = kmeans_clustering(a, num);

%% 进行分析
if num==3
    list1=find(label==1);
    list2=find(label==2);
    list3=find(label==3);

    a1=zeros(size(list1));
    a2=zeros(size(list2));
    a3=zeros(size(list3));

    for i=1:size(list1,1)
        a1(i)=mean(a(list1(i),:));
    end

    for i=1:size(list2,1)
        a2(i)=mean(a(list2(i),:));
    end

    for i=1:size(list3,1)
        a3(i)=mean(a(list3(i),:));
    end

    figure,plot(1:size(list1,1),a1);
    hold on,plot(1:size(list2,1),a2);
    hold on,plot(1:size(list3,1),a3);
    legend('第1聚类','第2聚类','第3聚类');
    
end
