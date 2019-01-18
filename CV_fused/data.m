function [ originData ,originLabel] = data( data1 )
    ch=17;samplerate=600;
    data1 = data1 * 1e6;
    d = fdesign.bandpass('N,F3dB1,F3dB2',10,0.1,60,600);  % Bandpass filter for the ECG
    Hd = design(d,'butter');
    for i=1:16
     data1(i,:)=filter(Hd,data1(i,:));
    end
    [sample1, labels, offset, datalen] = SplitIntoSamples(data1, samplerate, -200, 1800);

    samples = baseline(sample1,offset);%¼õÈ¥Î´´Ì¼¤Ê±µÄ³õÊ¼×´Ì¬
    %  clear data;
    label_id=find(labels==15);

    originData=zeros(ch-1,samplerate*1.6,size(label_id,1));
    originLabel=zeros(size(label_id,1),1);
    for i=1:size(label_id,1)
     originData(:,:,(i-1)*96+1:i*96)=samples(:,:,label_id(i)+1:label_id(i)+96);
     originLabel((i-1)*96+1:i*96)=labels(label_id(i)+1:label_id(i)+96);
    end
end

