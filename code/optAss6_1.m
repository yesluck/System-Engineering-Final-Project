% ѡ��6
% ��ѧ����һ���µľ������������������SOM���෽��������ͬһʱ�θ���·�ڵĽ�ͨ�������о��������

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

train_ori=flow(:,1:days-1,:);
test_ori=flow(:,days,:);

train_a=reshape(train_ori(:,:,:),datapts*(days-1),links);
test_a=reshape(test_ori(:,:,:),datapts,links);

train_a=train_a';
test_a=test_a';

%% ����SOM����
N=10;
range=ones(50,2);
range(:,1)=zeros(50,1);
net=newsom(range,[N N]);        %����som�����磺10*10
net.trainParam.epochs=100;      %���õ�������
net=train(net,train_a);         %����ѵ��ֵ����ѵ��
w=net.iw{1} ;                   %��Ӧ��Ԫ��Ȩֵ���������ѵ�������Ϊ100*50����ÿ����50��·���������

%% ��������Ȩֵͼ
[X,Y]=meshgrid(1:size(w,1),1:size(w,2));
figure,surf(X,Y,w');
ylabel('·��������');xlabel('��Ԫ');zlabel('Ȩֵ��С')

%% �Ե�16������ݽ���ѵ��
res=vec2ind(sim(net,test_a));   %����SOM�������ʶ��resultΪ��Ӧ�ķ�����

%% ����������
for k=1:288                                      %�ȽϷ�������ѵ�����ݣ��õ����������
    rmse(k)=sqrt((w(res(k),:)-test_a(:,k)')*(w(res(k),:)-test_a(:,k)')')/sqrt(test_a(:,k)'*(test_a(:,k)')');
end
ESS=sum(rmse)/datapts;
fprintf('�������ľ��������Ϊ��%d\n',ESS);

%% ��ȡ��ҪԤ���ʱ���
preTime = input('����������Ҫ����Ԥ���ʱ��Σ�');

%% ����Աȵ�ѵ�����
figure,plot(1:links,test_a(:,preTime),'b');     %���Ʒ�������ѵ�����ݵĶԱ�ͼ
hold on,plot(1:links,w(res(preTime),:),'r');  
legend('ѵ������','��Ԫ');
xlabel('·��������');ylabel('����ֵ');

