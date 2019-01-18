function out_singal = frequency(singal,f1,f2)
%fft�˲�
% ���룺singal��ch*sampling �ľ���  f1~f2 ��ͨƵ��
[ch,sampling,trial]=size(singal);
dft_mat=dftmtx(sampling);
idft_mat=(dft_mat)^-1; 
out_singal=zeros(ch,sampling,trial);
for tr_id=1:trial
       sig= singal(:,:,tr_id);
       f_sig=dft_mat * sig';
       chn=size(f_sig,2);
    %Ƶ��ֽⷶΧ��0~40hz
    sumS=zeros(sampling,chn,41);
    for i=1:41
        if(i==1)
            sumS(:,:,i)=real(idft_mat(:,i)*f_sig(1,:));
        else
            sumS(:,:,i)=2*real(idft_mat(:,i)*f_sig(i,:));
        end
    end
    out_sig=sum(sumS(:,:,f1:f2),3)';
    out_singal(:,:,tr_id)=out_sig;
end

end

