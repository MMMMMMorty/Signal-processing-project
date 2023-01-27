function Fn = mfcc_fft(signal)
%     windowSize = 10;
    An = NewPowerSpectrum(signal);% 1 x 120
%     disp(An);
%     disp(size(An));
    [n,K] = size(An);% n=1,k=120
    
%     %分帧
%     windowStep = samplingRate/frameRate; % 采样率除以帧数 --> 一帧包含的采样数
%     n = fix((length(signal)-windowSize)/windowStep);% fix朝零方向取整,n帧
%     disp(n);
%     K = K/n;
%     disp(K);
    
    % a set of 13 coefficients is calculated as follows:
    Fn = zeros(13,n);
    Fn(1,1) = sum(An)/sqrt(K);
    temp = 0;
    for l = 2:13
        for k = 1:K
            temp = An(k)*cos(l*(2*k+1)*pi/(2*K))*sqrt(2/K) + temp;
        end
        Fn(l,:) = temp;
    end
    
    disp(Fn);
    
%     mfccDCTMatrix = 1/sqrt(totalFilters/2)*cos((0:(cepstralCoefficients-1))' * ...
%                     (2*(0:(totalFilters-1))+1) * pi/2/totalFilters);
%     mfccDCTMatrix(1,:) = mfccDCTMatrix(1,:) * sqrt(2)/2;
%     ceps = zeros(13, n);% 生成13 x n的全零矩阵 准备
%     for start=1:13 % 对每列信号
%         first = start*windowStep + 1;
%         last = first + windowSize-1;
%         fftData = zeros(1,fftSize); %初始化列向量
%         fftData(1:windowSize) = preEmphasized(first:last).*hamWindow; % 预加重这列信号并加窗
%         fftMag = abs(fft(fftData)); % 每个都做FFT然后取模（列向量）
%         earMag = log10(mfccFilterWeights * fftMag'); % 三角滤波和对数运算
% 
%         ceps(:,start+1) = Fn * earMag; % 做DCT得到MFCC
%     end
end