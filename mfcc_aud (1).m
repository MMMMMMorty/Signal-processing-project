function Fn = mfcc_aud(Filename)% input, samplingRate, frameRate
    windowSize = 10;
    global nsl;
    load nslguisettings;
    loadload;
    close;
    
    nsl.wav=audioread(Filename);
    wavtemp=nsl.wav;
%     disp(wavtemp);
%     disp(size(wavtemp));
    if stg.tw~=0
        wavtemp(floor(stg.tw*stg.fs):end)=[];
    end
    if stg.nf~=-2
        wavtemp=unitseq(wavtemp);
    end
    nsl.aud=wav2aud(wavtemp', [stg.fl stg.tc stg.nf log2(stg.fs/16000)]);
%     An = powerSpectrum();
%     disp(nsl.aud);
%     disp(size(nsl.aud));
    [n,K] = size(nsl.aud);%wav2aud

%     
%     windowStep = samplingRate/frameRate; 
%     n = fix((length(input)-windowSize)/windowStep);
    
    %a set of 13 coefficients is calculated as follows:
%     Fn = zeros(13,n);
%     for l = 1:13
%         for k = 1:K
%             Fn(1,:) = sum(nsl.aud(:,k))/sqrt(K);
%             Fn(l,:) = nsl.aud(:,k)*cos(l*(2*k+1)*pi/(2*K))/sqrt(K/2);
%         end
%     end
%     
%     disp(Fn(1,:));
    
    Fn = zeros(13,n);
    temp = 0;
    for i = 1:n
        Fn(1,i) = sum(nsl.aud(i,:))/sqrt(K);
        for l = 2:13 
            for k = 1:K
                temp = nsl.aud(i,k)*cos(l*(2*k+1)*pi/(2*K)) + temp;
            end
            Fn(l,i) = temp*sqrt(2/K);
        end
    end
%     disp(Fn(1,:));
%     
%     disp(Fn);
%     
%     mfccDCTMatrix = 1/sqrt(totalFilters/2)*cos((0:(cepstralCoefficients-1))' * ...
%                     (2*(0:(totalFilters-1))+1) * pi/2/totalFilters);
%     mfccDCTMatrix(1,:) = mfccDCTMatrix(1,:) * sqrt(2)/2;
%     ceps = zeros(13, n);
%     for start=1:13 
%         first = start*windowStep + 1;
%         last = first + windowSize-1;
%         fftData = zeros(1,fftSize); 
%         fftData(1:windowSize) = preEmphasized(first:last).*hamWindow; 
%         fftMag = abs(fft(fftData)); 
%         earMag = log10(mfccFilterWeights * fftMag'); 
% 
%         ceps(:,start+1) = Fn * earMag; 
%     end
end