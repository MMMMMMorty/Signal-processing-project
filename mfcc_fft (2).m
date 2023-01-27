function Fn = mfcc_fft(signal)
%     windowSize = 10;
    An = NewPowerSpectrum(signal);% 1 x 120
%     disp(An);
%     disp(size(An));
    [n,K] = size(An);% n=1,k=120
    
%     %��֡
%     windowStep = samplingRate/frameRate; % �����ʳ���֡�� --> һ֡�����Ĳ�����
%     n = fix((length(signal)-windowSize)/windowStep);% fix���㷽��ȡ��,n֡
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
%     ceps = zeros(13, n);% ����13 x n��ȫ����� ׼��
%     for start=1:13 % ��ÿ���ź�
%         first = start*windowStep + 1;
%         last = first + windowSize-1;
%         fftData = zeros(1,fftSize); %��ʼ��������
%         fftData(1:windowSize) = preEmphasized(first:last).*hamWindow; % Ԥ���������źŲ��Ӵ�
%         fftMag = abs(fft(fftData)); % ÿ������FFTȻ��ȡģ����������
%         earMag = log10(mfccFilterWeights * fftMag'); % �����˲��Ͷ�������
% 
%         ceps(:,start+1) = Fn * earMag; % ��DCT�õ�MFCC
%     end
end