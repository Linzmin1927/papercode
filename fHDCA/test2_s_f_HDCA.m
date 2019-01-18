
name={'1_cal_0601_train_data.mat';'2_jz_0525_train_data.mat';'3_ljb_0729_train_data.mat';'4_qyl_0725_train_data.mat';'5_wc_0601_train_data.mat';'6_wjy_0525_train_data.mat';'7_wqj_0726_train_data.mat';'8_wxd_0722_train_data.mat';'9_xk_0723_train_data.mat';'10_zwk_0529_train_data.mat';'12_160710_sz_train_data.mat';'13_161122_gh_train_data.mat';'14_161122_lzk_train_data.mat';'15_161122_wq_train_data.mat';'16_161122_wzy_train_data.mat';'17_161124_ha_train_data.mat';'18_161124_hz_train_data.mat';'19_161124_jcf_train_data.mat';'20_161124_qf_train_data.mat'}
auc=zeros(19,5);
for i=1:19
   auc(i,:)= HDCA_classifier(name{i});
   display(['HDCA:' num2str(i)]);
end

acc_fhdca=zeros(19,5);
for i=1:19
    acc_fhdca(i,:)=fHDCA_classifier(name{i});
    display(['fHDCA:' num2str(i)]);
end

acc_shdca=zeros(19,5);
for i=1:19
    acc_shdca(i,:)=sHDCA_classifier(name{i});
    display(['sHDCA:' num2str(i)]);
end
%%
all_sub=zeros(9,4);
all_time_hdca=zeros(9,5);
all_time_fhdca=zeros(9,5);
all_time_shdca=zeros(9,5);
for i=1:9
   str1=['SNR_HDCA_',name{i},'.mat'];
   load(str1);
   snr_orn=zeros(60,5);
   snr_HDCA=zeros(60,5);
   snr_sHDCA=zeros(60,5);
   snr_fHDCA=zeros(60,5);
   for t=1:5
%        snr_orn(:,t)=SNR(SNR_Data{t,3},0);
%        snr_HDCA(:,t)=SNR(SNR_Data{t,1},1);
%        snr_orn(:,t)=SNR2(SNR_Data{t,3},SNR_Data{t,4});
%        snr_HDCA(:,t)=SNR2(SNR_Data{t,1},SNR_Data{t,2});
%        snr_orn(:,t)=SNR3(SNR_Data{t,3},SNR_Data{t,4});
%        snr_HDCA(:,t)=SNR3(SNR_Data{t,1},SNR_Data{t,2});
%        snr_orn(:,t)=SNR4(SNR_Data{t,3});
%        snr_HDCA(:,t)=SNR4(SNR_Data{t,1});
       snr_orn(:,t)=SNR5(SNR_Data{t,3},SNR_Data{t,4});
       snr_HDCA(:,t)=SNR5(SNR_Data{t,1},SNR_Data{t,2});
       all_time_hdca(i,t)=SNR_Data{t,5}
   end
   str2=['SNR_sHDCA',name{i},'.mat'];
   load(str2);
   for t=1:5
%        snr_sHDCA(:,t)=SNR(SNR_data{t,1},2);
%        snr_sHDCA(:,t)=SNR2(SNR_data{t,1},SNR_data{t,2});
%        snr_sHDCA(:,t)=SNR3(SNR_data{t,1},SNR_data{t,2});
%         snr_sHDCA(:,t)=SNR4(SNR_data{t,1});
       snr_sHDCA(:,t)=SNR5(SNR_data{t,1},SNR_data{t,2});
       all_time_shdca(i,t)=SNR_data{t,5};
   end
   str3=['SNR_fHDCA_',name{i},'.mat'];
   load(str3);
   for t=1:5
%        snr_fHDCA(:,t)=SNR(SNR_Data{t,1},3);
%        snr_fHDCA(:,t)=SNR2(SNR_Data{t,1},SNR_Data{t,2});
%        snr_fHDCA(:,t)=SNR3(SNR_Data{t,1},SNR_Data{t,2});
%         snr_fHDCA(:,t)=SNR4(SNR_Data{t,1});
       snr_fHDCA(:,t)=SNR5(SNR_Data{t,1},SNR_Data{t,2});
       all_time_fhdca(i,t)=SNR_Data{t,5};
   end
   all_sub(i,1)=mean(mean(snr_orn));
   all_sub(i,2)=mean(mean(snr_HDCA));
   all_sub(i,3)=mean(mean(snr_sHDCA));
   all_sub(i,4)=mean(mean(snr_fHDCA));
end
mean(all_sub)
all_data=cell(9,4);
for i = 1:9
   str1=['SNR_HDCA_',name{i},'.mat'];
   load(str1);
   data_tar=[];
   data_oth=[];
   for t=1:5
       snr_raw=reshape(SNR_Data{t,3}(4,:,:),600,60)';
       data_tar=[data_tar;snr_raw];
       snr_raw=reshape(SNR_Data{t,4}(4,:,:),600,420)';
       data_oth=[data_oth;snr_raw];
   end
   all_data{i,1}.tar=data_tar(1:end,:);
   all_data{i,1}.oth=data_oth(1:end,:);
   
   data_tar=[];
   data_oth=[];
   for t=1:5
       snr_raw=SNR_Data{t,1};
       data_tar=[data_tar;snr_raw];
       snr_raw=SNR_Data{t,2};
       data_oth=[data_oth;snr_raw];
   end
   all_data{i,2}.tar=data_tar(1:end,:);
   all_data{i,2}.oth=data_oth(1:end,:);
   
   
   str2=['SNR_sHDCA',name{i},'.mat'];
   load(str2);
   data_tar=[];
   data_oth=[];
   for t=1:5
       snr_raw=SNR_data{t,1};
       data_tar=[data_tar;snr_raw];
       snr_raw=SNR_data{t,2};
       data_oth=[data_oth;snr_raw];
   end
   all_data{i,3}.tar=data_tar(1:end,:);
   all_data{i,3}.oth=data_oth(1:end,:);
   
   str3=['SNR_fHDCA_',name{i},'.mat'];
   load(str3);
   data_tar=[];
   data_oth=[];
   for t=1:5
       snr_raw=SNR_Data{t,1};
       data_tar=[data_tar;snr_raw];
       snr_raw=SNR_Data{t,2};
       data_oth=[data_oth;snr_raw];
   end
   all_data{i,4}.tar=data_tar(1:end,:);
   all_data{i,4}.oth=data_oth(1:end,:); 
end
all_across=cell(1,4);
for i=1:9
    all_across{1}=[all_across{1};all_data{i,1}.tar];
    all_across{2}=[all_across{2};all_data{i,2}.tar];
    all_across{3}=[all_across{3};all_data{i,3}.tar];
    all_across{4}=[all_across{4};all_data{i,4}.tar];
end
all_across2=zeros(4,600);
all_across2(1,:)=mean(all_across{1},1);
all_across2(2,:)=mean(all_across{2},1);
all_across2(3,:)=mean(all_across{3},1);
all_across2(4,:)=mean(all_across{4},1);
figure
plot(all_across2(1,:));
figure
plot(all_across2(2,:));
figure
plot(all_across2(3,:));
figure
plot(all_across2(4,:));



x_time=[1:600]*1000/600;
y_1=[1:300];
y_2=[1:2100];

for i=1:9
    figure
    subplot(4,4,1);imagesc(x_time,y_1,all_data{i,1}.tar);
    subplot(4,4,2);imagesc(x_time,y_2,all_data{i,1}.oth);
    subplot(4,4,5);plot(x_time,mean(all_data{i,1}.tar));
    subplot(4,4,6);plot(x_time,mean(all_data{i,1}.oth));
    
    subplot(4,4,3);imagesc(x_time,y_1,all_data{i,2}.tar);
    subplot(4,4,4);imagesc(x_time,y_2,all_data{i,2}.oth);
    subplot(4,4,7);plot(x_time,mean(all_data{i,2}.tar));
    subplot(4,4,8);plot(x_time,mean(all_data{i,2}.oth));
    
    subplot(4,4,9);imagesc(x_time,y_1,all_data{i,3}.tar);
    subplot(4,4,10);imagesc(x_time,y_2,all_data{i,3}.oth);
    subplot(4,4,13);plot(x_time,mean(all_data{i,3}.tar));
    subplot(4,4,14);plot(x_time,mean(all_data{i,3}.oth));
    
    subplot(4,4,11);imagesc(x_time,y_1,all_data{i,4}.tar);
    subplot(4,4,12);imagesc(x_time,y_2,all_data{i,4}.oth);
    subplot(4,4,15);plot(x_time,mean(all_data{i,4}.tar));
    subplot(4,4,16);plot(x_time,mean(all_data{i,4}.oth));  
end

figure
grid on;
clims=[-40,40];
subplot(2,2,1);imagesc(x_time,y_1,all_data{1,1}.tar,clims);
subplot(2,2,2);imagesc(x_time,y_2,all_data{1,1}.oth,clims);
subplot(2,2,3);plot(x_time,mean(all_data{1,1}.tar));ylim([-10,10]);grid on;
subplot(2,2,4);plot(x_time,mean(all_data{1,1}.oth));ylim([-10,10]);grid on;

figure
grid on;
clims=[-0.0014,0.0021];
subplot(2,2,1);imagesc(x_time,y_1,all_data{1,2}.tar,clims);
subplot(2,2,2);imagesc(x_time,y_2,all_data{1,2}.oth,clims);
subplot(2,2,3);plot(x_time,mean(all_data{1,2}.tar));ylim([-0.0002,0.0003]);grid on;
subplot(2,2,4);plot(x_time,mean(all_data{1,2}.oth));ylim([-0.0002,0.0003]);grid on;

figure
grid on;
clims=[-0.0034,0.0025];
subplot(2,2,1);imagesc(x_time,y_1,all_data{1,3}.tar,clims);
subplot(2,2,2);imagesc(x_time,y_2,all_data{1,3}.oth,clims);
subplot(2,2,3);plot(x_time,mean(all_data{1,3}.tar));ylim([-0.0003,0.0005]);grid on;
subplot(2,2,4);plot(x_time,mean(all_data{1,3}.oth));ylim([-0.0003,0.0005]);grid on;

figure
grid on;
clims=[-0.0034,0.0025];
subplot(2,2,1);imagesc(x_time,y_1,all_data{1,4}.tar,clims);
subplot(2,2,2);imagesc(x_time,y_2,all_data{1,4}.oth,clims);
subplot(2,2,3);plot(x_time,mean(all_data{1,4}.tar));ylim([-0.0003,0.0005]);grid on;
subplot(2,2,4);plot(x_time,mean(all_data{1,4}.oth));ylim([-0.0003,0.0005]);grid on;


figure
hold on
load('xkROC_HDCA.mat');
plot(Pf,Pd,'r','linewidth',2)
load('xkROC_sHDCA.mat');
plot(Pf,Pd,'g','linewidth',2)
load('xkROC_fHDCA.mat');
plot(Pf,Pd,'p','linewidth',2)
grid on
legend('HDCA ROC','sHDCA ROC','fHDCA ROC')
clc
clear
name={'zwk'	'xk' 'wxd'	'wqj'	'wjy'	'wc'	'qyl'	'jz'	'cal'};
all_tar=cell(19,1);
for i=1:19
%   str1=[name{i},'_originData_2400_600Hz.mat'];
  str1=name{i}
  load(str1);
  target_id = find(originLabel==2);
  other_id = find(originLabel==1);
  all_tar{i}=originData(:,:,target_id);
  i
end
clear originData
all_tar_mult=cell(19,1)
for i=1:19
    tar_25=zeros(16,600,25);
    for j=1:25
        tar_25(:,:,j)=mean(all_tar{i}(:,1:600,(j-1)*12+1:j*12),3);
    end
    all_tar_mult{i}=tar_25;
end
tar_25=zeros(16,600,25);
for i=1:13
    xx=zeros(16,600,25);
    for j=1:25
         avgs=mean(all_tar_mult{i}(:,:,j),2);
%         xx(:,:,j)=all_tar_mult{i}(:,:,j)-avgs*ones(1,600);
        xx(:,:,j)=all_tar_mult{i}(:,:,j);
    end
    tar_25=tar_25+xx;
    
end
tar_25=tar_25./13;
% for i=1:25
%     figure
%     plot(tar_25(4,:,i),'linewidth',2);
% end
x_time=[1:600]*1000/600;
% figure
% for i=1:25
%     subplot(5,5,i)
%     plot(x_time,tar_25(4,:,i),'linewidth',2);title(['target ' num2str(i)]);
% end
latency=zeros(25,1);
latency_dot=zeros(25,1);
for i=1:25
    latency_dot(i)=find(tar_25(4,:,i)==max(tar_25(4,:,i)));
    latency(i)=latency_dot(i)*(1000/600);
end
% figure
% for i=1:25
%    subplot(5,5,i)
%    yy=tar_25(:,latency_dot(i),i);
%    topoplotEEG(yy,'16channel.txt','electrodes','on', 'maplimits',[-10,10], 'style', 'straight');
% %    title(['target ' num2str(i)]);
% end
figure
x=0.02;
y=0.78;
for r=1:5
   for c=1:5
       subplot('Position',[x y 0.18 0.18]);
       yy=tar_25(:,latency_dot((r-1)*5+c),(r-1)*5+c);
       topoplotEEG(yy,'16channel.txt','electrodes','on', 'maplimits',[-8,8], 'style', 'straight');
       y=y-0.2;
   end
   x=x+0.18;
   y=0.78;
end
yy=[1:1:16];


%求每个被试每个目标的潜伏期分布；
tar_25=zeros(25,600,9);
for i=1:9
    xx=zeros(16,600,25);
    for j=1:25
        avgs=mean(all_tar_mult{i}(:,:,j),2);
        xx(:,:,j)=all_tar_mult{i}(:,:,j)-avgs*ones(1,600);
%         xx(:,:,j)=all_tar_mult{i}(:,:,j);
        tar_25(j,:,i)=xx(4,:,j);
    end
end
latency_dot=zeros(9,25);
for i=1:9
    for j=1:25
        latency_dot(i,j)=find(tar_25(j,:,i)==max(tar_25(j,200:450,i)));
    end
end

latency_time=latency_dot.*(1000/600);
all_latency_time=reshape(latency_time,1,25*9);
figure
hist(all_latency_time,23)

latency_time=floor(latency_time)
all_st=zeros(9,4);
all_st(:,1)=min(latency_time,[],2);
all_st(:,2)=max(latency_time,[],2)
all_st(:,3)=mean(latency_time,2)
all_st(:,4)=all_st(:,2)-all_st(:,1)




all_average=all_average./9;
str1=[name{1},'_originData_2400_600Hz.mat'];
load(str1);
target_id = find(originlabel==2);
other_id = find(originlabel==1);
target_signal=all_average(:,:,target_id);
other_signal=all_average(:,:,other_id);
tar_sin_ave=zeros(16,600,25);
for i=1:25
    target_signal(:,:,i)=mean(target_signal(:,:,(i-1)*12+1:i*12),3);
end
for i=1:25
    figure
    plot(target_signal(4,:,i),'linewidth',2);
end

