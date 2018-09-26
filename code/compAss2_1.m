% ����2
% ���ڿ��ý��ڵ����ɷַ�������ѡȡ��ͬ���ɷ֣����������ݽ���ѹ���ͽ�ѹ����
% ���Աȷ���ѹ���ȡ�ѹ�����ȵȲ�����

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

%% ��ȡ·��16�������Ϊ288*16*50�ľ��󣬲������Ϊ4608*50�ľ���
a=reshape(flow(:,:,:),datapts*days,links);

%% ����PCA����ѹ��
rerr=0.05;
[pcs, cprs_data, cprs_c] = pca_compress(a, rerr);
recon_data = pca_reconstruct(pcs, cprs_data, cprs_c);

%% �������ݷ���
% ѹ����
den=size(pcs,1)*size(pcs,2)+size(cprs_data,1)*size(cprs_data,2)+size(cprs_c,1)*size(cprs_c,2);
nom=size(a,1)*size(a,2);
CR=nom/den;

% ���������
rmse=sqrt(sum(sum((recon_data-a).*(recon_data-a))))/sqrt(sum(sum(recon_data.*a)));

% ������
fprintf('ѹ����Ϊ%f�����������Ϊ%f\n',CR,rmse);

%% ��ȡ��Ҫ��ʾ��·��
preCrs = input('����������Ҫ����ͼ����ʾѹ�������·�ڣ�');
figure,plot(a(:,preCrs),'b');hold on;plot(recon_data(:,preCrs),'r');
legend('ԭʼ����','ѹ������ԭ�������');title('����PCA����ѹ��ǰ��ıȽϽ��');xlabel('���ݵ�');ylabel('����ֵ');

