function [ output_args ] = cnn_score(im, use_gpu)
%CNN_SCORE 此处显示有关此函数的摘要
%   此处显示详细说明

if exist('use_gpu', 'var') && use_gpu
  caffe.set_mode_gpu();
  gpu_id = 0;  % we will use the first gpu in this demo
  caffe.set_device(gpu_id);
else
  caffe.set_mode_cpu();
end
model_dir = '../../models/bvlc_reference_caffenet/';
net_model = [model_dir 'deploy.prototxt'];
net_weights = [model_dir 'bvlc_reference_caffenet.caffemodel'];
phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Please download CaffeNet from Model Zoo before you run this demo');
end
net = caffe.Net(net_model, net_weights, phase);
input_data = {prepare_image(im)};
scores = net.forward(input_data);
scores = scores{1};
scores = mean(scores, 2);  % take average scores over 10 crops
caffe.reset_all();

end

