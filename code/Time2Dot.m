%% 将t毫秒转换成点数
function d = Time2Dot(sample_rate, t)
d = sample_rate * t / 1000;
end
