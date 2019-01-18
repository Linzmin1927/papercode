function auc=HDCA_classifier(name)
str1=[name];
str2=['SNR_HDCA_',name,'.mat'];

load(str1);
w_blocknum=40;
v_blocknum=40;
target_id = find(originLabel==2);
other_id = find(originLabel==1);

%  for i=1:size(originData,3)
%      avgs=mean(originData(:,:,i),2);
%      originData(:,:,i)=originData(:,:,i)-avgs*ones(1,size(originData,2));
%  end

target_signal=originData(:,1:600,target_id);%取1s数据
other_signal=originData(:,1:600,other_id);

% tar_id = randperm(size(target_signal,3));
% oth_id = randperm(size(other_signal,3));
% tar_id=[1:size(target_signal,3)];
% oth_id=[1:size(other_signal,3)];
tar_id = randperm(size(target_signal,3));
oth_id = randperm(size(other_signal,3));
[w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal(:,:,tar_id(1:150)),other_signal(:,:,oth_id(1:1050)));
train_time = toc;
[Pd,Pf,Y_tar_sig,Y_oth_sig]=HDCA_test(w,v,target_signal(:,:,tar_id(151:end)),other_signal(:,:,oth_id(1051:end)));
%save([name 'ROC_HDCA.mat'],'Pd','Pf')

auc=zeros(5,5);
tim=zeros(5,1);
% [w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal,other_signal);

auc=zeros(5,1);
SNR_Data=cell(5,5);

for i=1:5
    tar_test=tar_id((i-1)*60+1:i*60);
    oth_test=oth_id((i-1)*420+1:i*420);
    tar_tr=setdiff(tar_id,tar_test);
    oth_tr=setdiff(oth_id,oth_test);
    tic
    [w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal(:,:,tar_tr),other_signal(:,:,oth_tr));
    train_time = toc;
    [Pd,Pf,Y_tar_sig,Y_oth_sig]=HDCA_test(w,v,target_signal(:,:,tar_test),other_signal(:,:,oth_test));
%     SNR_Data{i,1}=Y_tar_sig;
%     SNR_Data{i,2}=Y_oth_sig;
%     SNR_Data{i,3}=target_signal(:,:,tar_test);
%     SNR_Data{i,4}=other_signal(:,:,oth_test);
%     SNR_Data{i,5}=train_time;
    auc(i)=AUC(Pf,Pd);
    str=[' i:', num2str(i), ' auc:', num2str(auc(i))];
    display(str);
end
auc=auc';
% save(str2,'SNR_Data');
% j=1;
% for(j=1:5)
%     tar_train_id=tar_id((j-1)*60+1:j*60);
%     oth_train_id=oth_id((j-1)*420+1:j*420);
%     [w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal(:,:,tar_train_id),other_signal(:,:,oth_train_id));
%     tic
%     for(i=1:5)
%         tar_test_id=tar_id((i-1)*60+1:i*60);
%         oth_test_id=oth_id((i-1)*420+1:i*420);
%         [Pd,Pf]=HDCA_test(w,v,target_signal(:,:,tar_test_id),other_signal(:,:,oth_test_id));
%         auc(j,i)=AUC(Pf,Pd);
%         str=['j:',num2str(j) ,' i:', num2str(i), ' auc:', num2str(auc(j,i))];
%         display(str);
%     end
%     tim(j)=toc;
% end
% auc
% xx=[auc(:,1);auc(:,2);auc(:,3);auc(:,4);auc(:,5)]
% tim
end

function [w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal,other_signal)
 ch=17;samplerate=600;
 w=zeros(ch-1,w_blocknum);
 num=samplerate*1/w_blocknum;          %计算每一分段多少点，要求处下来必须为整数
 tar_num=size(target_signal,3);
 oth_num=size(other_signal,3);
 Y_tar_sig=zeros(tar_num,samplerate);
 Y_oth_sig=zeros(oth_num,samplerate);
 
 
 %% 对16导数据进行分块处理
tic
 for i=1:w_blocknum                 %计算每个分段权重，并将16导联数据分段加权到一个信号上
    tar_blockms=target_signal(:,num*(i-1)+1:num*i,:);
    tar_blockms=mean(tar_blockms,2);        %16导块平均部分
    tar_reshape=reshape(tar_blockms,ch-1,tar_num);
    oth_blockms=other_signal(:,num*(i-1)+1:num*i,:);
    oth_blockms=mean(oth_blockms,2);
    oth_reshape=reshape(oth_blockms,ch-1,oth_num); 
    [w(:,i),~]=Fisher(tar_reshape,oth_reshape);
    for t=1:tar_num
        Y_tar_sig(t,num*(i-1)+1:num*i)=(w(:,i)')*tar_blockms(:,:,t);
    end
    for t=1:oth_num
        Y_oth_sig(t,num*(i-1)+1:num*i)=(w(:,i)')*oth_blockms(:,:,t);
    end
 end
 

 %%
 %% 取分块间平均值
 Y_tar_blomean=zeros(tar_num,v_blocknum);
 Y_oth_blomean=zeros(oth_num,v_blocknum);
%  v_blocknum=10;
 for i=1:tar_num
     Y_tar_blomean(i,:)=block_mean(Y_tar_sig(i,:),v_blocknum);
 end
 for i=1:oth_num
    Y_oth_blomean(i,:)= block_mean(Y_oth_sig(i,:),v_blocknum);
 end
%  save('BPtrain.mat','Y_tar_blomean','Y_oth_blomean','Y_tar_sig','Y_oth_sig');
 %% 训练时间权重v
%  [v,b]=Fisher(Y_tar_blomean',Y_oth_blomean');
 label=[ones(1,tar_num),zeros(1,oth_num)]';
data=[Y_tar_blomean;Y_oth_blomean];
v =glmfit(data,label,'binomial', 'link', 'logit');
%  [Pd,Pf]=ROC(Y_tar_blomean*v,Y_oth_blomean*v);
%  figure
%  plot(Pf,Pd)
%  figure
%  subplot(2,2,1),imagesc(Y_tar_sig);
%  subplot(2,2,2),imagesc(Y_oth_sig);
%  subplot(2,2,3),plot([1:600]*1000/600,mean(Y_tar_sig));
%  subplot(2,2,4),plot([1:600]*1000/600,mean(Y_oth_sig));
%  
end

function [Pd,Pf,Y_tar_sig,Y_oth_sig]=HDCA_test(w,v,target_signal,other_signal)
 ch=17;samplerate=600;
 w_blocknum=size(w,2);
 v_blocknum=size(v,1);
 num=samplerate*1/w_blocknum;          %计算每一分段多少点，要求处下来必须为整数
 tar_num=size(target_signal,3);
 oth_num=size(other_signal,3);
 Y_tar_sig=zeros(tar_num,samplerate);
 Y_oth_sig=zeros(oth_num,samplerate);
 for i=1:w_blocknum                 %计算每个分段权重，并将16导联数据分段加权到一个信号上
    tar_blockms=target_signal(:,num*(i-1)+1:num*i,:);
    oth_blockms=other_signal(:,num*(i-1)+1:num*i,:);
    for t=1:tar_num
        Y_tar_sig(t,num*(i-1)+1:num*i)=(w(:,i)')*tar_blockms(:,:,t);
    end
    for t=1:oth_num
        Y_oth_sig(t,num*(i-1)+1:num*i)=(w(:,i)')*oth_blockms(:,:,t);
    end
 end
 
 %%
 %% 取分块间平均值
 v_blocknum=40;
 Y_tar_blomean=zeros(tar_num,v_blocknum);
 Y_oth_blomean=zeros(oth_num,v_blocknum);
%  v_blocknum=10;
 for i=1:tar_num
     Y_tar_blomean(i,:)=block_mean(Y_tar_sig(i,:),v_blocknum);
 end
 for i=1:oth_num
    Y_oth_blomean(i,:)= block_mean(Y_oth_sig(i,:),v_blocknum);
 end
%  save('BPtrain.mat','Y_tar_blomean','Y_oth_blomean','Y_tar_sig','Y_oth_sig');
%  [Pd,Pf]=ROC(Y_tar_blomean*v,Y_oth_blomean*v);
  tar_final_score=glmval(v,Y_tar_blomean, 'logit');
 oth_final_score=glmval(v,Y_oth_blomean, 'logit');
 [Pd,Pf]=ROC(tar_final_score,oth_final_score);
end
