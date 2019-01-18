%% 潜伏期估计
clc
clear
load('6_wjy_0525_train_data.mat')
target_id = find(originLabel==2);
other_id = find(originLabel==1);
tar_num=length(target_id);
oth_num=length(other_id);
target_signal=originData(:,1:600,target_id);
other_signal=originData(:,1:600,other_id);
clear('originData')
[ch,sampling,trial]=size(target_signal);
 for i=1:trial
     avgs=mean(target_signal(:,:,i),2);
     target_signal(:,:,i)=target_signal(:,:,i)-avgs*ones(1,sampling);
 end
% [Cml,Sml]=SIM(target_signal,3);
target_signal2 = frequency(target_signal,1,12);

latency=zeros(trial,1);
latency_dot=zeros(trial,1);
t1=300;
t2=750;
for tr_id=1:trial
    [latency_dot(tr_id),latency(tr_id)]=CWM(target_signal(:,1:600,tr_id),t1,t2);
    latency(tr_id)
    tr_id
end


latency_lock_signal=zeros(ch,sampling*2,trial);
for i=1:trial
    id=latency_dot(i);
    len1=sampling-id;
    latency_lock_signal(:,sampling,i)=target_signal(:,id,i);
    latency_lock_signal(:,sampling-id+1:sampling-1,i)=target_signal(:,1:id-1,i);
    latency_lock_signal(:,sampling+1:sampling+len1,i)=target_signal(:,id+1:end,i);
end

Pz_singal=zeros(trial,sampling*2);
Pz_singal_O=zeros(trial,sampling);
for i=1:trial
    Pz_singal(i,:)=latency_lock_signal(2,:,i);
    Pz_singal_O(i,:)=target_signal(2,:,i);
end
Pz_singal=Pz_singal(:,301:900);

figure
subplot(2,2,1);clims = [ -60 40 ];imagesc([1:600]*1000/600,1:2700,Pz_singal_O,clims);
subplot(2,2,2);clims = [ -60 40 ];imagesc([-299:300]*1000/600,1:2700,Pz_singal,clims);
subplot(2,2,3);plot([1:600]*1000/600,mean(Pz_singal_O,1),'linewidth',2); ylim([-5,10]);grid on;
subplot(2,2,4);plot([-299:300]*1000/600,mean(Pz_singal,1),'linewidth',2); ylim([-5,10]); grid on;
% 
% figure
% hold on;
% plot([1:sampling]*1000/sampling,mean(target_signal(2,:,:),3))
% plot([1:sampling]*1000/sampling,target_signal2(4,:,200))
% for
% 
% 
% 
% for i=1:16
%    figure
%    plot(target_signal(i,:,232))
% end
% figure
% for i=1:25
%     figure
%    plot(mean(target_signal2(2,:,(i-1)*12+1:i*12),3)) 
% end

tim=[1:600]*1000/600;
figure
hold on;
i=13-2;
plot(tim,mean(target_signal2(2,:,(i-1)*12+1:i*12),3),'linewidth',2)
i=17-2;
plot(tim,mean(target_signal2(2,:,(i-1)*12+1:i*12),3),'r','linewidth',2)
i=18-2;
plot(tim,mean(target_signal2(2,:,(i-1)*12+1:i*12),3),'magenta','linewidth',2)
legend('block 10','block 15','block 16');



%% 估计10名被试最大最小潜伏期
name={'1_cal_0601_train_data.mat';'2_jz_0525_train_data.mat';'3_ljb_0729_train_data.mat';'4_qyl_0725_train_data.mat';'5_wc_0601_train_data.mat';'6_wjy_0525_train_data.mat';'7_wqj_0726_train_data.mat';'8_wxd_0722_train_data.mat';'9_xk_0723_train_data.mat';'10_zwk_0529_train_data.mat';'12_160710_sz_train_data.mat';'13_161122_gh_train_data.mat';'14_161122_lzk_train_data.mat';'15_161122_wq_train_data.mat';'16_161122_wzy_train_data.mat';'17_161124_ha_train_data.mat';'18_161124_hz_train_data.mat';'19_161124_jcf_train_data.mat';'20_161124_qf_train_data.mat'}
larency_mat=zeros(9,25);
ii=1;
for i=11:19
    load(name{i})
    target_id = find(originLabel==2);
    other_id = find(originLabel==1);
    tar_num=length(target_id);
    oth_num=length(other_id);
    target_signal=originData(:,1:600,target_id);
    clear('originData')
    t1=300;
    t2=750;
    [ch,sampling,trial]=size(target_signal);
     for t=1:25
         avgs=mean(target_signal(:,:,(t-1)*12+1:t*12),3);
         [~,larency_mat(ii,t)]= CWM(avgs,t1,t2);
     end
    % [Cml,Sml]=SIM(target_signal,3);


    for tr_id=1:trial
        [latency_dot(tr_id),latency(tr_id)]=CWM(target_signal(:,1:600,tr_id),t1,t2);
        latency(tr_id)
        tr_id
    end

end








