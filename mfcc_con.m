%	the detailed fft magnitude (freqresp) used in MFCC calculation,
%	the mel-scale filter bank output (fb)
%	the filter bank output by inverting the cepstrals with a cosine 
%		transform (fbrecon),
%	the smooth frequency response by interpolating the fb reconstruction 
%		(freqrecon)
function [ceps,freqresp,fb,fbrecon,freqrecon] = ...
		mfcc_fft(input, samplingRate, frameRate)
global mfccDCTMatrix mfccFilterWeights

[r c] = size(input);
if (r > c) 
	input=input';% Repositioning
end

%	Filter bank parameters
lowestFrequency = 133.3333;
linearFilters = 13;
linearSpacing = 66.66666666;
logFilters = 27;
logSpacing = 1.0711703;
% fftSize = 512;
fftSize = 1024;
cepstralCoefficients = 13;
% windowSize = 400;
% windowSize = 256;
windowSize = 10;
                % Standard says 400, but 256 makes more sense
				% Really should be a function of the sample
				% rate (and the lowestFrequency) and the
				% frame rate.
if (nargin < 2) 
    samplingRate = 16000; 
end
if (nargin < 3) 
    frameRate = 100; 
end

% Keep this around for later....
totalFilters = linearFilters + logFilters;

% Now figure the band edges.  Interesting frequencies are spaced
% by linearSpacing for a while, then go logarithmic.  First figure
% all the interesting frequencies.  Lower, center, and upper band
% edges are all consequtive interesting frequencies. 

freqs = lowestFrequency + (0:linearFilters-1)*linearSpacing;
freqs(linearFilters+1:totalFilters+2) = ...
		      freqs(linearFilters) * logSpacing.^(1:logFilters+2);

lower = freqs(1:totalFilters);% Corresponding to the low, medium and high corresponding frequencies respectively
center = freqs(2:totalFilters+1);
upper = freqs(3:totalFilters+2);
%disp(lower);%

% We now want to combine FFT bins so that each filter has unit
% weight, assuming a triangular weighting function.  
% mfccFilterWeights
%First figure out the height of the triangle, then we can figure out each 
% frequencies contribution ((can be seen here as a delta bandpass filter (a set of dense to sparse filters from low to high frequencies) --> elimination of harmonic interference))
mfccFilterWeights = zeros(totalFilters,fftSize); % The column is fftsize which is equivalent to giving the number of filters
triangleHeight = 2./(upper-lower);
fftFreqs = (0:fftSize-1)/fftSize*samplingRate;

Do %(chan,:) for each filter
Multiply all %fftfreqs in the chan row by the value of the chan element greater than the chan element in lower and less than or equal to the chan element in center
for chan=1:totalFilters 
    mfccFilterWeights(chan,:) = ...
  (fftFreqs > lower(chan) & fftFreqs <= center(chan)).* ...
   triangleHeight(chan).*(fftFreqs-lower(chan))/(center(chan)-lower(chan)) + ...
  (fftFreqs > center(chan) & fftFreqs < upper(chan)).* ...
   triangleHeight(chan).*(upper(chan)-fftFreqs)/(upper(chan)-center(chan));
end
%semilogx(fftFreqs,mfccFilterWeights'
%axis([lower(1) upper(totalFilters) 0 max(max(mfccFilterWeights))])

% A fixed formula with windowsize as the independent variable, hamming the window instead of adding a rectangular window to avoid discontinuities at the window boundary leading to problems later in the Fourier analysis
hamWindow = 0.54 - 0.46*cos(2*pi*(0:windowSize-1)/windowSize);

if 0					% Window it like ComplexSpectrum
	windowStep = samplingRate/frameRate;
	a = .54;%0.54
	b = -.46;
	wr = sqrt(windowStep/windowSize);
	phi = pi/windowSize;
	hamWindow = 2*wr/sqrt(4*a*a+2*b*b)* ...
		(a + b*cos(2*pi*(0:windowSize-1)/windowSize + phi));
end

% ??????????????DCT????MFCC????????????????????????
% Figure out Discrete Cosine Transform.  We want a matrix
% dct(i,j) which is totalFilters x cepstralCoefficients in size.
% The i,j component is given by 
%                cos( i * (j+0.5)/totalFilters pi )
% where we have assumed that i and j start at 0.
mfccDCTMatrix = 1/sqrt(totalFilters/2)*cos((0:(cepstralCoefficients-1))' * ...
				(2*(0:(totalFilters-1))+1) * pi/2/totalFilters);
mfccDCTMatrix(1,:) = mfccDCTMatrix(1,:) * sqrt(2)/2;

%imagesc(mfccDCTMatrix);


% Filter the input with the preemphasis filter.  Also figure how
% many columns of data we will end up with.
if 1
	preEmphasized = filter([1 -.97], 1, input);
else
	preEmphasized = input;
end
windowStep = samplingRate/frameRate; 
cols = fix((length(input)-windowSize)/windowStep);

% Allocate all the space we need for the output arrays.
ceps = zeros(cepstralCoefficients, cols);
if (nargout > 1) 
    freqresp = zeros(fftSize/2, cols); 
end
if (nargout > 2) 
    fb = zeros(totalFilters, cols); 
end

% Invert the filter bank center frequencies.  For each FFT bin
% we want to know the exact position in the filter bank to find
% the original frequency response.  The next block of code finds the
% integer and fractional sampling positions.
if (nargout > 4)
	fr = (0:(fftSize/2-1))'/(fftSize/2)*samplingRate/2;
	j = 1;
	for i=1:(fftSize/2)
		if fr(i) > center(j+1)
			j = j + 1;
		end
		if j > totalFilters-1
			j = totalFilters-1;
		end
		fr(i) = min(totalFilters-.0001, ...
		    max(1,j + (fr(i)-center(j))/(center(j+1)-center(j))));
	end
	fri = fix(fr);
	frac = fr - fri;

	freqrecon = zeros(fftSize/2, cols);
end

% Ok, now let's do the processing.  For each chunk of data:
%    * Window the data with a hamming window,
%    * Shift it into FFT order,
%    * Find the magnitude of the fft,
%    * Convert the fft data into filter bank outputs,
%      FFT: After multiplying the Hamming window, the energy distribution on the spectrum is obtained by FFT for each frame, and the power spectrum is obtained by FFT for each frame after adding the window to the split-pin and taking the square of the mode
%    * Find the log base 10,
%    * Find the cosine transform to reduce dimensionality.DCT --> 13 dimentional MFCC
for start=0:cols-1 % For each column of signals
    first = start*windowStep + 1;
    last = first + windowSize-1;
    fftData = zeros(1,fftSize); %Initialize column vectors
    fftData(1:windowSize) = preEmphasized(first:last).*hamWindow; % Pre-weight this column and add windows
    fftMag = abs(fft(fftData)); % Each one does an FFT and then takes a mode (column vector)
    earMag = log10(mfccFilterWeights * fftMag'); % Trigonometric filtering and logarithmic operations

    % ceps: 13 x cols matrix
    ceps(:,start+1) = mfccDCTMatrix * earMag; % Do DCT to get MFCC
    if (nargout > 1) 
        freqresp(:,start+1) = fftMag(1:fftSize/2)'; 
    end
    if (nargout > 2) 
        fb(:,start+1) = earMag; 
    end
	if (nargout > 3) 
		fbrecon(:,start+1) = ...
			mfccDCTMatrix(1:cepstralCoefficients,:)' * ...
			ceps(:,start+1);
	end
	if (nargout > 4)
		f10 = 10.^fbrecon(:,start+1);
		freqrecon(:,start+1) = samplingRate/fftSize * ...
			(f10(fri).*(1-frac) + f10(fri+1).*frac);
	end
end

% OK, just to check things, let's also reconstruct the original FB
% output.  We do this by multiplying the cepstral data by the transpose
% of the original DCT matrix.  This all works because we were careful to
% scale the DCT matrix so it was orthonormal.
if 1 & (nargout > 3) 
	fbrecon = mfccDCTMatrix(1:cepstralCoefficients,:)' * ceps; % Output filter bank by inverting the inverse spectrum using the cosine transform (verification)
%	imagesc(mt(:,1:cepstralCoefficients)*mfccDCTMatrix);
end
