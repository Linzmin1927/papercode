function [Pd Pf]=ROC( Y_taris,Y_othis)
amin=min(min(Y_othis));
amax=max(max(Y_othis));
middata=(amax-amin)/1e5;
x=[amin:middata:amax];   %x 表示阈值选择范围
Pd=zeros(1,length(x));
Pf=zeros(1,length(x));
for i=1:length(x)
   Pd(i)=length(find((Y_taris>x(i))==1))/length(Y_taris);
   Pf(i)=length(find((Y_othis>x(i))==1))/length(Y_othis);
end

x_min=min(min([Y_taris;Y_othis]));
x_max=max(max([Y_taris;Y_othis]));
len=50;
x_t=(x_max-x_min)/len;
tar_p=zeros(len,1);
oth_p=zeros(len,1);
xx=[x_min:x_t:x_max];
for i=2:size(xx,2)
    set1=find(Y_taris>xx(i-1));
    set2=find(Y_taris<=xx(i));
    set3=intersect(set1,set2);
    tar_p(i-1)=size(set3,1)/size(Y_taris,1);
    
    set1=find(Y_othis>xx(i-1));
    set2=find(Y_othis<=xx(i));
    set3=intersect(set1,set2);
    oth_p(i-1)=size(set3,1)/size(Y_othis,1);   
    
end
% figure
% hold on
% bar(xx(2:end),oth_p,'b')
% bar(xx(2:end),tar_p,'r')

% figure
% plot(Pf,Pd)
% for i=1:length(x)
%    dt(i)=Pd(i)/Pf(i) ;
% end
%   b=x(find(dt==max(dt)));
end

