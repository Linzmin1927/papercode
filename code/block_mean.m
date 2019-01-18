function block_meandata = block_mean( data,num)
% 分段平均函数 将每个段之间的数据取均值
% data   输入的一维数据
% num    平均分num段
% block_meandata  1*num向量，返回每段的均值
len=length(data);
blockspot=len/num;
block_meandata=zeros(1,num);
for i=1:num
    block_meandata(i)=mean(data((i-1)*blockspot+1:i*blockspot));
end
end

