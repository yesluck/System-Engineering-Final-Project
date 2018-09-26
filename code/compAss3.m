% ����3
% ���ڿ��ý��ڵ�K-means��ϵͳ����Ⱦ������������ѡȡ��߷�ʱ�Σ���7:00-9:00�������ݣ�
% ����ͬʱ�θ���·�ڵĽ�ͨ�������о����������·�ν��о�������о�����
% Ҫ����ѡ��K��ֵ���࣬�������Ŀ�ɱ仯����ѡ��ϵͳ���࣬��Ҫ����ƾ�����ϵͼ��

% flow_50link	�������ݣ�50�������16�죨2006.10.22~2006.11.6�������ݣ�ÿ������ݵ�Ϊ288����5����һ�����ݣ�
% occ_50link	ռ�������ݣ��ɼ���ʽͬ��
% link_info     50��������������Ϣ�����������id��·�ںţ�·��������Ϣ
% time_link     16��ÿ��288�����ݶ�Ӧ�ļ��ʱ��

clc
clear
close all

%% ��ȡ����
data=load('data_16d.mat');
flow=data.flow_50link;
[datapts,days,links]=size(flow);
flow_rshr=flow(85:108,:,:);
[rshrpts,~,~]=size(flow_rshr);
a=reshape(flow_rshr(:,:,:),rshrpts*days,links);
a=a';

%% ̽��������Ŀ��Ŀ�꺯���Ĺ�ϵ
J=zeros(25,1);
labels=zeros(25,50);
for num=2:25
    [labels(num,:),J(num)]=kmeans_clustering(a, num);
end
figure,plot(2:25,J(2:25));

%% ���о���
num = input('�����������Ŀ��');
[label,~,centers] = kmeans_clustering(a, num);

%% ���з���
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
    legend('��1����','��2����','��3����');
    
end
