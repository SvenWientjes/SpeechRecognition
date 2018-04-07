%% Speech signal preprocessing

%Loading the signal
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LinksMiddenRechtsTest1.wav');
    %Note: specify the file location of desired analyzed sound file
        %We should write an iterative function that can automatically
        %analyze (load in) a whole windows folder filled with properly named audio
        %files one by one!
    %Note: the Sound variable has 2 vectors representing the Left and Right
    %sound channel -> we can probably rely on only one for speech
    %recognition.
Speech = Sound(:,1);

%Play part of the signal to verify success
sound(Sound, Fs)
sound(Speech, Fs)

%Maybe apply a FIR filter
% speechFilt = designfilt('highpassfir', %how to get 1-0.95z^(-1)?

%% Voice Activation Detection
blockL = 0.02*Fs;     %Check the signal every 20ms; determined by sample rate Fs
nBlocks = round(length(Speech)/blockL); %How many blocks of blockL samples can be drawn from the data (rounded to nearest integer)

%Short-term Power Estimate
powerE = [];             %Power Estimates for signal blocks
for block = 1:nBlocks
    blockStart = 1+(block-1)*blockL;
    blockEnd = blockL*block;
    ssSquare = sum(Speech(blockStart:blockEnd).^2);
    powerE(block) = 1/blockL*ssSquare;
end

%Short-term Zero Crossing Rate
zeroCR = [];
speechSign = sign(Speech);
speechSign(speechSign == 0) = 1;
speechCR = [];
for block = 1:nBlocks
    blockStart = 1+(block-1)*blockL;
    blockEnd = blockL*block;
    for compare = blockStart+1:blockEnd
        speechCR(compare-blockStart) = (abs(speechSign(compare) - speechSign(compare-1)))/2;
    end
    zeroCR(block) = 1/blockL*sum(speechCR);
end

%Converging decision function
stPowerCR = [];
for block = 1:nBlocks
    stPowerCR(block) = powerE(block)*(1-zeroCR(block))*1000;
end
    
%Make a decision criterion to determine whether there is speech or not:
%based on mean and variance of first ten blocks (200ms) -> so we assume
%nothing is said during this time!
muTw = mean(stPowerCR(1:10));   %mean of decision function for first 10 samples
varTw = var(stPowerCR(1:10));   %variance of decision function for first 10 samples
aTw = 0.2*varTw^(-0.8);         %constant that scales up the variance
Tw = muTw + aTw*varTw;

%Use threshold Tw to make binary decision if speech is present or not
%within block -> all sample moments within that block are assigned that
%decision
%For block
IsSpeechB = [];
for block = 1:nBlocks
    if stPowerCR(block) < Tw
        IsSpeechB(block) = 0;
    elseif stPowerCR(block) >= Tw
        IsSpeechB(block) = 1;
    else
        disp('This is weird... Something went wrong.')
    end
end
%For raw speech signal
IsSpeech = [];
for block = 1:nBlocks
    blockStart = 1+(block-1)*blockL;
    blockEnd = blockL*block;
    if IsSpeechB(block) == 1
        IsSpeech(blockStart:blockEnd) = 1;
    elseif IsSpeechB(block) == 0
        IsSpeech(blockStart:blockEnd) = 0;
    else 
        disp('Something else went wrong')
    end 
end

%Make a plot to see what is speech and what is not
plot(Speech)
hold on
plot(IsSpeech/40)   %the scaling factor /40 might not be ideal to visualize any speech signal: it depends on the amplitude of the signal.
hold off

