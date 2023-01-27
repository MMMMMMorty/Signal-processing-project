function Fn = mfcc_aud(Filename)% input, samplingRate, frameRate
%     windowSize = 10;
    global nsl;
    load nslguisettings;
    loadload;
    close;
    
    nsl.wav=audioread(Filename);
    wavtemp=nsl.wav;
    if stg.tw~=0
        wavtemp(floor(stg.tw*stg.fs):end)=[];
    end
    if stg.nf~=-2
        wavtemp=unitseq(wavtemp);
    end
    nsl.aud=wav2aud(wavtemp', [stg.fl stg.tc stg.nf log2(stg.fs/16000)]);
%     An = powerSpectrum();
%     disp(nsl.aud);
    [K,n] = size(nsl.aud);
    
%     
%     windowStep = samplingRate/frameRate; % Sample rate divided by the number of frames --> number of samples contained in a frame
%     n = fix((length(input)-windowSize)/windowStep);% Rounded down,n frames
    
    %a set of 13 coefficients is calculated as follows:
    Fn = zeros(13,n);
    for l = 1:13
        for k = 1:K
            Fn(1,:) = sum(nsl.aud(k,:))/sqrt(K);
            Fn(l,:) = nsl.aud(k,:)*cos(l*(2*k+1)*pi/(2*K))/sqrt(K/2);
        end
    end
    
    disp(Fn);
    
%     mfccDCTMatrix = 1/sqrt(totalFilters/2)*cos((0:(cepstralCoefficients-1))' * ...
%                     (2*(0:(totalFilters-1))+1) * pi/2/totalFilters);
%     mfccDCTMatrix(1,:) = mfccDCTMatrix(1,:) * sqrt(2)/2;
%     ceps = zeros(13, n);
%     for start=1:13 % For each column of signals
%         first = start*windowStep + 1;
%         last = first + windowSize-1;
%         fftData = zeros(1,fftSize); %Initialize column vectors
%         fftData(1:windowSize) = preEmphasized(first:last).*hamWindow; % Pre-weight this column and add windows
%         fftMag = abs(fft(fftData)); % Each one does an FFT and then takes a mode (column vector)
%         earMag = log10(mfccFilterWeights * fftMag'); % Trigonometric filtering and logarithmic operations
% 
%         ceps(:,start+1) = Fn * earMag; % Do DCT to get MFCC
%     end
end