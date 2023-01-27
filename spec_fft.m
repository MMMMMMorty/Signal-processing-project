function Vector = spec_fft(audio_input,fs)
% filename='wav-sample.wav';
% [audio_input,fs]=audioread(signal);
total_fs=length(audio_input);%语音长度
start_time=round(rand(1,1)*(total_fs-fs));%随机得到一段语音的起始点
%采样率代表每秒钟的采样点个数
end_time=start_time+fs*1;%代表1s的长度
%disp(audio_input);
%disp(start_time);
%disp(end_time);
A=zeros(1,120,119);

for i=1:120
    audio_clip_output=audio_input(start_time:end_time,1);%得到裁剪的语音片段
    % audiowrite('clip_sample_output.wav',audio_clip_output,fs);
    A(:,:,i)=NewPowerSpectrum(audio_clip_output);% 计算功率谱或者频谱图
    start_time=end_time;
    end_time=start_time+fs*1;
    I=i;
    if(end_time>total_fs)
        break;
    end
end
disp(A(:,:,1));

Vector=zeros(I-2,10);%十维向量
% 计算频谱通量SF1 SF2
%SF1=zeros(1,I-2);
%SF2=zeros(1,I-1);

%SC=zeros(1,I-2);
%BW=zeros(1,I-2);
%Rolloff_point1=zeros(1,I-2);
%Rolloff_point2=zeros(1,I-2);
%Energy1=zeros(1,I-2);
%Energy2=zeros(1,I-2);
%Energy3=zeros(1,I-2);
%Energy4=zeros(1,I-2);
for i=1:I
    An=A(:,:,i);
    An_1=A(:,:,i+1);
    An_2=A(:,:,i+2);
    D_An=An_1-An;
    D_An_1=An_2-An_1;
    SCn=calucate_sc(A(:,:,i),fs); % 质心
    BWn=calucate_bw(A(:,:,i),SCn);% 带宽
    Rolloff_point1n=calucate_ro(A(:,:,i),0.5); 
    Rolloff_point2n=calucate_ro(A(:,:,i),0.9);
    Energy1n=calucate_en(A(:,:,i),1);%总能量
    Energy2n=calucate_en(A(:,:,i),2);%0-1kHz
    Energy3n=calucate_en(A(:,:,i),3);%1-2kHZ
    Energy4n=calucate_en(A(:,:,i),4);%2-4Khz
    Sum1=0;
    Sum2=0;
    for k=1:119
        Sum1=sum((An_1(1,k)-An(1,k))*(An_1(1,k)-An(1,k)))+Sum1; %SF1
        Sum2=sum((D_An_1(1,k)-D_An(1,k))*(D_An_1(1,k)-D_An(1,k)))+Sum2; %SF2
    end
%    SC(1,i)=SCn;
%    BW(1,i)=BWn;
%   Rolloff_point1(1,i)=Rolloff_point1n;
%   Rolloff_point2(1,i)=Rolloff_point2n;
%    Energy1(1,i)=Energy1n;
%    Energy2(1,i)=Energy2n;
%    Energy3(1,i)=Energy3n;
%    Energy4(1,i)=Energy4n;
%    SF1(1,i)=sqrt(Sum1);
%    SF2(1,i)=sqrt(Sum2);
    Vector(i,1)=Energy1n;
    Vector(i,2)=Energy2n;
    Vector(i,3)=Energy3n;
    Vector(i,4)=Energy4n;
    Vector(i,5)=sqrt(Sum1);
    Vector(i,6)=sqrt(Sum2);
    Vector(i,7)=Rolloff_point1n;
    Vector(i,8)=Rolloff_point2n;
    Vector(i,9)=SCn;
    Vector(i,10)=BWn;
end
%disp(SF1);
%disp(SF2);

%计算质心
function SCn=calucate_sc(An,fs)
    [l,K]=size(An);
    Sum1=0;
    Sum2=0;
    for k=1:120
        Sum1=sum(k*(An(l,k)))+Sum1;
        Sum2=sum((An(l,k)))+Sum2;
    end
    SCn=Sum1/Sum2;
    
end

%计算带宽
function BWn=calucate_bw(An,SCn)
    [l,K]=size(An);
    Sum1=0;
    Sum2=0;
    for k=1:K
        Sum1=sum((k-SCn)*(k-SCn)*An(l,k))+Sum1;
        Sum2=sum(An(l,k))+Sum2;
    end
    BWn=sqrt(Sum1/Sum2);
end

function Rolloff_pointn=calucate_ro(An,percentiles)% 用两次 一次0.5，一次0.9
    [l,K]=size(An);
    Sum=0;
    for k=1:K
        Sum=sum(An(l,k))+Sum;
    end
    Rolloff_pointn=percentiles*Sum;
end

function Energyn=calucate_en(An,mode)
    [l,K]=size(An);
    Sum=0;
    if(mode==1)
        for k=1:K
        Sum=sum(An(l,k))+Sum;
        end
        Energyn=Sum;
    end
    if(mode==2)
        for k=1:K
            if(0<1/An(l,k)<1000)
                Sum=sum(An(l,k))+Sum;
            end
        end
        Energyn=Sum;
    end
    if(mode==3)
        for k=1:K
            if(1000<1/An(l,k)<2000)
                Sum=sum(An(l,k))+Sum;
            end
        end
        Energyn=Sum;
    end
    if(mode==4)
        for k=1:K
            if(2000<1/An(l,k)<4000)
                Sum=sum(An(l,k))+Sum;
            end
        end
        Energyn=Sum;
    end
end
end