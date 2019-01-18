function score=HDCA_score(w,v,originData,s)
 allnum=size(originData,3);
 samplerate=600;
 w_blocknum=40;
 v_blocknum=40;
 % ȥ���Ļ�
 for i=1:allnum
     avgs=mean(originData(:,:,i),2);
     originData(:,:,i)=originData(:,:,i)-avgs*ones(1,samplerate);
 end
 num=samplerate*1/w_blocknum;       %����ÿһ�ֶζ��ٵ㣬Ҫ����������Ϊ����
 Y_sig=zeros(allnum,samplerate);
%%
for i=1:w_blocknum                 %����ÿ���ֶ�Ȩ�أ�����16�������ݷֶμ�Ȩ��һ���ź���
    blockms=originData(:,num*(i-1)+1:num*i,:);
    for t=1:allnum
        Y_sig(t,num*(i-1)+1:num*i)=(w(:,i)')*blockms(:,:,t);
    end
end
%%
 Y_blomean=zeros(allnum,v_blocknum);
for i=1:allnum
     Y_blomean(i,:)=block_mean(Y_sig(i,:),v_blocknum);
end
Y_blomean=[Y_blomean,s];
% score=Y_blomean*v;   %������Ȥ�÷�
score=glmval(v,Y_blomean,'logit');
end