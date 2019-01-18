function [samples, labels, offset, datalen] = SplitIntoSamples(data, sample_rate, offset, datalen, needSave, filename)
%% ��data��Ϊsamples��labels
% sample_rate : ������
% offset������һ��samples����㣬��trigger��ƫ�ƣ�������
% length������һ��sample�ĳ��ȣ�������
% T��ʵ��ʵ����һ��sample�ĳ���
% needSave����Ҫ������mat����
% ����ĸ�ʽ���� samples [N*ch*length]  &  labels(N*1)
% ע�������matlab��gUSBamp�ɼ����źţ�data��Ҫ����1e6��
if nargin < 5
    needSave = 0;
end

[ch, ~] = size(data);
newlabel = ChangeLabel(data(ch,:), 48);%���������Ϊ�Խ�Ծ���˸�������ֻ�б仯��ʱ�̱�������
stDot = find(newlabel ~= 0);
sampleN = length(stDot);
offset = round(Time2Dot(sample_rate, offset));% ��t����ת���ɵ���
datalen = round(Time2Dot(sample_rate, datalen));
samples = zeros( ch-1, datalen,sampleN);

labels = newlabel(stDot);   %��ͼƬ��ʼ����ʱ��λ�úͶ�Ӧ�ı���ȡ����
for i = 1 : sampleN  %��һ���������ݴ�ԭʼ�����г�ȡ����
    st = stDot(i);
    samples(:,:,i) =reshape( data(1:ch-1,st+offset:st+offset+datalen-1), ch-1, datalen,1);
end

% labels = reshape(labels, sampleN, 1);%%���ǽ�������ת��Ϊ����������������ô����labels'
labels=labels';
if needSave == 1
    save(filename, 'samples', 'labels', 'offset', 'datalen', 'sample_rate');
end

end

% Test Code
% [samples, labels] = SplitIntoSamples(data, 256, -200, 800, 1, 'a.mat');
