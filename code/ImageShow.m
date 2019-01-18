function ImageShow (fname,testlabel,a,acc) 
%row =8;colum=12;
row = ceil(acc(1,2)/12)+1;colum = 12;

% load('long3.mat')
load(fname);
name =cell(1,size(seq)-1);
%for i = 2:(size(seq)-1)
 for i = 1:(size(seq)-1)    
    mark(i) = seq{i}.Mark;
    name{1,i} = seq{i}.FileName;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mark(1) = 0;
% name{1,1}='27M_SP_O.BMP';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[mark_s,d] = sort(mark);
name_s =cell(1,size(d)-1);

for i=1:length(d)
name_s{1,i}=name{1,d(i)};
end


hf=figure('MenuBar','none',...
    'Units','normalized',...
    'Position',[0.1,0.1,0.7,0.5]);
wid=1/colum;
% wid=0.083;
height=1/(row+1);
% left=(1/12-wid)/2;
left=0;
top=0;
count = colum-1;
non_tar = 0;
for i=0:row-2    
    for j=0:count
        if((mod(acc(1,2),colum) ~= 0))
            if(i == 0) 
                if(j > (acc(1,2)-colum*(row-2)))
                    break;
                end
            end
        end
        non_tar = non_tar+1;
       i1=imread(char(name_s(non_tar)));
       if(a(non_tar)==1)
        isize=size(i1);
%       第一圈像素变为红色
        i1(:,1,1)=repmat(255,1,isize(1));
        i1(:,1,2)=ones(1,isize(1));
        i1(:,1,3)=ones(1,isize(1));
        i1(:,isize(2),1)=repmat(255,1,isize(1));
        i1(:,isize(2),2)=ones(1,isize(1));
        i1(:,isize(2),3)=ones(1,isize(1));
        i1(1,:,1)=repmat(255,isize(2),1);
        i1(1,:,2)=ones(isize(2),1);
        i1(1,:,3)=ones(isize(2),1);
        i1(isize(1),:,1)=repmat(255,isize(2),1);
        i1(isize(1),:,2)=ones(isize(2),1);
        i1(isize(1),:,3)=ones(isize(2),1);  
        
%       第二圈像素变为红色
        i1(:,2,1)=repmat(255,1,isize(1));
        i1(:,2,2)=ones(1,isize(1));
        i1(:,2,3)=ones(1,isize(1));
        i1(:,isize(2)-1,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-1,2)=ones(1,isize(1));
        i1(:,isize(2)-1,3)=ones(1,isize(1));
        i1(2,:,1)=repmat(255,isize(2),1);
        i1(2,:,2)=ones(isize(2),1);
        i1(2,:,3)=ones(isize(2),1);
        i1(isize(1)-1,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-1,:,2)=ones(isize(2),1);
        i1(isize(1)-1,:,3)=ones(isize(2),1);  
        
        %       第三圈像素变为红色
        i1(:,3,1)=repmat(255,1,isize(1));
        i1(:,3,2)=ones(1,isize(1));
        i1(:,3,3)=ones(1,isize(1));
        i1(:,isize(2)-2,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-2,2)=ones(1,isize(1));
        i1(:,isize(2)-2,3)=ones(1,isize(1));
        i1(3,:,1)=repmat(255,isize(2),1);
        i1(3,:,2)=ones(isize(2),1);
        i1(3,:,3)=ones(isize(2),1);
        i1(isize(1)-2,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-2,:,2)=ones(isize(2),1);
        i1(isize(1)-2,:,3)=ones(isize(2),1); 
           %       第四圈像素变为红色
        i1(:,4,1)=repmat(255,1,isize(1));
        i1(:,4,2)=ones(1,isize(1));
        i1(:,4,3)=ones(1,isize(1));
        i1(:,isize(2)-3,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-3,2)=ones(1,isize(1));
        i1(:,isize(2)-3,3)=ones(1,isize(1));
        i1(4,:,1)=repmat(255,isize(2),1);
        i1(4,:,2)=ones(isize(2),1);
        i1(4,:,3)=ones(isize(2),1);
        i1(isize(1)-3,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-3,:,2)=ones(isize(2),1);
        i1(isize(1)-3,:,3)=ones(isize(2),1); 
            %       第五圈像素变为红色
        i1(:,5,1)=repmat(255,1,isize(1));
        i1(:,5,2)=ones(1,isize(1));
        i1(:,5,3)=ones(1,isize(1));
        i1(:,isize(2)-4,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-4,2)=ones(1,isize(1));
        i1(:,isize(2)-4,3)=ones(1,isize(1));
        i1(5,:,1)=repmat(255,isize(2),1);
        i1(5,:,2)=ones(isize(2),1);
        i1(5,:,3)=ones(isize(2),1);
        i1(isize(1)-4,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-4,:,2)=ones(isize(2),1);
        i1(isize(1)-4,:,3)=ones(isize(2),1); 
            %       第四圈像素变为红色
        i1(:,6,1)=repmat(255,1,isize(1));
        i1(:,6,2)=ones(1,isize(1));
        i1(:,6,3)=ones(1,isize(1));
        i1(:,isize(2)-5,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-5,2)=ones(1,isize(1));
        i1(:,isize(2)-5,3)=ones(1,isize(1));
        i1(6,:,1)=repmat(255,isize(2),1);
        i1(6,:,2)=ones(isize(2),1);
        i1(6,:,3)=ones(isize(2),1);
        i1(isize(1)-5,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-5,:,2)=ones(isize(2),1);
        i1(isize(1)-5,:,3)=ones(isize(2),1); 
       end
    axes('Position',[left,top,wid,height]); 
    imshow(i1);
    left=1/colum+left;
 
    end
%    left=(1/12-wid)/2;
    left=0;
   top=top+1/(row+1);
end
top=top+1/(row+1)/4;
axes('Position',[0,top,1,0.003],'Visible','off'); 
%axes('Position',[0,top,1,0.003],'Visible','off'); 
text(0.4,0.5,strcat('non-target  images   :',num2str(acc(1,1)),'/',num2str(acc(1,2))),'FontSize',10);
top=top+1/(row+1)/4;

b = find(mark_s>0);

for  m=b(1):b(1)+length(b)-1
%     imread((row-2)*column+1+m);
%     hi=imread(char(name_s((row-2)*column+1+m)));
     try
%         char(name_s((row-1)*colum+1+m))
%     i1=imread(char(name_s((row-1)*colum+1+m)));
%         char(name_s((m)))
       
    i1=imread(char(name_s(m)));
%        if(a((row-2)*colum+1+m)==1)
       if(a(m)==1) 
        isize=size(i1);
%       第一圈像素变为红色
        i1(:,1,1)=repmat(255,1,isize(1));
        i1(:,1,2)=ones(1,isize(1));
        i1(:,1,3)=ones(1,isize(1));
        i1(:,isize(2),1)=repmat(255,1,isize(1));
        i1(:,isize(2),2)=ones(1,isize(1));
        i1(:,isize(2),3)=ones(1,isize(1));
        i1(1,:,1)=repmat(255,isize(2),1);
        i1(1,:,2)=ones(isize(2),1);
        i1(1,:,3)=ones(isize(2),1);
        i1(isize(1),:,1)=repmat(255,isize(2),1);
        i1(isize(1),:,2)=ones(isize(2),1);
        i1(isize(1),:,3)=ones(isize(2),1);  
        
%       第二圈像素变为红色
        i1(:,2,1)=repmat(255,1,isize(1));
        i1(:,2,2)=ones(1,isize(1));
        i1(:,2,3)=ones(1,isize(1));
        i1(:,isize(2)-1,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-1,2)=ones(1,isize(1));
        i1(:,isize(2)-1,3)=ones(1,isize(1));
        i1(2,:,1)=repmat(255,isize(2),1);
        i1(2,:,2)=ones(isize(2),1);
        i1(2,:,3)=ones(isize(2),1);
        i1(isize(1)-1,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-1,:,2)=ones(isize(2),1);
        i1(isize(1)-1,:,3)=ones(isize(2),1);  
        
        %       第三圈像素变为红色
        i1(:,3,1)=repmat(255,1,isize(1));
        i1(:,3,2)=ones(1,isize(1));
        i1(:,3,3)=ones(1,isize(1));
        i1(:,isize(2)-2,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-2,2)=ones(1,isize(1));
        i1(:,isize(2)-2,3)=ones(1,isize(1));
        i1(3,:,1)=repmat(255,isize(2),1);
        i1(3,:,2)=ones(isize(2),1);
        i1(3,:,3)=ones(isize(2),1);
        i1(isize(1)-2,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-2,:,2)=ones(isize(2),1);
        i1(isize(1)-2,:,3)=ones(isize(2),1); 
           %       第四圈像素变为红色
        i1(:,4,1)=repmat(255,1,isize(1));
        i1(:,4,2)=ones(1,isize(1));
        i1(:,4,3)=ones(1,isize(1));
        i1(:,isize(2)-3,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-3,2)=ones(1,isize(1));
        i1(:,isize(2)-3,3)=ones(1,isize(1));
        i1(4,:,1)=repmat(255,isize(2),1);
        i1(4,:,2)=ones(isize(2),1);
        i1(4,:,3)=ones(isize(2),1);
        i1(isize(1)-3,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-3,:,2)=ones(isize(2),1);
        i1(isize(1)-3,:,3)=ones(isize(2),1); 
            %       第五圈像素变为红色
        i1(:,5,1)=repmat(255,1,isize(1));
        i1(:,5,2)=ones(1,isize(1));
        i1(:,5,3)=ones(1,isize(1));
        i1(:,isize(2)-4,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-4,2)=ones(1,isize(1));
        i1(:,isize(2)-4,3)=ones(1,isize(1));
        i1(5,:,1)=repmat(255,isize(2),1);
        i1(5,:,2)=ones(isize(2),1);
        i1(5,:,3)=ones(isize(2),1);
        i1(isize(1)-4,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-4,:,2)=ones(isize(2),1);
        i1(isize(1)-4,:,3)=ones(isize(2),1); 
            %       第四圈像素变为红色
        i1(:,6,1)=repmat(255,1,isize(1));
        i1(:,6,2)=ones(1,isize(1));
        i1(:,6,3)=ones(1,isize(1));
        i1(:,isize(2)-5,1)=repmat(255,1,isize(1));
        i1(:,isize(2)-5,2)=ones(1,isize(1));
        i1(:,isize(2)-5,3)=ones(1,isize(1));
        i1(6,:,1)=repmat(255,isize(2),1);
        i1(6,:,2)=ones(isize(2),1);
        i1(6,:,3)=ones(isize(2),1);
        i1(isize(1)-5,:,1)=repmat(255,isize(2),1);
        i1(isize(1)-5,:,2)=ones(isize(2),1);
        i1(isize(1)-5,:,3)=ones(isize(2),1); 
       end
    axes('Position',[left,top,wid,height]); 
    imshow(i1);
    left=1/colum+left;
     catch 
     end
end
% ht=title('NoTarget'+top);
 top=top+5*1/(row+1)/4;
 axes('Position',[0,top,1,0.003],'Visible','off');
 text(0.4,0.5,strcat('target images   :',num2str(acc(2,1)),'/',num2str(acc(2,2))),'FontSize',10);
% saveas(gcf, ['Classification.png']);
end
