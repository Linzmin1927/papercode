fname={'cal_0601';'jz_0525';'ljb_0729';'qyl_0725';'wc_0601';'wjy_0525';'wqj_0726';'wxd_0722';'xk_0723';'zwk_0529'};
fname={'cal_0601';'jz_0525';'ljb_0729';'qyl_0725';'wc_0601';'wjy_0525';'wqj_0726';'wxd_0722';'xk_0723';'zwk_0529';'160710_sub';'160710_sz';'161122_gh';'161122_lzk';'161122_wq';'161122_wzy';'161124_ha';'161124_hz';'161124_jcf';'161124_qf'
};
%% 提取cnn中的复杂度信息
lay=21;
complexity=zeros(25*96,1);
for i=1:25
    load(['all_image_inf_cnn\' 'image_inf_' num2str(i),'.mat']);
    for im_id=1:96
        cnn_data=image_inf{im_id};
        cnn_data=cnn_data(lay).x;
        [r,c,p]=size(cnn_data);
        cnn_data=reshape(cnn_data,r*c*p,1);
        complexity((i-1)*96+im_id)=sum(cnn_data.^5);
    end
    display(num2str(i));
end
clear('image_inf');
%% 将看过一副图画的所有被试的信号取均值
train_fname={'1_cal_0601_train_data.mat'
'2_jz_0525_train_data.mat'
'3_ljb_0729_train_data.mat'
'4_qyl_0725_train_data.mat'
'5_wc_0601_train_data.mat'
'6_wjy_0525_train_data.mat'
'7_wqj_0726_train_data.mat'
'8_wxd_0722_train_data.mat'
'9_xk_0723_train_data.mat'
'10_zwk_0529_train_data.mat'
'11_160710_sub_train_data.mat'
'12_160710_sz_train_data.mat'
'13_161122_gh_train_data.mat'
'14_161122_lzk_train_data.mat'
'15_161122_wq_train_data.mat'
'16_161122_wzy_train_data.mat'
'17_161124_ha_train_data.mat'
'18_161124_hz_train_data.mat'
'19_161124_jcf_train_data.mat'
'20_161124_qf_train_data.mat'
};
all_score=[];
all_p=[];
all_originData=zeros(16,960,2400);
for t=1:20
   load(train_fname{t});
   all_originData=all_originData+originData;
   display(num2str(t));
end
all_originData=all_originData/20;
% all_sig=all_originData(4,:,:);
tar_id=find(originLabel==2);
oth_id=find(originLabel==1);
tar_sig=all_originData(4,1:600,tar_id);tar_sig=reshape(tar_sig,600,300)';
oth_sig=all_originData(4,1:600,oth_id);oth_sig=reshape(oth_sig,600,2100)';

for i=1:300
    tar_sig(i,:)=tar_sig(i,:)-mean(tar_sig(i,:));
end
for i=1:2100
    oth_sig(i,:)=oth_sig(i,:)-mean(oth_sig(i,:));
end
figure
clim=[-19,15];x=[1:600]*1000/600;
subplot(2,2,1);imagesc(tar_sig,clim);
subplot(2,2,2);imagesc(oth_sig,clim);
subplot(2,2,3);plot(x,mean(tar_sig,1));
subplot(2,2,4);plot(x,mean(oth_sig,1));


%%
% lay=[1,2,3,5,7,9,15,16,20,22];
lay=[1, 5,9,11,13,16,19,21];
% for lay_id=1:size(lay,2)
 for lay_id=1
    complexity=zeros(25*96,1);
    for i=1:25
        load(['all_image_inf_cnn\' 'image_inf_' num2str(i),'.mat']);
        for im_id=1:96
            cnn_data=image_inf{im_id};
            cnn_data=cnn_data(lay(lay_id)).x;
            [r,c,p]=size(cnn_data);
            cnn_data=reshape(cnn_data,r*c*p,1);
%             complexity((i-1)*96+im_id)= std(cnn_data);%sum(cnn_data.*log2(cnn_data));
            complexity((i-1)*96+im_id)=log2(sum(cnn_data.^2));
        end
        display(['lay: ' num2str(lay_id)  'complexit:' num2str(i)]);
    end
    clear('image_inf');
    complexity_sort=sort(complexity,'descend');
    tar_id_higc=find(complexity(tar_id)>=complexity_sort(800));
    tar_id_midc=find(complexity(tar_id)>=complexity_sort(1600));
    tar_id_midc=setdiff(tar_id_midc,tar_id_higc);
    tar_id_lowc=find(complexity(tar_id)<complexity_sort(1600));

    tar_sig_higc_mean=mean(tar_sig(tar_id_higc,:),1);
    tar_sig_midc_mean=mean(tar_sig(tar_id_midc,:),1);
    tar_sig_lowc_mean=mean(tar_sig(tar_id_lowc,:),1);
    
    oth_id_higc=find(complexity(oth_id)>=complexity_sort(800));
    oth_id_midc=find(complexity(oth_id)>=complexity_sort(1600));
    oth_id_midc=setdiff(oth_id_midc,oth_id_higc);
    oth_id_lowc=find(complexity(oth_id)<complexity_sort(1600));

    oth_sig_higc_mean=mean(oth_sig(oth_id_higc,:),1);
    oth_sig_midc_mean=mean(oth_sig(oth_id_midc,:),1);
    oth_sig_lowc_mean=mean(oth_sig(oth_id_lowc,:),1);   
    
    figure 
    hold on
    plot(tar_sig_higc_mean,'r','linewidth',2);
    plot(tar_sig_midc_mean,'b','linewidth',2);
%      plot(mean(tar_sig(tar_id_lowc(1:75),:),1),'y','linewidth',2);
%      plot(mean(tar_sig(tar_id_lowc(76:end),:),1),'g','linewidth',2);
    plot(tar_sig_lowc_mean,'g','linewidth',2);
    
    figure 
    hold on
    plot(oth_sig_higc_mean,'r','linewidth',2);
    plot(oth_sig_midc_mean,'b','linewidth',2);
    plot(oth_sig_lowc_mean,'g','linewidth',2);
    
    clim=[-30,20];x=[1:600]*(1000/600);
    figure
    subplot(4,2,1);imagesc(x,[1:size(tar_id_higc,1)],tar_sig(tar_id_higc,:),clim);
    subplot(4,2,2);imagesc(x,[1:size(oth_id_higc,1)],oth_sig(oth_id_higc,:),clim);
    subplot(4,2,3);imagesc(x,[1:size(tar_id_midc,1)],tar_sig(tar_id_midc,:),clim);
    subplot(4,2,4);imagesc(x,[1:size(oth_id_midc,1)],oth_sig(oth_id_midc,:),clim);
    subplot(4,2,5);imagesc(x,[1:size(tar_id_lowc,1)],tar_sig(tar_id_lowc,:),clim);
    subplot(4,2,6);imagesc(x,[1:size(oth_id_lowc,1)],oth_sig(oth_id_lowc,:),clim);
    subplot(4,2,7);
    hold on
    plot(x,tar_sig_higc_mean,'r','linewidth',2);
    plot(x,tar_sig_midc_mean,'b','linewidth',2);
    plot(x,tar_sig_lowc_mean,'g','linewidth',2);
    ylim([-3,6]);legend('High IC','Mid IC','Low IC');
    subplot(4,2,8) 
    hold on
    plot(x,oth_sig_higc_mean,'r','linewidth',2);
    plot(x,oth_sig_midc_mean,'b','linewidth',2);
    plot(x,oth_sig_lowc_mean,'g','linewidth',2);   
     ylim([-3,6]);legend('High IC','Mid IC','Low IC');
    
end

tar_id_higc1=tar_id_higc;
tar_id_midc1=tar_id_midc;
tar_id_lowc1=tar_id_lowc;




%% 统计每个人的情况

tim=zeros(10,3);
aff=zeros(10,3);

for t=1:10
   load(train_fname{t});    
   
    tar_sig=originData(4,1:600,tar_id);tar_sig=reshape(tar_sig,600,300)';
    oth_sig=originData(4,1:600,oth_id);oth_sig=reshape(oth_sig,600,2100)';
    for i=1:300
          tar_sig(i,:)=tar_sig(i,:)-mean(tar_sig(i,:));
    end
    for i=1:2100
          oth_sig(i,:)=oth_sig(i,:)-mean(oth_sig(i,:));
    end
    tar_id_higc=find(complexity(tar_id)>=complexity_sort(800));
    tar_id_midc=find(complexity(tar_id)>=complexity_sort(1600));
    tar_id_midc=setdiff(tar_id_midc,tar_id_higc);
    tar_id_lowc=find(complexity(tar_id)<complexity_sort(1600));

    tar_sig_higc_mean=mean(tar_sig(tar_id_higc,:),1);
    tar_sig_midc_mean=mean(tar_sig(tar_id_midc,:),1);
    tar_sig_lowc_mean=mean(tar_sig(tar_id_lowc,:),1);
    
    oth_id_higc=find(complexity(oth_id)>=complexity_sort(800));
    oth_id_midc=find(complexity(oth_id)>=complexity_sort(1600));
    oth_id_midc=setdiff(oth_id_midc,oth_id_higc);
    oth_id_lowc=find(complexity(oth_id)<complexity_sort(1600));

    oth_sig_higc_mean=mean(oth_sig(oth_id_higc,:),1);
    oth_sig_midc_mean=mean(oth_sig(oth_id_midc,:),1);
    oth_sig_lowc_mean=mean(oth_sig(oth_id_lowc,:),1);   
    
    aff(t,1)=max(tar_sig_higc_mean);
    aff(t,2)=max(tar_sig_midc_mean);
    aff(t,3)=max(tar_sig_lowc_mean);
    
    cc=find(tar_sig_higc_mean==aff(t,1));
    tim(t,1)=cc(1)*1000/600;
    cc=find(tar_sig_midc_mean==aff(t,2));
    tim(t,2)=cc(1)*1000/600;
     cc=find(tar_sig_lowc_mean==aff(t,3));
    tim(t,3)=cc(1)*1000/600;
    
    
    clim=[-30,30];x=[1:600]*(1000/600);
    figure
    subplot(4,2,1);imagesc(x,[1:size(tar_id_higc,1)],tar_sig(tar_id_higc,:),clim);
    subplot(4,2,2);imagesc(x,[1:size(oth_id_higc,1)],oth_sig(oth_id_higc,:),clim);
    subplot(4,2,3);imagesc(x,[1:size(tar_id_midc,1)],tar_sig(tar_id_midc,:),clim);
    subplot(4,2,4);imagesc(x,[1:size(oth_id_midc,1)],oth_sig(oth_id_midc,:),clim);
    subplot(4,2,5);imagesc(x,[1:size(tar_id_lowc,1)],tar_sig(tar_id_lowc,:),clim);
    subplot(4,2,6);imagesc(x,[1:size(oth_id_lowc,1)],oth_sig(oth_id_lowc,:),clim);
    subplot(4,2,7);
    hold on
    plot(x,tar_sig_higc_mean,'r','linewidth',2);
    plot(x,tar_sig_midc_mean,'b','linewidth',2);
    plot(x,tar_sig_lowc_mean,'g','linewidth',2);
    ylim([-4.5,6]);
    subplot(4,2,8) 
    hold on
    plot(x,oth_sig_higc_mean,'r','linewidth',2);
    plot(x,oth_sig_midc_mean,'b','linewidth',2);
    plot(x,oth_sig_lowc_mean,'g','linewidth',2);   
     ylim([-4.5,6]);
      display(num2str(t));
end

[h,p1]=ttest(aff(:,1),aff(:,2))
[h,p2]=ttest(aff(:,2),aff(:,3))
[h,p3]=ttest(aff(:,1),aff(:,3))

%% 将不同复杂度的图片显示出来
fname={
'序列1_盆栽.mat'
'序列2_风扇.mat'
'序列3_斑点狗.mat'
'序列4_加菲猫.mat'
'序列5_新娘.mat'
'序列6_人脸.mat'
'序列7_女人.mat'
'序列8_花朵.mat'
'序列9_笔.mat'
'序列10_水墨鸟.mat'
'序列11_绿叶.mat'
'序列12_插花.mat'
'序列16_鹰.mat'
'序列17_企鹅.mat'
'序列18_虎.mat'
'序列19_大象.mat'
'序列20_熊.mat'
'序列21_玫瑰.mat'
'序列22_猫.mat'
'序列23_飞机.mat'
'序列24_小孩.mat'
'序列25_蛇.mat'
'序列26_手.mat'
'序列27_贝壳.mat'
'序列28_乐器.mat'
};

tar_complexit=complexity(tar_id);
tar_complexit=tar_complexit-min(tar_complexit);
tar_complexit=tar_complexit/max(tar_complexit);
tar_complexit=reshape(tar_complexit,12,25);
label_l=reshape(originLabel,96,25);
for tt=1:25
    load([ 'E:\图像检索序列库_0424\mat_5Hz\' fname{tt}]);
    tar_im=find(label_l(:,tt)==2);
    tar_cp=tar_complexit(:,tt);
    [xx,sort_id]=sort(tar_cp,'descend');
    tar_im_sort=tar_im(sort_id);
    for ii=1:12
       im= seq{tar_im_sort(ii)}.FilePath;
       imm=imread(im);
       imwrite(imm,['E:\code_test\5Hz融合模型\all_im_sort\' num2str(tt) '_' num2str(ii) '.jpg']);
    end
end

%% 开始根据图像复杂程度将图像集分为两个部分，并在最后融合得分。


train_fname={'1_cal_0601_train_data.mat'
'2_jz_0525_train_data.mat'
'3_ljb_0729_train_data.mat'
'4_qyl_0725_train_data.mat'
'5_wc_0601_train_data.mat'
'6_wjy_0525_train_data.mat'
'7_wqj_0726_train_data.mat'
'8_wxd_0722_train_data.mat'
'9_xk_0723_train_data.mat'
'10_zwk_0529_train_data.mat'
'11_160710_sub_train_data.mat'
'12_160710_sz_train_data.mat'
'13_161122_gh_train_data.mat'
'14_161122_lzk_train_data.mat'
'15_161122_wq_train_data.mat'
'16_161122_wzy_train_data.mat'
'17_161124_ha_train_data.mat'
'18_161124_hz_train_data.mat'
'19_161124_jcf_train_data.mat'
'20_161124_qf_train_data.mat'
};
acc=zeros(10,5);
acc_fused=zeros(10,5);
for t=1:10
   load(train_fname{t});    
   tar_id=find(originLabel==2);
   oth_id=find(originLabel==1);

    tar_sig=originData(:,1:600,tar_id);
    oth_sig=originData(:,1:600,oth_id);
% 正常HDCA五折交叉验证

    tar_all_id=randperm(300);
    tar_all_id=reshape(tar_all_id,5,60);
    oth_all_id=randperm(2100);
    oth_all_id=reshape(oth_all_id,5,420);
    tar_complexity=complexity(tar_id);
    oth_complexity=complexity(oth_id);
    for test_id=1:5
        tar_test_id=tar_all_id(test_id,:)';
        tar_train_id=setdiff(tar_all_id,tar_test_id);
        oth_test_id=oth_all_id(test_id,:)';
        oth_train_id=setdiff(oth_all_id,oth_test_id);
        train_data=tar_sig(:,:,tar_train_id);
        train_data(:,:,end+1:end+size(oth_train_id,1))=oth_sig(:,:,oth_train_id);
        train_label=[2*ones(size(tar_train_id,1),1);1*ones(size(oth_train_id,1),1)];
        [w,v]=HDCA_train(train_data,train_label);
        %测试
        test_data=tar_sig(:,:,tar_test_id);
        test_data(:,:,end+1:end+size(oth_test_id,1))=oth_sig(:,:,oth_test_id);
        test_label=[2*ones(size(tar_test_id,1),1);1*ones(size(oth_test_id,1),1)];        
        score_h=HDCA_score(w,v,test_data);
        [Pd,Pf]=ROC(score_h(1:size(tar_test_id,1)),score_h(size(tar_test_id,1)+1:end));
%         figure
%         plot(Pf,Pd);
        acc(t,test_id)=AUC(Pf,Pd);  
        % fused
        complexity_sort_tar=sort(complexity(tar_id),'descend');
 
        tar_test_id=tar_all_id(test_id,:)';
        tar_train_id=setdiff(tar_all_id,tar_test_id);
        oth_test_id=oth_all_id(test_id,:)';
        oth_train_id=setdiff(oth_all_id,oth_test_id);
        
%         tar_complexity_test=tar_complexity(tar_test_id);
%         oth_complexity_test=oth_complexity(oth_test_id);
        tar_complexity_train=tar_complexity(tar_train_id);
        oth_complexity_train=oth_complexity(oth_train_id);
        complexity_th1=200;
        complexity_th11_5=50;complexity_th11_6=250;
        complexity_th2=100;
        %高可信度训练集
        higc_tar_complexity_train_id=find(tar_complexity_train>=complexity_sort_tar(complexity_th1));
        higc_oth_complexity_train_id=find(oth_complexity_train>=complexity_sort_tar(complexity_th1));  
        %中可信度训练集
        midc_tar_complexity_train_id=find(tar_complexity_train>=complexity_sort_tar(complexity_th11_6));
        midc_tar_complexity_train_id=setdiff(midc_tar_complexity_train_id,find(tar_complexity_train>=complexity_sort_tar(complexity_th11_5)));
        midc_oth_complexity_train_id=find(oth_complexity_train>=complexity_sort_tar(complexity_th11_6));     
        midc_oth_complexity_train_id=setdiff(midc_oth_complexity_train_id,find(oth_complexity_train>=complexity_sort_tar(complexity_th11_5)));
        
        %低可信度训练集
        lowc_tar_complexity_train_id=find(tar_complexity_train<complexity_sort_tar(complexity_th1));
        lowc_oth_complexity_train_id=find(oth_complexity_train<complexity_sort_tar(complexity_th1));  
        %训练高可信度分类器
        tar_train_sig_id=tar_train_id(higc_tar_complexity_train_id);
        oth_train_sig_id=oth_train_id(higc_oth_complexity_train_id);        
           %训练
        train_data=tar_sig(:,:,tar_train_sig_id);
        train_data(:,:,end+1:end+size(oth_train_sig_id,1))=oth_sig(:,:,oth_train_sig_id);
        train_label=[2*ones(size(tar_train_sig_id,1),1);1*ones(size(oth_train_sig_id,1),1)];
        [w_higc,v_higc]=HDCA_train(train_data,train_label);
          %训练中可信度分类器
        tar_train_sig_id=tar_train_id(midc_tar_complexity_train_id);
        oth_train_sig_id=oth_train_id(midc_oth_complexity_train_id);        
           %训练
        train_data=tar_sig(:,:,tar_train_sig_id);
        train_data(:,:,end+1:end+size(oth_train_sig_id,1))=oth_sig(:,:,oth_train_sig_id);
        train_label=[2*ones(size(tar_train_sig_id,1),1);1*ones(size(oth_train_sig_id,1),1)];
        [w_midc,v_midc]=HDCA_train(train_data,train_label);
        %训练低可信度分类器
        tar_train_sig_id=tar_train_id(lowc_tar_complexity_train_id);
        oth_train_sig_id=oth_train_id(lowc_oth_complexity_train_id);        
           %训练
        train_data=tar_sig(:,:,tar_train_sig_id);
        train_data(:,:,end+1:end+size(oth_train_sig_id,1))=oth_sig(:,:,oth_train_sig_id);
        train_label=[2*ones(size(tar_train_sig_id,1),1);1*ones(size(oth_train_sig_id,1),1)];
        [w_lowc,v_lowc]=HDCA_train(train_data,train_label);        
        
       % 再将训练好的模型用在整个训练样本上，得到一个可以结合两个得分值的分类器
        train_data=tar_sig(:,:,tar_train_id);
        train_data(:,:,end+1:end+size(oth_train_id,1))=oth_sig(:,:,oth_train_id);
        train_label=[2*ones(size(tar_train_id,1),1);1*ones(size(oth_train_id,1),1)];
        score_higc=HDCA_score(w_higc,v_higc,train_data);
        score_midc=HDCA_score(w_midc,v_midc,train_data);
        score_lowc=HDCA_score(w_lowc,v_lowc,train_data);
        score_h=HDCA_score(w,v,train_data);
        train_data=[score_higc,score_midc,score_lowc,score_h];
        all_v=glmfit(train_data,train_label-1,'binomial','link','logit');
        % 测试
        test_data=tar_sig(:,:,tar_test_id);
        test_data(:,:,end+1:end+size(oth_test_id,1))=oth_sig(:,:,oth_test_id);
        test_label=[2*ones(size(tar_test_id,1),1);1*ones(size(oth_test_id,1),1)]; 
        score_higc=HDCA_score(w_higc,v_higc,test_data);
        score_midc=HDCA_score(w_midc,v_midc,test_data);
        score_lowc=HDCA_score(w_lowc,v_lowc,test_data);
        score_h=HDCA_score(w,v,test_data);

        train_data=[score_higc,score_midc,score_lowc,score_h];
        final_score=glmval(all_v,train_data,'logit');
%         final_score=mean(train_data(:,2),2)
        [Pd,Pf]=ROC(final_score(1:size(tar_test_id,1)),final_score(size(tar_test_id,1)+1:end));
%         figure
%         plot(Pf,Pd);
        acc_fused(t,test_id)=AUC(Pf,Pd); 
%         figure;hold on
%         plot(score_higc(size(tar_test_id,1)+1:end),score_lowc(size(tar_test_id,1)+1:end),'b*'); 
%         plot(score_higc(1:size(tar_test_id,1)),score_lowc(1:size(tar_test_id,1)),'r*','linewidth',2);
            
        
    end
acc_mean=mean(acc(t,:),2);
acc_fused_mean=mean(acc_fused(t,:),2);     
display([num2str(t) '  acc_mean:',num2str(acc_mean), ' acc_fused_mean:',num2str(acc_fused_mean) ]);
end
acc_mean=mean(mean(acc,2),1);
acc_fused_mean=mean(mean(acc_fused,2),1);
display(['acc_mean:',num2str(acc_mean), ' acc_fused_mean:',num2str(acc_fused_mean) ]);


















