% 如果要画图的话把注释去掉就行
function mfcc_set()
% set_window_size(348, 188);
tap = audioread('wav_sample_output.wav');
[ceps] = mfcc_con(tap,16000,100);
% imagesc(ceps); 
% colormap(1-gray);
disp(ceps);
disp(size(ceps));

% function set_window_size(width, height)
% cursize = get(gcf, 'position');
% cursize(3) = width+1;
% cursize(4) = height+1;
% set(gcf, 'position', cursize);