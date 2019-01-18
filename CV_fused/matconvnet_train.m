
clc;
clear;
fname={
'����1_����.mat'
'����2_����.mat'
'����3_�ߵ㹷.mat'
'����4_�ӷ�è.mat'
'����5_����.mat'
'����6_����.mat'
'����7_Ů��.mat'
'����8_����.mat'
'����9_��.mat'
'����10_ˮī��.mat'
'����11_��Ҷ.mat'
'����12_�廨.mat'
'����16_ӥ.mat'
'����17_���.mat'
'����18_��.mat'
'����19_����.mat'
'����20_��.mat'
'����21_õ��.mat'
'����22_è.mat'
'����23_�ɻ�.mat'
'����24_С��.mat'
'����25_��.mat'
'����26_��.mat'
'����27_����.mat'
'����28_����.mat'
};
net=load('E:\code_test\5Hz�ں�ģ��\imagenet-caffe-ref.mat');
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
