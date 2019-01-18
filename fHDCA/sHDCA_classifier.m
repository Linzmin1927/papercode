function auc=sHDCA_classifier(name)
warning off
load(name)
w_blocknum=40;
v_blocknum=40;
target_id = find(originLabel==2);
other_id = find(originLabel==1);

%  for i=1:size(originData,3)
%      avgs=mean(originData(:,:,i),2);
%      originData(:,:,i)=originData(:,:,i)-avgs*ones(1,size(originData,2));
%  end


target_signal=originData(:,:,target_id);
other_signal=originData(:,:,other_id);

tar_id = randperm(size(target_signal,3));
oth_id = randperm(size(other_signal,3));

start_id=600*0.3+1;end_id=600*0.8;
[w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal(:,start_id:end_id,:),other_signal(:,start_id:end_id,:));
score_w=sHDCA_train(w,v,target_signal,other_signal);


auc=zeros(5,1);
for i=1:5
    tar_test=tar_id((i-1)*60+1:i*60);
    oth_test=oth_id((i-1)*420+1:i*420);
    tar_tr=setdiff(tar_id,tar_test);
    oth_tr=setdiff(oth_id,oth_test);
    [w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal(:,start_id:end_id,tar_tr),other_signal(:,start_id:end_id,oth_tr));
    score_w=sHDCA_train(w,v,target_signal(:,:,tar_tr),other_signal(:,:,oth_tr));
    [Pd,Pf]=sHDCA_test(w,v,score_w,target_signal(:,:,tar_test),other_signal(:,:,oth_test));
    auc(i)=AUC(Pf,Pd);
    i
end
auc=auc';

end
function [w,v]=HDCA_train(w_blocknum,v_blocknum,target_signal,other_signal)
 ch=17;samplerate=300;
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
 [v,b]=Fisher(Y_tar_blomean',Y_oth_blomean');
 [Pd,Pf]=ROC(Y_tar_blomean*v,Y_oth_blomean*v);
end

function score_w=sHDCA_train(w,v,target_signal,other_signal)
sample=660;
tar_num=size(target_signal,3);
oth_num=size(other_signal,3);
tar_score=zeros(tar_num,sample+1);
oth_score=zeros(oth_num,sample+1);

%% C加速
sc=sHDCA_c(w,v,target_signal);
tar_score=sc';
sc=sHDCA_c(w,v,other_signal);
oth_score=sc';
%% MATLAB实现sHDCA
% for tr=1:tar_num
%     for i=1:960-300+1
%         tar_score(tr,i)=HDCA_c(w,v,target_signal(:,i:i+300-1,tr));
% %         tar_score(tr,i)=HDCA(w,v,target_signal(:,i:i+300-1,tr));
%     end
% end
% for tr=1:oth_num
%     for i=1:960-300+1
%         oth_score(tr,i)=HDCA(w,v,other_signal(:,i:i+300-1,tr));
%     end
% end
%%
tar_score=tar_score(:,1:600,:);
oth_score=oth_score(:,1:600,:);
 Y_tar_blomean=zeros(tar_num,40);
 Y_oth_blomean=zeros(oth_num,40);
%  v_blocknum=10;
 for i=1:tar_num
     Y_tar_blomean(i,:)=block_mean(tar_score(i,:),40);
 end
 for i=1:oth_num
    Y_oth_blomean(i,:)= block_mean(oth_score(i,:),40);
 end
label=[ones(1,tar_num),zeros(1,oth_num)]';
data=[Y_tar_blomean;Y_oth_blomean];
score_w =glmfit(data,label,'binomial', 'link', 'logit');
% p = glmval(b,data, 'logit');
end

function score=HDCA(w,v,signal)
 ch=17;samplerate=300;
 w_blocknum=size(w,2);
 v_blocknum=size(v,1);
 num=samplerate*1/w_blocknum;          %计算每一分段多少点，要求处下来必须为整数
 Y_tar_sig=zeros(1,samplerate);
 %% 对16导数据进行分块处理
tic
 for i=1:w_blocknum                 %计算每个分段权重，并将16导联数据分段加权到一个信号上
    tar_blockms=signal(:,num*(i-1)+1:num*i,:);
        Y_tar_sig(1,num*(i-1)+1:num*i)=(w(:,i)')*tar_blockms;
 end
 %%
 %% 取分块间平均值
 Y_tar_blomean=zeros(1,v_blocknum);
 Y_tar_blomean=block_mean(Y_tar_sig,v_blocknum);
 score=Y_tar_blomean*v;
end

function [Pd,Pf]=sHDCA_test(w,v,score_w,target_signal,other_signal)
    sample=660;
    tar_num=size(target_signal,3);
    oth_num=size(other_signal,3);
    tar_score=zeros(tar_num,sample+1);
    oth_score=zeros(oth_num,sample+1);
    
    sc=sHDCA_c(w,v,target_signal);
    tar_score=sc';
    sc=sHDCA_c(w,v,other_signal);
    oth_score=sc';
    
%     for tr=1:tar_num
%         for i=1:960-300+1
%             tar_score(tr,i)=HDCA_c(w,v,target_signal(:,i:i+300-1,tr));
%         end
%     end
%     for tr=1:oth_num
%         for i=1:960-300+1
%             oth_score(tr,i)=HDCA_c(w,v,other_signal(:,i:i+300-1,tr));
%         end
%     end
    tar_score=tar_score(:,1:600,:);
    oth_score=oth_score(:,1:600,:);
     Y_tar_blomean=zeros(tar_num,40);
     Y_oth_blomean=zeros(oth_num,40);
    %  v_blocknum=10;
     for i=1:tar_num
         Y_tar_blomean(i,:)=block_mean(tar_score(i,:),40);
     end
     for i=1:oth_num
        Y_oth_blomean(i,:)= block_mean(oth_score(i,:),40);
     end
    tar_final_score=glmval(score_w,Y_tar_blomean, 'logit');
    oth_final_score=glmval(score_w,Y_oth_blomean, 'logit');
    [Pd,Pf]=ROC(tar_final_score,oth_final_score);
end
