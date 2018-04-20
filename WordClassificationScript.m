%% Try to clean up the script for feature extraction & DTW using functions

%Loading the Signals
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Rechts1.wav');
Rechts = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Midden1.wav');
Midden = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Links1.wav');
Links = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\MiddenT.wav'); %Change this to Links, Midden or Rechts: 2, 3 or T to test accuracy!
Woord = Sound(:,1); %This is the unknown word. The others serve as exemplars.

%Placing them into a sequence of overlapping mel-frequency bin feature
%vectors
RechtsCo = MelFreqCoef(Rechts,Fs);
MiddenCo = MelFreqCoef(Midden,Fs);
LinksCo = MelFreqCoef(Links,Fs);
WoordCo = MelFreqCoef(Woord,Fs);

%Perform DTW comparions on these feature vectors
figure(1)
[rechtsPath, IsRechts] = warpMe(RechtsCo, WoordCo);
title('Rechts?')

figure(2)
[middenPath, IsMidden] = warpMe(MiddenCo, WoordCo);
title('Midden?')

figure(3)
[linksPath, IsLinks] = warpMe(LinksCo, WoordCo);
title('Links?')

%Find the least distance and classify the word as this exemplar (1NN)
    %We can probably do even better with kNN if we have more exemplars of
    %every word.
leastWas = min([IsRechts, IsMidden, IsLinks]);
if leastWas == IsRechts
    disp('Het woord was: Rechts!')
elseif leastWas == IsMidden
    disp('Het woord was: Midden!')
elseif leastWas == IsLinks
    disp('Het woord was: Links!')
end

%% We Still Have To Keep Utterances In Mind That Are Not Links Midden Rechts!
