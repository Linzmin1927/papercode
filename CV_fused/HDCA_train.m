function [w,v]=HDCA_train(originData,originLabel)
 ch=17;
 samplerate=600;
%  for i=1:size(originData,3)
%      avgs=mean(originData(:,:,i),2);
%      originData(:,:,i)=originData(:,:,i)-avgs*ones(1,samplerate);
%  end

 target_id = find(originLabel==2);
 other_id = find(originLabel==1);
 tar_num=length(target_id);
 oth_num=length(other_id);

 target_signal=originData(:,:,target_id);
 other_signal=originData(:,:,other_id);

 w_blocknum=40;                     %�ڼ���wȨ��ʱ�Բ��εķֶ�,����Ϊ1s�����ݷ�Ϊw_blocknum�Σ�ÿ��1000/w_blocknum ms
 w=zeros(ch-1,w_blocknum);
 num=samplerate*1/w_blocknum;          %����ÿһ�ֶζ��ٵ㣬Ҫ����������Ϊ����
 Y_tar_sig=zeros(tar_num,samplerate);
 Y_oth_sig=zeros(oth_num,samplerate);
 %% ��16�����ݽ��зֿ鴦��
tic
 for i=1:w_blocknum                 %����ÿ���ֶ�Ȩ�أ�����16�������ݷֶμ�Ȩ��һ���ź���
    tar_blockms=target_signal(:,num*(i-1)+1:num*i,:);
    tar_blockms=mean(tar_blockms,2);        %16����ƽ������
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
 
 %% ���뱸��
%          tic
%          for i=1:w_blocknum                 %����ÿ���ֶ�Ȩ�أ�����16�������ݷֶμ�Ȩ��һ���ź���
%             tar_blockms=target_signal(:,num*(i-1)+1:num*i,:);
%             tar_reshape=reshape(tar_blockms,ch-1,tar_num*num);
%             oth_blockms=other_signal(:,num*(i-1)+1:num*i,:);
%             oth_reshape=reshape(oth_blockms,ch-1,oth_num*num); 
%             [w(:,i),~]=Fisher(tar_reshape,oth_reshape);
%             for t=1:tar_num
%                 Y_tar_sig(t,num*(i-1)+1:num*i)=(w(:,i)')*tar_blockms(:,:,t);
%             end
%             for t=1:oth_num
%                 Y_oth_sig(t,num*(i-1)+1:num*i)=(w(:,i)')*oth_blockms(:,:,t);
%             end
%          end
 %%
 %% ȡ�ֿ��ƽ��ֵ
  v_blocknum=40;
 Y_tar_blomean=zeros(tar_num,v_blocknum);
 Y_oth_blomean=zeros(oth_num,v_blocknum);

 for i=1:tar_num
     Y_tar_blomean(i,:)=block_mean(Y_tar_sig(i,:),v_blocknum);
 end
 for i=1:oth_num
    Y_oth_blomean(i,:)= block_mean(Y_oth_sig(i,:),v_blocknum);
 end
%  save('BPtrain.mat','Y_tar_blomean','Y_oth_blomean','Y_tar_sig','Y_oth_sig');
 %% ѵ��ʱ��Ȩ��v
%  [v,b]=Fisher(Y_tar_blomean',Y_oth_blomean');
 train_data=[Y_tar_blomean;Y_oth_blomean];
 train_label=[ones(size(Y_tar_blomean,1),1);0*ones(size(Y_oth_blomean,1),1)];
 v=glmfit(train_data,train_label,'binomial','link','logit');

end