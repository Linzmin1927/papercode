function [samples, labels, offset, datalen] = SplitIntoSamples(data, sample_rate, offset, datalen, needSave, filename)
%% 将data分为samples和labels
% sample_rate : 采样率
% offset：期望一个samples的起点，以trigger的偏移，毫秒数
% length：期望一个sample的长度，毫秒数
% T：实际实验中一个sample的长度
% needSave，需要保存在mat中吗？
% 保存的格式就是 samples [N*ch*length]  &  labels(N*1)
% 注意如果用matlab的gUSBamp采集的信号，data需要乘以1e6。
if nargin < 5
    needSave = 0;
end

[ch, ~] = size(data);
newlabel = ChangeLabel(data(ch,:), 48);%将可以理解为对阶跃求了个导数，只有变化的时刻保留下来
stDot = find(newlabel ~= 0);
sampleN = length(stDot);
offset = round(Time2Dot(sample_rate, offset));% 将t毫秒转换成点数
datalen = round(Time2Dot(sample_rate, datalen));
samples = zeros( ch-1, datalen,sampleN);

labels = newlabel(stDot);   %将图片开始呈现时的位置和对应的标提取出来
for i = 1 : sampleN  %将一个样本数据从原始数据中抽取出来
    st = stDot(i);
    samples(:,:,i) =reshape( data(1:ch-1,st+offset:st+offset+datalen-1), ch-1, datalen,1);
end

% labels = reshape(labels, sampleN, 1);%%这是将行向量转置为列向量？？？？怎么不用labels'
labels=labels';
if needSave == 1
    save(filename, 'samples', 'labels', 'offset', 'datalen', 'sample_rate');
end

end

% Test Code
% [samples, labels] = SplitIntoSamples(data, 256, -200, 800, 1, 'a.mat');
