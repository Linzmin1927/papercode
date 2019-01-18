function flodingHDCA_classifier_2(name)
str1=[name,'_originData_2400_600Hz.mat'];
str2=[name,'.mat'];
load(str1);

w_blocknum=40;
v_blocknum=40;
target_id = find(originlabel==2);
other_id = find(originlabel==1);
target_signal=originData(:,:,target_id);
other_signal=originData(:,:,other_id);

tar_id = randperm(size(target_signal,3));
oth_id = randperm(size(other_signal,3));
auc=zeros(5,1);
all_auc=zeros(5,40);
for flod=1:40
   for i=1:5
        tar_test=tar_id((i-1)*60+1:i*60);
        oth_test=oth_id((i-1)*420+1:i*420);
        tar_tr=setdiff(tar_id,tar_test);
        oth_tr=setdiff(oth_id,oth_test);
        [w,v]=HDCA_train(flod,w_blocknum,v_blocknum,target_signal(:,:,tar_tr),other_signal(:,:,oth_tr));
        [Pd,Pf,~,~]=HDCA_test(flod,w,v,target_signal(:,:,tar_test),other_signal(:,:,oth_test));
%         auc(i)=AUC(Pf,Pd);
        str=[' i:', num2str(i), ' auc:', num2str(auc(i))];
        display(str);
        all_auc(i,flod)=AUC(Pf,Pd);
   end
   
end
save(str2,'all_auc');
end

function [w,v]=HDCA_train(c_n,w_blocknum,v_blocknum,target_signal,other_signal)
 ch=17;samplerate=600;
 w=zeros(ch-1,w_blocknum);
 num=samplerate*1/w_blocknum;          %计算每一分段多少点，要求处下来必须为整数
 tar_num=size(target_signal,3);
 oth_num=size(other_signal,3);
 Y_tar_sig=zeros(tar_num,samplerate);
 Y_oth_sig=zeros(oth_num,samplerate);
 %% 对16导数据进行分块处理
%  c_n=18;  %卷积数
 w=zeros((ch-1)*c_n,w_blocknum);
 num=samplerate*1/w_blocknum;          %计算每一分段多少点，要求处下来必须为整数
 Y_tar_sig=zeros(tar_num,samplerate);
 Y_oth_sig=zeros(oth_num,samplerate);
 %% 对16导数据进行分块处理
tic
 
 for i=1:w_blocknum                 %计算每个分段权重，并将16导联数据分段加权到一个信号上
    front_tar_blockms=zeros(ch-1,c_n,tar_num); 
    front_oth_blockms=zeros(ch-1,c_n,oth_num); 
    for front_num=1:c_n
        if(i-front_num>=0)
            tar_blockms=target_signal(:,num*((i-front_num+1)-1)+1:num*(i-front_num+1),:);
            tar_blockms=mean(tar_blockms,2);        %16导块平均部分 
            front_tar_blockms(:,front_num,:)=tar_blockms;
            
            oth_blockms=other_signal(:,num*((i-front_num+1)-1)+1:num*(i-front_num+1),:);
            oth_blockms=mean(oth_blockms,2);
            front_oth_blockms(:,front_num,:)=oth_blockms;
        end
    end

    if(i-c_n<=0)
        tar_reshape=reshape(front_tar_blockms(:,1:i,:),(ch-1)*i,tar_num); 
        oth_reshape=reshape(front_oth_blockms(:,1:i,:),(ch-1)*i,oth_num); 
    else
        tar_reshape=reshape(front_tar_blockms,(ch-1)*c_n,tar_num); 
        oth_reshape=reshape(front_oth_blockms,(ch-1)*c_n,oth_num); 
    end
    
    [dw,~]=Fisher(tar_reshape,oth_reshape);
    w(1:length(dw),i)=dw;
    for t=1:tar_num
        Y_tar_sig(t,num*(i-1)+1:num*i)=(w(1:length(dw),i)')*tar_reshape(:,t);
    end
    for t=1:oth_num
        Y_oth_sig(t,num*(i-1)+1:num*i)=(w(1:length(dw),i)')*oth_reshape(:,t);
    end
 end
 
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
end

function [Pd,Pf,Y_sig_tar,Y_sig_oth]=HDCA_test(c_n,w,v,target_signal,other_signal)
 ch=17;samplerate=600;
 w_blocknum=size(w,2);
 v_blocknum=size(v,1);
 num=samplerate*1/w_blocknum;          %计算每一分段多少点，要求处下来必须为整数
 tar_num=size(target_signal,3);
 oth_num=size(other_signal,3);

  num=samplerate*1/w_blocknum;       %计算每一分段多少点，要求处下来必须为整数
 Y_sig_tar=zeros(tar_num,samplerate);
 Y_sig_oth=zeros(oth_num,samplerate);

%   c_n=18;
%%
for i=1:w_blocknum                 %计算每个分段权重，并将16导联数据分段加权到一个信号上
    front_blockms_tar=zeros(ch-1,c_n,tar_num); 
    front_blockms_oth=zeros(ch-1,c_n,oth_num); 
   for front_num=1:c_n
        if(i-front_num>=0)
            blockms_tar=target_signal(:,num*((i-front_num+1)-1)+1:num*(i-front_num+1),:);
            blockms_oth=other_signal(:,num*((i-front_num+1)-1)+1:num*(i-front_num+1),:);
            blockms_tar=mean(blockms_tar,2);        %16导块平均部分 
            blockms_oth=mean(blockms_oth,2);        %16导块平均部分 

            front_blockms_tar(:,front_num,:)=blockms_tar;
            front_blockms_oth(:,front_num,:)=blockms_oth;

        end
    end

    if(i-c_n<=0)
        tar_reshape=reshape(front_blockms_tar(:,1:i,:),(ch-1)*i,tar_num); 
        oth_reshape=reshape(front_blockms_oth(:,1:i,:),(ch-1)*i,oth_num); 

    else
        tar_reshape=reshape(front_blockms_tar,(ch-1)*c_n,tar_num); 
        oth_reshape=reshape(front_blockms_oth,(ch-1)*c_n,oth_num); 
    end
    
    for t=1:tar_num
        Y_sig_tar(t,num*(i-1)+1:num*i)=(w(1:length(find(w(:,i)~=0)),i)')*tar_reshape(:,t);
    end
    for t=1:oth_num
        Y_sig_oth(t,num*(i-1)+1:num*i)=(w(1:length(find(w(:,i)~=0)),i)')*oth_reshape(:,t);
    end
end
 %%
 %% 取分块间平均值
 v_blocknum=40;
 Y_tar_blomean=zeros(tar_num,v_blocknum);
 Y_oth_blomean=zeros(oth_num,v_blocknum);
%  Y_tar_blomean=zeros(tar_num,40);
%  Y_oth_blomean=zeros(oth_num,40);
%  v_blocknum=10;
 for i=1:tar_num
     Y_tar_blomean(i,:)=block_mean(Y_sig_tar(i,:),v_blocknum);
 end
 for i=1:oth_num
    Y_oth_blomean(i,:)= block_mean(Y_sig_oth(i,:),v_blocknum);
 end
%  save('BPtrain.mat','Y_tar_blomean','Y_oth_blomean','Y_tar_sig','Y_oth_sig');
%  [Pd,Pf]=ROC(Y_tar_blomean*v,Y_oth_blomean*v);
 tar_final_score=glmval(v,Y_tar_blomean, 'logit');
 oth_final_score=glmval(v,Y_oth_blomean, 'logit');
 [Pd,Pf]=ROC(tar_final_score,oth_final_score);
end
