
clc;
clear;
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
net=load('E:\code_test\5Hz融合模型\imagenet-caffe-ref.mat');
image_inf=cell(96,1);
for i=1:25
    load(fname{i});
    for im_id=1:96
         im=imread(seq{im_id}.FilePath);
         im_ = single(im) ; % note: 255 range 
         im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
         im_ = im_ - net.meta.normalization.averageImage ;  % run the CNN 
         res = vl_simplenn(net, im_) ;
         image_inf{im_id}=res;
         display(['i: ' num2str(i) ' im_id:' num2str(im_id)]);
    end
    save(['image_inf_' num2str(i)],'image_inf','-v7.3')
end

label=name_list.data;
save('featVec.mat','featVec','label');

acc=svmtrain(label,featVec,'-v 5');
model=svmtrain(label,featVec);
rand_id=randperm(size(label,1));
acc=svmpredict(label(rand_id(1:100)),featVec(rand_id(1:100),:),model);
