%% ת��label
% label��ʾԭ����label�����label��ͳһlabel������ĳ��ʱ������ͳһ��ǩ
% dT��ʾÿ��sample�ĳ���ʱ��
% ת���ɵ�newlabel�ǣ�ֻ��һ���̼��ʼ��ʱ�̾��б�ǩ��
function newlabel = ChangeLabel(label, dT)
    
    label = round(label);
    len = length(label);
    curId = 0;
    newlabel = label;
    for i = 1 : len    %��ÿ��������ĵ�һ���걣��������������0
        if newlabel(i) == curId
            newlabel(i) = 0;
        else
            curId = newlabel(i);
        end
    end
    
    i = 1;
    while i < len
        if newlabel(i) == 1    %�ӱ��1��ʼ������
            needAdd = 1;
            for j = 1 : (dT + 10)  %���i֮���j���ǩ�Ƿ�Ϊ0��������������һ��
                if i+j > len || newlabel(i + j)~=0
                    needAdd = 0;
                    i = i + j;%������������������???what
                    break;
                end
            end
            if needAdd == 1
                newlabel(i + dT) = 1;
                i = i + dT;
            end
        else
            i = i + 1;
        end
    end
    newlabel = newlabel .* (label ~= 0);
    
end