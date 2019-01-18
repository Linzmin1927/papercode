function conf = Conf(score,k )
%CONF Confidence函数
%   此处显示详细说明
score_max=max(score);
score_min=min(score);
conf=zeros(size(score,1),1);
tar_id=find(score>k);
oth_id=find(score<=k);
conf(tar_id)=(score(tar_id)-k)./(score_max-k);
conf(oth_id)=(score(oth_id)-k)./(score_min-k);
end

