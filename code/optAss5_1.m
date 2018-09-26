% ѡ��5
% ��ѧ�������ɷַ�������Ҷ˹���ɷַ����������ɷַ����ȷ����е�һ�ֻ��߶��֣����������ݽ���ѹ���ͽ�ѹ����
% ����ý��ڷ�����ѹ���ȡ�ѹ�����ȵȲ����Ͻ��жԱȷ�����

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

%% ��ȡ��·��16�������Ϊ288*16*50�ľ��󣬲������Ϊ4608*50�ľ���
a=reshape(flow(:,:,:),datapts*days,links);

%% �������ݷ���
[M,N]=size(a);
ctr=zeros(1,N);
for i=1:N
   ctr(i)=sum(a(:,i))/M;
end
flag(:,1:N)=sign(a(:,1:N)-ctr(1,1:N));

%% ����KPCA����ѹ��
rerr=0.05;
[pcs, cprs_data, cprs_c] = kpca_compress(a, ctr, rerr);
recon_data = kpca_reconstruct(pcs, cprs_data, cprs_c, ctr, flag);

%% �������ݷ���
% ѹ����
den=size(pcs,1)*size(pcs,2)+size(cprs_data,1)*size(cprs_data,2)+size(cprs_c,1)*size(cprs_c,2)+size(ctr,2);
nom=size(a,1)*size(a,2);
CR=nom/den;

% ���������
rmse=sqrt(sum(sum((recon_data-a).*(recon_data-a))))/sqrt(sum(sum(recon_data.*a)));

% ������
fprintf('ѹ����Ϊ%f�����������Ϊ%f\n',CR,rmse);

%% ��ȡ��Ҫ��ʾ��·��
preCrs = input('����������Ҫ����ͼ����ʾѹ�������·�ڣ�');
figure,plot(a(:,preCrs),'b');hold on;plot(real(recon_data(:,preCrs)),'r');
legend('ԭʼ����','ѹ������ԭ�������');title('����KPCA����ѹ��ǰ��ıȽϽ��');xlabel('���ݵ�');ylabel('����ֵ');
