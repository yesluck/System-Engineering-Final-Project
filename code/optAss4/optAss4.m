% ѡ��4
% ��ѧ����һ���µĽ�ͨ��Ԥ�ⷽ��������������������ΪԤ��ֵ��֮ǰ������Ϊѵ��ֵ��
% ������ʱ�Σ�5���ӣ�10���Ӻ�15���ӣ�Ԥ����������ý��ڷ�����Ԥ�⾫�ȷ�����жԱȷ�����

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

%% ��ȡ��ҪԤ���·��
preCrs = input('����������Ҫ����Ԥ���·�ڣ�');

%% ���ݳ�ʼ��
Y_pre=zeros(datapts,2);
Y_pre(1,1)=flow(1,15,preCrs);
Y_pre(1,2)=flow(1,16,preCrs);

Y_actual=zeros(datapts,2);
Y_actual(:,1)=flow(:,15,preCrs);
Y_actual(:,2)=flow(:,16,preCrs);

%% ����Ԥ��
for i=1:datapts-1
    % ѵ��ǰ14������
    Y=flow(i+1,1:14,preCrs)';
    X=flow(1:i,1:14,preCrs)';
    model=svmtrain(Y,X);
    
    % Ԥ���15������
    X_pre1=flow(1:i,15,preCrs)';
    [Y_pre(i+1,1),~,~]=svmpredict(Y_actual(i+1,1),X_pre1,model);
    
    % Ԥ���16������
    X_pre2=flow(1:i,16,preCrs)';
    [Y_pre(i+1,2),~,~]=svmpredict(Y_actual(i+1,2),X_pre2,model);
    
end

err=abs(Y_pre-Y_actual)./Y_actual;
err_percent=sum(err)/datapts;
fprintf('��5����Ϊ1��ʱ�ν���Ԥ�⣬��%d��·�ڣ���15���Ԥ��ƽ��������%f%%����16���Ԥ��ƽ��������Ϊ%f%%\n',preCrs,100*err_percent(1),100*err_percent(2));

figure,plot(1:1:datapts,Y_actual(:,1),'b');hold on;plot(1:1:datapts,Y_pre(:,1),'r');
legend('ʵ��ֵ','Ԥ��ֵ');title('��5����Ϊ1��ʱ�ν���Ԥ�⣬��15���Ԥ����');xlabel('���ݵ�');ylabel('����ֵ');

figure,plot(1:1:datapts,Y_actual(:,2),'b');hold on;plot(1:1:datapts,Y_pre(:,2),'r');
legend('ʵ��ֵ','Ԥ��ֵ');title('��5����Ϊ1��ʱ�ν���Ԥ�⣬��16���Ԥ����');xlabel('���ݵ�');ylabel('����ֵ');


%% ��10����Ϊ1��ʱ�ν���Ԥ��
flow_ori=flow;
datapts=datapts/2;
flow=zeros(datapts,days,links);
for i=1:datapts
    flow(i,:,:)=flow_ori(2*i-1,:,:)+flow_ori(2*i,:,:);
end

% ���ݳ�ʼ��
Y_pre=zeros(datapts,2);
Y_pre(1,1)=flow(1,15,preCrs);
Y_pre(1,2)=flow(1,16,preCrs);

Y_actual=zeros(datapts,2);
Y_actual(:,1)=flow(:,15,preCrs);
Y_actual(:,2)=flow(:,16,preCrs);

% ����Ԥ��
for i=1:datapts-1
    % ѵ��ǰ14������
    Y=flow(i+1,1:14,preCrs)';
    X=flow(1:i,1:14,preCrs)';
    model=svmtrain(Y,X);
    
    % Ԥ���15������
    X_pre1=flow(1:i,15,preCrs)';
    [Y_pre(i+1,1),~,~]=svmpredict(Y_actual(i+1,1),X_pre1,model);
    
    % Ԥ���16������
    X_pre2=flow(1:i,16,preCrs)';
    [Y_pre(i+1,2),~,~]=svmpredict(Y_actual(i+1,2),X_pre2,model);
    
end

err=abs(Y_pre-Y_actual)./Y_actual;
err_percent=sum(err)/datapts;
fprintf('��10����Ϊ1��ʱ�ν���Ԥ�⣬��%d��·�ڣ���15���Ԥ��ƽ��������%f%%����16���Ԥ��ƽ��������Ϊ%f%%\n',preCrs,100*err_percent(1),100*err_percent(2));

figure,plot(1:1:datapts,Y_actual(:,1),'b');hold on;plot(1:1:datapts,Y_pre(:,1),'r');
legend('ʵ��ֵ','Ԥ��ֵ');title('��10����Ϊ1��ʱ�ν���Ԥ�⣬��15���Ԥ����');xlabel('���ݵ�');ylabel('����ֵ');

figure,plot(1:1:datapts,Y_actual(:,2),'b');hold on;plot(1:1:datapts,Y_pre(:,2),'r');
legend('ʵ��ֵ','Ԥ��ֵ');title('��10����Ϊ1��ʱ�ν���Ԥ�⣬��16���Ԥ����');xlabel('���ݵ�');ylabel('����ֵ');

%% ��15����Ϊ1��ʱ�ν���Ԥ��
datapts=datapts*2/3;
flow=zeros(datapts,days,links);
for i=1:datapts
    flow(i,:,:)=flow_ori(3*i-2,:,:)+flow_ori(3*i-1,:,:)+flow_ori(3*i,:,:);
end

% ���ݳ�ʼ��
Y_pre=zeros(datapts,2);
Y_pre(1,1)=flow(1,15,preCrs);
Y_pre(1,2)=flow(1,16,preCrs);

Y_actual=zeros(datapts,2);
Y_actual(:,1)=flow(:,15,preCrs);
Y_actual(:,2)=flow(:,16,preCrs);

% ����Ԥ��
for i=1:datapts-1
    % ѵ��ǰ14������
    Y=flow(i+1,1:14,preCrs)';
    X=flow(1:i,1:14,preCrs)';
    model=svmtrain(Y,X);
    
    % Ԥ���15������
    X_pre1=flow(1:i,15,preCrs)';
    [Y_pre(i+1,1),~,~]=svmpredict(Y_actual(i+1,1),X_pre1,model);
    
    % Ԥ���16������
    X_pre2=flow(1:i,16,preCrs)';
    [Y_pre(i+1,2),~,~]=svmpredict(Y_actual(i+1,2),X_pre2,model);
    
end

err=abs(Y_pre-Y_actual)./Y_actual;
err_percent=sum(err)/datapts;
fprintf('��15����Ϊ1��ʱ�ν���Ԥ�⣬��%d��·�ڣ���15���Ԥ��ƽ��������%f%%����16���Ԥ��ƽ��������Ϊ%f%%\n',preCrs,100*err_percent(1),100*err_percent(2));

figure,plot(1:1:datapts,Y_actual(:,1),'b');hold on;plot(1:1:datapts,Y_pre(:,1),'r');
legend('ʵ��ֵ','Ԥ��ֵ');title('��15����Ϊ1��ʱ�ν���Ԥ�⣬��15���Ԥ����');xlabel('���ݵ�');ylabel('����ֵ');

figure,plot(1:1:datapts,Y_actual(:,2),'b');hold on;plot(1:1:datapts,Y_pre(:,2),'r');
legend('ʵ��ֵ','Ԥ��ֵ');title('��15����Ϊ1��ʱ�ν���Ԥ�⣬��16���Ԥ����');xlabel('���ݵ�');ylabel('����ֵ');
