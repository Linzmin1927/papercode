function erp = baseline(sample, offset)
% offset = abs(offset);
% [ch, len] = size(sample);
% avgs = mean(sample(:, 1:offset), 2);
% avgs = repmat(avgs, 1, len);
% erp = sample - avgs;

offset = abs(offset);
[ch1, len1,pag1] = size(sample);
erp=zeros(ch1,len1-offset,pag1);
for i=1:pag1
    avgs=mean(sample(:,1:offset,i),2);
    erp(:,:,i)=sample(:,offset+1:end,i)-avgs*ones(1,len1-offset);
end
end