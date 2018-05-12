%% Try to clean up the script for feature extraction & DTW using functions

%Loading the Signals
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Rechts1.wav');
Rechts1 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Rechts2.wav');
Rechts2 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Rechts3.wav');
Rechts3 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Midden1.wav');
Midden1 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Midden2.wav');
Midden2 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Midden3.wav');
Midden3 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Links1.wav');
Links1 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Links2.wav');
Links2 = Sound(:,1);
[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\Links3.wav');
Links3 = Sound(:,1);

[Sound, Fs] = audioread('X:\My Documents\MATLAB\LinksMiddenRechts\LMR Finished\RechtsT2.wav'); %Change this to Links, Midden or Rechts: 2, 3 or T to test accuracy!
Woord = Sound(:,1); %This is the unknown word. The others serve as exemplars.

%Placing them into a sequence of overlapping mel-frequency bin feature
%vectors
RechtsCo1 = MelFreqCoef(Rechts1,Fs);    %Make a list or something of these through a for loop
RechtsCo2 = MelFreqCoef(Rechts2,Fs);
RechtsCo3 = MelFreqCoef(Rechts3,Fs);
MiddenCo1 = MelFreqCoef(Midden1,Fs);
MiddenCo2 = MelFreqCoef(Midden2,Fs);
MiddenCo3 = MelFreqCoef(Midden3,Fs);
LinksCo1 = MelFreqCoef(Links1,Fs);
LinksCo2 = MelFreqCoef(Links2,Fs);
LinksCo3 = MelFreqCoef(Links3,Fs);
WoordCo = MelFreqCoef(Woord,Fs);

%Perform DTW comparions on these feature vectors
[rechtsPath1, IsRechts1] = warpMe(RechtsCo1, WoordCo);
[rechtsPath2, IsRechts2] = warpMe(RechtsCo2, WoordCo);
[rechtsPath3, IsRechts3] = warpMe(RechtsCo3, WoordCo);

[middenPath1, IsMidden1] = warpMe(MiddenCo1, WoordCo);
[middenPath2, IsMidden2] = warpMe(MiddenCo2, WoordCo);
[middenPath3, IsMidden3] = warpMe(MiddenCo3, WoordCo);

[linksPath1, IsLinks1] = warpMe(LinksCo1, WoordCo);
[linksPath2, IsLinks2] = warpMe(LinksCo2, WoordCo);
[linksPath3, IsLinks3] = warpMe(LinksCo3, WoordCo);

LinksDists = [IsLinks1, IsLinks2, IsLinks3];
RechtsDists = [IsRechts1, IsRechts2, IsRechts3];
MiddenDists = [IsMidden1, IsMidden2, IsMidden3];


%Find the least distances and classify the word from these exemplars (3NN)
distWords = sort([IsRechts1, IsRechts2, IsRechts3, IsMidden1, IsMidden2,...
    IsMidden3, IsLinks1, IsLinks2, IsLinks3]);

if sum(ismember(LinksDists,distWords(1:3))) > 1 %If values in e.g. LinksDists and RechtsDists happen to be exactly the same this approach doesnt work!
    disp('Het woord was: Links!')
elseif sum(ismember(RechtsDists, distWords(1:3))) > 1
    disp('Het woord was: Rechts!')
elseif sum(ismember(MiddenDists, distWords(1:3))) > 1
    disp('Het woord was: Midden!')
else
    disp('Er is geen duidelijkheid over het woord.')
end
    
    


%% We Still Have To Keep Utterances In Mind That Are Not Links Midden Rechts!
