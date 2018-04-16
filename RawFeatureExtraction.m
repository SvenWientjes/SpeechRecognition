%% Unprocessed Speech Signal Feature Extraction
% This will use overlapping blocks to characterize speech content

%Loading the signal
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LinksMiddenRechtsTest1.wav'); %Sound = audio file, Fs = sample frequency of microphone
    %Note: specify the file location of desired analyzed sound file
        %We should write an iterative function that can automatically
        %analyze (load in) a whole windows folder filled with properly named audio
        %files one by one to do analysis on them
    %Note: the Sound variable has 2 vectors representing the Left and Right
    %sound channel if its a .wav -> we can probably rely on only one for speech
    %recognition which is extracted here:
Speech = Sound(:,1);

%Note: we probably have to do some preprocessing and filtering of the whole
%sound signal BEFORE we start the Feature Extraction part of this script.
%Maybe we should ask Mark for some tips.

%% Feature extraction
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
lowerBound = 0;
upperBound = 8000;           %Basically the range of Hz you would work on (0-8000Hz for us)
melLower = 1125*log(1+lowerBound/700);           %Bottom of filterbank (0Hz) in Mel
melUpper = 1125*log(1+upperBound/700);           %Upper limit of filterbank (8000Hz) in Mel
triBanksMel = linspace(melLower,melUpper,22);    %Linear spacing in Mel scale != linear spacing in Hz!; use 22 values
                                                 %to later specify 20 triangular filters (20 MFC coeficcients)
triBanksHz = 700*(exp(triBanksMel/1125)-1);      %Transform back to Hz

%Do the step 5 of practical cryptography --> look into triang(nsamples) function

%Use variable f combined with FFTMat to determine the power within every
%triangular filter -> f indexes the Hz of which FFTMat indexes the Power
%estimate.

%% Diagnostics

%Plot a part of blockMat
for i = 330:335
    plot(blockMat(i,:))
    hold on
end
hold off

%Plot full blockMat
for i = 1:nBlocks
    plot(blockMat(i,:))
    hold on
end
hold off

%Plot a part of FFTMat
for i = 330:335
    plot(f, FFTMat(i,:))
    hold on
end
hold off

%Plot all FFTMat
for i = 1:nBlocks
    plot(f, FFTMat(i,:))
    hold on
end
hold off                    %These plots show quite a lot of detail in the frequency domain is lost
                            %since we take such short (20 ms) blocks ->
                            %Unclear if this is a problem.

