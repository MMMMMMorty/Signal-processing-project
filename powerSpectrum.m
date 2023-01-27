clear;
filename = input('Please input the name of the wavfile:','s');
[signal,Fs] = audioread(filename);%读取语音信号
Fs = 16000;%按文中规定是16khz

%-----------------------------------------------------------------------------------------------
%得到论文中Table1的取值（16）
Nk=[];
for k = 1:143
    Fk = 2^((k - 43)/24)*440;
    Nk(k) = round(Fk*1024/Fs);% round --> int
end
psi=unique(Nk);%ψ
disp(psi);
len=length(psi(:));
disp(len);

%-----------------------------------------------------------------------------------------------
% 这后面是用1024-point FFT、分析窗口30ms、overlap20ms得到的功率谱（如果不考虑画图，Pxx是其计算值）
n=0:1/Fs:1;
% xn=cos(2*pi*40*n)+3*cos(2*pi*100*n)+randn(size(n));
nfft=1024;
window=boxcar(30); %矩形窗
% window1=hamming(30); %海明窗
% window2=blackman(30); %blackman窗
noverlap=20; %数据无重叠
range='half';
[Pxx]=pwelch(psi,window,noverlap,nfft,Fs,range);
% [Pxx1,f]=pwelch(xn,window1,noverlap,nfft,Fs,range);
% [Pxx2,f]=pwelch(xn,window2,noverlap,nfft,Fs,range);
% Pxx：功率谱估计值；X(psi(i))=Y(i) 
% F：Pxx值所对应的频率点，F是为了画图，也就是说如果不画图不用管F 

% % [Pxx,f]=pwelch(xn,window,noverlap,nfft,Fs);
% [Pxx]=pwelch(psi,window,noverlap,nfft,Fs);
% % [Pxx1,f]=pwelch(xn,window1,noverlap,nfft,Fs);
% % [Pxx2,f]=pwelch(xn,window2,noverlap,nfft,Fs);
% plot_Pxx=10*log10(Pxx);
% plot_Pxx1=10*log10(Pxx1);
% plot_Pxx2=10*log10(Pxx2);

% figure(1)
% plot(f,plot_Pxx);
% plot(plot_Pxx,'r');
% % % % % % % % % % % % % % % % % % % % % % % % % % disp(length(Pxx(:)));
% % % % % % % % % % % % % % % % % % % % % % % % % % plot(Pxx,'r');
% % % % % % % % % % % % % % % % % % % % % % % % % % hold on
% legend('矩形窗');
% pause;
% figure(2)
% plot(f,plot_Pxx1);
% title('Hamming窗');
% pause;
% figure(3)
% plot(f,plot_Pxx2); 
% title('Blackman窗');


Y=[];
for i = 1:len
   Y(i)=Pxx(psi(i)); 
end
disp(length(Y(:)));
plot_Y=Y/100;
plot(plot_Y,'r');
hold on
%-----------------------------------------------------------------------------------------------
% 频谱的自我规范，论文中说相对大的就算fast，这个相对我在这里草率看作以0.5为界
alpha=input('Please input α(0≤α≤1) for the iretation towards fast running average(α>0.5):');
Yf=[];
Yf(1)=alpha*Y(1);
for i = 2:len
    Yf(i)=(1-alpha)*Yf(i-1)+alpha*Y(i);
end
alpha=input('Please input α(0≤α≤1) for the iretation towards slow running average(α<0.5):');
Ys=[];
Ys(1)=alpha*Y(1);
for i = 2:len
    Ys(i)=(1-alpha)*Ys(i-1)+alpha*Y(i);
end
C=Yf/Ys;
Z=C*Y;
plot_Z=Z/100;
% figure(1)
plot(plot_Z,'b');
% plot(Z,'b');
legend('矩形窗','矩形窗-归一化处理后');

%-----------------------------------------------------------------------------------------------
%后续处理（输出频谱图）
% newZ=sqrt(Z);
% plot(newZ,'g');