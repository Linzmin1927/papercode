function [out_singal] = frequency(singal,f1,f2)
%fft¬À≤®
[ch,sampling,trial]=size(singal);
dft_mat=dftmtx(sampling);
idft_mat=(dft_mat)^-1; 
n=length(sig);
out_singal=zeros(ch,sampling,trial);
for tr_id=1:trial
    for ch_id=1:ch
       singal= singal(ch_id,:,tr_id);
       f_sig=dft_mat * singal'
       chn=size(f_sig,1);
    %∆µ”Ú∑÷Ω‚∑∂Œß «0~40hz
    sumS=zeros(41,sampling,chn);
    for i=1:41
        if(i==1)
            sumS(i,:,:)=real(idft_mat(:,i)*S1(i,:));
        else
            sumS(i,:,:)=2*real(idft_mat(:,i)*S1(i,:));
        end
    end
    end
end

S1 = dft_mat * sig';
chn=size(sig,1);
%∆µ”Ú∑÷Ω‚∑∂Œß «0~40hz
sumS=zeros(41,samplerate,chn);
for i=1:41
    if(i==1)
        sumS(i,:,:)=real(idft_mat(:,i)*S1(i,:));
    else
        sumS(i,:,:)=2*real(idft_mat(:,i)*S1(i,:));
    end
end

% f_num=20;
num=40/f_num;
Y_fre=zeros(f_num,samplerate,chn);
for i=1:f_num
    if (i==1)
        Y_fre(i,:,:) = sum(sumS(1:num+1,:,:));
    else
        Y_fre(i,:,:) = sum(sumS((i-1)*num+2:i*num+1,:,:),1);
    end
end


end

