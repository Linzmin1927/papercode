function block_meandata = block_mean( data,num)
% �ֶ�ƽ������ ��ÿ����֮�������ȡ��ֵ
% data   �����һά����
% num    ƽ����num��
% block_meandata  1*num����������ÿ�εľ�ֵ
len=length(data);
blockspot=len/num;
block_meandata=zeros(1,num);
for i=1:num
    block_meandata(i)=mean(data((i-1)*blockspot+1:i*blockspot));
end
end

