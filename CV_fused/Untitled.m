fname=dir;
fname={'cal_0601';'jz_0525';'ljb_0729';'qyl_0725';'wc_0601';'wjy_0525';'wqj_0726';'wxd_0722';'xk_0723';'zwk_0529';'161120_zjy';'161120_zsf';'161122_gh';'161122_lzk';'161122_wq';'161122_wzy';'161124_ha';'161124_hz';'161124_jcf';'161124_qf'
};
%% 提取训练数据
for fid=1:10
    str=[fname{fid} '\01_熊猫\train.bin'];
    ch=17;samplerate=600;
    data1= dyaddown(dyaddown(ReadDataFromBinFile(str, ch)));
    data1 = data1 * 1e6;
    d = fdesign.bandpass('N,F3dB1,F3dB2',10,0.1,60,600);  % Bandpass filter for the ECG
    Hd = design(d,'butter');
    for i=1:16
     data1(i,:)=filter(Hd,data1(i,:));
    end
    [sample1, labels, offset, datalen] = SplitIntoSamples(data1, samplerate, -200, 1800);

    samples = baseline(sample1,offset);%减去未刺激时的初始状态
    %  clear data;
    label_id=find(labels==15);

    originData=zeros(ch-1,samplerate*1.6,size(label_id,1));
    originLabel=zeros(size(label_id,1),1);
    for i=1:size(label_id,1)
     originData(:,:,(i-1)*96+1:i*96)=samples(:,:,label_id(i)+1:label_id(i)+96);
     originLabel((i-1)*96+1:i*96)=labels(label_id(i)+1:label_id(i)+96);
    end
    save([num2str(fid) '_' fname{fid} '_train_data.mat'],'originData','originLabel');
end
%% 提取测试数据
for fid=1:10
    str1=[fname{fid} '\01_熊猫\test.bin'];
    str2=[fname{fid} '\02_baby\test.bin'];
    str3=[fname{fid} '\03_手势\test.bin'];
    ch=17;samplerate=600;
    data1= dyaddown(dyaddown(ReadDataFromBinFile(str1, ch)));
    [originData1 ,originLabel1] = data( data1 );
    data2= dyaddown(dyaddown(ReadDataFromBinFile(str2, ch)));
    [originData2 ,originLabel2] = data( data2 ) ;
    data3= dyaddown(dyaddown(ReadDataFromBinFile(str3, ch)));
    [originData3 ,originLabel3] = data( data3 );
    
    originData=originData1;
    originData(:,:,end+1:end+96)=originData2;
    originData(:,:,end+1:end+96)=originData3;
    originLabel=originLabel1;
    originLabel(end+1:end+96)=originLabel2;
    originLabel(end+1:end+96)=originLabel3;
    
    save([num2str(fid) '_' fname{fid} '_test_data.mat'],'originData','originLabel');
end
%% sHDCA算法测试
auc=zeros(10,1)
origin_score=zeros(288,10);
originLabel=zeros(288,10);
for fid=1:10
    str_test=[num2str(fid) '_' fname{fid} '_test_data.mat'];
    str_train=[num2str(fid) '_' fname{fid} '_train_data.mat'];
    [auc(fid),origin_score(:,fid),originLabel(:,fid)]=sHDCA_classifier(str_train,str_test);
    display(['sub: ' num2str(fid) ' AUC: ' num2str(auc(fid))]);
end

%% 读取图片路径
image_path=dir;
image_path=cell(10,1);
for fid=1:10
    str1=[fname{fid} '\01_熊猫\'];
    str2=[fname{fid} '\02_baby\'];
    str3=[fname{fid} '\03_手势\'];
    name=cell(96*3,1);
    for im=1:96
        name{im}=[str1 image_name{im}];
        name{96+im}=[str2 image_name{im}];
        name{96*2+im}=[str3 image_name{im}];
    end
    image_path{fid}=name
end
%% 使用caffe进行分类
caffe.set_mode_gpu();
gpu_id = 0;  % we will use the first gpu in this demo
caffe.set_device(gpu_id);
model_dir = 'E:\lin_codetest\caffe-windows-master\models\bvlc_reference_caffenet\';
net_model = [model_dir 'deploy.prototxt'];
net_weights = [model_dir 'bvlc_reference_caffenet.caffemodel'];
phase = 'test'; % run with phase test (so that dropout isn't applied)
net = caffe.Net(net_model, net_weights, phase);
p_caffe=zeros(228,1000);
label_caffe=zeros(228,1);
for id=1:288
    im=imread(name{id});
    input_data = {prepare_image(im)};
    scores = net.forward(input_data);
    scores = scores{1};
    scores = mean(scores, 2);
    p_caffe(id,:)=scores;
   [~,label_caffe(id)] = max(scores);
   display(num2str(id))
end
caffe.reset_all();
save('cnn_rsult.mat','p_caffe','label_caffe')
%% 将脑电评分转换为置信度

origin_score_block=zeros(96,3,10);
for i=1:10
    for block=1:3
        origin_score_block(:,block,i)=origin_score((block-1)*96+1:block*96,i);
    end
end
k_score=zeros(10,3);
confid_vul=zeros(96,3,10);
for i=1:10
    for block=1:3
        origin_score_sort=sort(origin_score_block(:,block,i),'descend');
        k_score(i,block)=origin_score_sort(15);
        score=origin_score_block(:,block,i);
        confid_vul(:,block,i) = Conf(score,k_score(i,block));
    end
end

%% 将confid_vul值最低的25%定为低可信试次
low_trial_num=0.25;
confidence_trial_id=zeros(96*(1-low_trial_num),3,10);
low_confid_trial_id=zeros(96*low_trial_num,3,10);
for i=1:10
    for block=1:3
        [sort_confid_vul,sort_trial]=sort(confid_vul(:,block,i),'ascend');
        confidence_trial_id(:,block,i)=sort_trial(96*low_trial_num+1:end);
        low_confid_trial_id(:,block,i)=sort_trial(1:96*low_trial_num);
    end
end
%%
label_caffe_block=zeros(96,3);

for block=1:3
    label_caffe_block(:,block)=label_caffe((block-1)*96+1:block*96)
end


for i=1:10
    for block =1:3
        confidence_eeg_label=origin_score_block(confidence_trial_id(:,block,i),block,i);
        caffe_label=label_caffe_block(confidence_trial_id(:,block,i),block);
        eeg_label_0_1=(confidence_eeg_label>k_score(i,block));
        xx=find(eeg_label_0_1==1);
        xx2=xx-1;xx2(find(xx2<1))=1;
        xx3=xx+1;xx3(find(xx3>96))=96;
        eeg_label_0_1(xx2)=1;
        eeg_label_0_1(xx3)=1;
        caffe_label_P=caffe_label.*eeg_label_0_1;
        caffe_label_P_not0=caffe_label_P(find(caffe_label_P~=0));
        [m,n]=hist(caffe_label_P_not0,unique(caffe_label_P_not0));
        max_id=find(m==max(m));
        cnn_targetclass=n(max_id);
        
        low_confidence_eeg_label=origin_score_block(low_confid_trial_id(:,block,i),block,i);
        low_caffe_label=label_caffe_block(low_confid_trial_id(:,block,i),block);
    end
end
i=1;

confidence_trial_eegscore=origin_score(confidence_trial_id(:,i),i);
confidence_trial_label=originLabel(confidence_trial_id(:,i),i);
confidence_caffe_label=label_caffe(confidence_trial_id(:,i));

confidence_trial_target_id=find(confidence_trial_eegscore>0.06);
caffe_tar_label=confidence_caffe_label(confidence_trial_target_id);

%% 单纯分类HDCA

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
}
for i=1:10
    load(train_fname{i})
    label_tar_id=find(originLabel==2);
    label_oth_id=find(originLabel==1);
    sig_tar_0=originData(:,:,label_tar_id);
    sig_oth_0=originData(:,:,label_oth_id);
    sig_tar=mean(originData(:,:,label_tar_id),3);
    sig_oth=mean(originData(:,:,label_oth_id),3);

    figure
    
end


