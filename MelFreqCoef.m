function coefMat = MelFreqCoef(Speech, Fs)
%% Functional Feature Extraction script
% Enter a single speech sound channel and it's sampling rate.

blockL = 0.02*Fs;                %Length of blocks is 20ms -> has to be even so check with different Fs!!
blockP = floor(0.375*blockL);    %Next block starts after blockP samples -> defines degree of  overlap in blocks

nBlocks = 0;           %Loop to determine how many 20ms blocks we need to capture the full speech data
for block = 1:100000
    blockStart = 1+(block-1)*blockP;
    blockEnd = blockStart + blockL;
    if blockEnd < length(Speech)
        nBlocks = nBlocks+1;
    else
        break
    end
end

%Build a matrix of speech signals for all blocks. Rows index the block and
%columns the samples within that block.
blockMat = zeros(nBlocks,blockL);           %Preallocation
for block = 1:nBlocks
    blockStart = 1+(block-1)*blockP;
    blockEnd = blockStart + blockL-1;
    blockSpeech = Speech(blockStart:blockEnd);
    blockMat(block,1:length(blockSpeech)) = blockSpeech;
end

%Apply a Hamming window to each block
hamWindow = 0.54 - 0.46 * cos((2*pi*[1:blockL])/(blockL-1));
for block = 1:nBlocks
    blockMat(block,:) = blockMat(block,:).*hamWindow;
end

%MEL-FREQUENCY-CEPSTRAL-COEFFICIENTS TRANSFORM
%_____________________________________________

%Transform 20ms hamming-windowed time series into the frequency domain:
FFTMat = zeros(nBlocks, blockL/2+1);       %Preallocation
for block = 1:nBlocks
    Y = fft(blockMat(block,:));
    P2 = 1/blockL* abs(Y/blockL).^2;       %Squared and 1/blockL to get power instead of amplitude (whatever the difference may be)
    P1 = P2(1:blockL/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    FFTMat(block,:) = P1;
end

f = Fs*(0:(blockL/2))/blockL; %Vector to show the Hz bins: Is the same for any 
                              %nBlock since blockL and Fs are always the same
                              
%Get triangular mel-scaled filterbanks
nFilters = 20;               %The amount of triangular filters you want to end with
lowerBound = 0;
upperBound = 8000;           %Basically the range of Hz you would work on (0-8000Hz for us) NOTE: maybe change to 5000Hz is more appropriate
melLower = 1125*log(1+lowerBound/700);           %Bottom of filterbank (0Hz) in Mel
melUpper = 1125*log(1+upperBound/700);           %Upper limit of filterbank (8000Hz) in Mel
triBanksMel = linspace(melLower,melUpper,nFilters+2);    %Linear spacing in Mel scale != linear spacing in Hz!; use 22 values
                                                 %to later specify 20 triangular filters (20 MFC coeficcients)
triBanksHz = 700*(exp(triBanksMel/1125)-1);      %Transform back to Hz                              
                              
%The actual filterbank
filterBankVec = zeros(nFilters,blockL/2+1);       %Preallocation
for filter = 1:nFilters       %Take 20 filters
    midFil = triBanksHz(filter+1);
    startFil = triBanksHz(filter);
    endFil = triBanksHz(filter+2);
    fFilIndex = find(f>startFil & f<endFil);
    filTriang = triang(length(fFilIndex));
    filterBankVec(filter,fFilIndex) = filTriang;
end
                                 
coefMat = zeros(nBlocks, nFilters);
for block = 1:nBlocks
    for filter = 1:nFilters
        coefMat(block,filter) = log(sum(FFTMat(block,:) .* filterBankVec(filter,:)));
    end
end                              
                              
                              
                              

