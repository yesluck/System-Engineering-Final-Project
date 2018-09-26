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

flow_rshr=flow(85:108,:,:);
[rshrpts,~,~]=size(flow_rshr);

train_ori=flow_rshr(:,1:days-1,:);
test_ori=flow_rshr(:,days,:);

train_a=reshape(train_ori(:,:,:),rshrpts,links*(days-1));
test_a=reshape(test_ori(:,:,:),rshrpts,links);

%% ����SOM����
N=4;
range=ones(24,2);
range(:,1)=zeros(24,1);
net=newsom(range,[N N]);        %����som�����磺2*2
net.trainParam.epochs=100;      %���õ�������
net=train(net,train_a);         %����ѵ��ֵ����ѵ��
w=net.iw{1} ;                   %��Ӧ��Ԫ��Ȩֵ���������ѵ�������Ϊ100*50����ÿ����50��·���������

%% ��������Ȩֵͼ
[X,Y]=meshgrid(1:size(w,1),1:size(w,2));
figure,surf(X,Y,w');
ylabel('ʱ���');xlabel('��Ԫ');zlabel('Ȩֵ��С')

%% �Ե�16������ݽ���ѵ��
res=vec2ind(sim(net,test_a));   %����SOM�������ʶ��resultΪ��Ӧ�ķ�����

%% ����������
for k=1:50                                      %�ȽϷ�������ѵ�����ݣ��õ����������
    rmse(k)=sqrt((w(res(k),:)-test_a(:,k)')*(w(res(k),:)-test_a(:,k)')')/sqrt(test_a(:,k)'*(test_a(:,k)')');
end
ESS=sum(rmse)/50;
fprintf('�������ľ��������Ϊ��%d\n',ESS);

%% ��ȡ��ҪԤ���ʱ���
preCrs = input('����������Ҫ����Ԥ���·�ڣ�');

%% ����Աȵ�ѵ�����
plot(1:rshrpts,test_a(:,preCrs),'b');              %���Ʒ�������ѵ�����ݵĶԱ�ͼ
hold on,plot(1:rshrpts,w(res(preCrs),:),'r');  
legend('ѵ������','��Ԫ');
xlabel('ʱ��ڵ�');ylabel('����ֵ');

