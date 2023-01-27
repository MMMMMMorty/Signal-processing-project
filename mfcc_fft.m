function Fn = mfcc_fft()% input, samplingRate, frameRate
%     windowSize = 10;
    An = powerSpectrum();
    disp(An);
    [K,n] = size(An);
    
%     %��֡
%     windowStep = samplingRate/frameRate; % �����ʳ���֡�� --> һ֡�����Ĳ�����
%     n = fix((length(input)-windowSize)/windowStep);% fix���㷽��ȡ��,n֡
    
    %a set of 13 coefficients is calculated as follows:
    Fn = zeros(13,n);
    for l = 1:13
        for k = 1:K
            Fn(1,:) = sum(An(k,:))/sqrt(K);
            Fn(l,:) = An(k,:)*cos(l*(2*k+1)*pi/(2*K))/sqrt(K/2);
        end
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