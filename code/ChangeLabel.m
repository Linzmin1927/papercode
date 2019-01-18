%% 转换label
% label表示原来的label，这个label是统一label，即在某个时段内用统一标签
% dT表示每个sample的持续时间
% 转换成的newlabel是，只在一个刺激最开始的时刻具有标签。
function newlabel = ChangeLabel(label, dT)
    
    label = round(label);
    len = length(label);
    curId = 0;
    newlabel = label;
    for i = 1 : len    %将每个样本打的第一个标保留下来，其他置0
        if newlabel(i) == curId
            newlabel(i) = 0;
        else
            curId = newlabel(i);
        end
    end
    
    i = 1;
    while i < len
        if newlabel(i) == 1    %从标记1开始？？？
            needAdd = 1;
            for j = 1 : (dT + 10)  %检查i之后的j秒标签是否为0，不是则跳过这一段
                if i+j > len || newlabel(i + j)~=0
                    needAdd = 0;
                    i = i + j;%？？？？？？？？？???what
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