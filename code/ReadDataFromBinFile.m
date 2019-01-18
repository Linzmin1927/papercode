%% 从文件读取数据
function data = ReadDataFromBinFile(filename, channel)

if nargin == 1
    channel = 17;
end

fid = fopen(filename, 'rb');
data = fread(fid, [channel, inf], 'single');
fclose(fid);
end
