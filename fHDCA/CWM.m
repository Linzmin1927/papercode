function [latency_dot,latency_time]=CWM(singal,t1,t2)
%% componentwise-model-based approach to model ERP
% 输入:channel*samp的信号矩阵,潜伏期在t1~t2之间
% 输出：latency_dot 潜伏期的采样点数，latency_time所对应的时间，单位ms
% channel = 60;
% samp = 600;
[channel,samp]=size(singal);
G = zeros(1,samp);             % 模版
J = zeros(1,samp);             %误差-代价
II = eye(samp,samp);           %单位矩阵
W = zeros(channel,samp);       %空间权重
X = zeros(channel,samp);       
% Y = zeros(samp,1,trial);
A_sum = zeros(samp,channel);
SF = zeros(1,samp,15);
% amp=zeros(samp,samp,trial);

% plot(G);
%归一化Gamma函数
theta = 7;
k = 3;
c = 1;
for t=1:samp
    G(1,t)=c*t^(k-1)*exp(-t/theta);%templata
end
c=1/max(G);
for t=1:samp
    G(1,t)=c*t^(k-1)*exp(-t/theta);%templata
end
G_max_id=find(G==max(G));
% t1=200;
% t2=600;
start_t=fix(samp*t1/1000);
end_t=fix(samp*t2/1000);
len=end_t-start_t+1;
for t=start_t:end_t
    G_t=zeros(1,samp);  %表示G(t)
    len2=samp-t;
    G_t(t:t+len2)=G(1:len2+1);
    W=inv(singal*singal')*singal*G_t';
    kk=singal'*inv(singal*singal')*singal-II;
    J(t)=(norm(G_t*kk))^2;
end

latency_dot=find(J(start_t:end_t)==min(J(start_t:end_t)))+start_t-1;
latency_dot=latency_dot(1);
latency_time=latency_dot*1000/600;
end
