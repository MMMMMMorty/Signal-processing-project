clear;
filename = input('Please input the name of the wavfile:','s');
[signal,Fs] = audioread(filename);%��ȡ�����ź�
Fs = 16000;%�����й涨��16khz
% disp(signal);
% disp(length(signal(:)));
sig=signal.';

%-----------------------------------------------------------------------------------------------
%�õ�������Table1��ȡֵ��16��
for k = 1:143
    Fk(k) = 2^((k - 43)/24)*440;
    Nk(k) = round(Fk(k)*1024/Fs);% round --> int
end
disp(Fk);
disp(length(Fk(:)));
psi=unique(Nk);%��
disp(psi);
len=length(psi(:));
disp(len);

%-----------------------------------------------------------------------------------------------
% ���������1024-point FFT����������30ms��overlap20ms�õ��Ĺ����ף���������ǻ�ͼ��Pxx�������ֵ��
n=0:1/Fs:1;
% xn=cos(2*pi*40*n)+3*cos(2*pi*100*n)+randn(size(n));
nfft=1024;
window=hamming(length(sig)); %��
% window1=hamming(30); %������
% window2=blackman(30); %blackman��
overlap=20; %�����ص�
range='half';
[Pxx]=pwelch(sig,window,overlap,nfft,Fs,range);
% [Pxx1,f]=pwelch(xn,window1,overlap,nfft,Fs,range);
% [Pxx2,f]=pwelch(xn,window2,overlap,nfft,Fs,range);
% Pxx�������׹���ֵ��X(psi(i))=Y(i) 
% F��Pxxֵ����Ӧ��Ƶ�ʵ㣬F��Ϊ�˻�ͼ��Ҳ����˵�������ͼ���ù�F 

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
% legend('���δ�');
% pause;
% figure(2)
% plot(f,plot_Pxx1);
% title('Hamming��');
% pause;
% figure(3)
% plot(f,plot_Pxx2); 
% title('Blackman��');


Y=[];
for i = 1:len
   Y(i)=Pxx(psi(i)); 
end
disp(length(Y(:)));
% plot_Y=Y/100;
% plot(plot_Y,'r');
plot(Y,'r');
hold on
xlabel('Frequenct Index');
ylabel('Power Spectrum');
%-----------------------------------------------------------------------------------------------
% Ƶ�׵����ҹ淶��������˵��Դ�ľ���fast������������������ʿ�����0.5Ϊ��
alpha=input('Please input ��(0�ܦ���1) for the iretation towards fast running average(��>0.5):');
Yf=[];
Yf(1)=alpha*Y(1);
for i = 2:len
    Yf(i)=(1-alpha)*Yf(i-1)+alpha*Y(i);
end
alpha=input('Please input ��(0�ܦ���1) for the iretation towards slow running average(��<0.5):');
Ys=[];
Ys(1)=alpha*Y(1);
for i = 2:len
    Ys(i)=(1-alpha)*Ys(i-1)+alpha*Y(i);
end
C=Yf/Ys;
Z=C*Y;
% plot_Z=Z/100;
% figure(1)
% plot(plot_Z,'b');
plot(Z,'b');
legend('������','������-�����');

%-----------------------------------------------------------------------------------------------
%�����������Ƶ��ͼ��
figure(2);
newZ=sqrt(Z);
ZZ=smoothdata(newZ);
% plot(ZZ,Z,'g');
plot(flipud(ZZ));