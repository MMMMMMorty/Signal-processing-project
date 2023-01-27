% 如果要画图的话把注释去掉就行
function mfcc_set(filename)
% set_window_size(348, 188);
tap = audioread(filename);
[ceps1] = mfcc_con(tap,16000,100);
% imagesc(ceps); 
% colormap(1-gray);
% disp(ceps1);
disp(size(ceps1));
[ceps2] = mfcc_cms(tap,16000,100);
% disp(ceps2);
disp(size(ceps2));
[ceps3] = mfcc_fft(tap);
% disp(ceps3);
disp(size(ceps3));
[ceps4] = mfcc_aud(filename);
% disp(ceps4);
disp(size(ceps4));
[ceps5] = spec_fft(tap,16000);
% disp(ceps5);
disp(size(ceps5));

% function set_window_size(width, height)
% cursize = get(gcf, 'position');
% cursize(3) = width+1;
% cursize(4) = height+1;
% set(gcf, 'position', cursize);