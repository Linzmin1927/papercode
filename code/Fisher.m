function [w,b]=Fisher(traindata1,traindata2)
% fisher������
% traindata1������1������[r*c],rΪ����ά��������������cΪ������
% traindata2������2����
%  y=w'*x
% w��Ȩ��
% b���о�����  b=(w'*u1*n1+w'*u2*n2)/(n1+n2);
% y>b ������1 ����Ϊ����2
u1=mean(traindata1,2);
u2=mean(traindata2,2);

n1=length(traindata1(1,:));
n2=length(traindata2(1,:));

s1=n1*cov(traindata1',1);
s2=n2*cov(traindata2',1);
sw=s1+s2;
sb=(u1-u2)*(u1-u2)';

w=inv(sw)*(u1-u2);

b=(w'*u1*n1+w'*u2*n2)/(n1+n2);
% b=0.5*(w'*u1+w'*u2);
% b=(w'*u1-w'*u2)^2/(w'*sw*w);
end