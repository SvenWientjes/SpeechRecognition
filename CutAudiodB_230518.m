clear all; close all;
prefix='Y:\student\LowCost\gmw\lisettehoekstra\Dataset Beweging\BT 1718\cutaudio\';
trial1=1;
cond=input('Welke conditie? (1=basis 2=random) ');
sbj=input('Welke ppn? (1 .. ) ');
if cond==1 sbjlst=[2 4 5 7 10 12 14 18 20 23 24 26 28 29 32 34 37 39 41 43 45 47 49 52 54 56 57 59];
elseif cond==2 sbjlst=[1 3 6 8 15 16 17 19 21 22 25 27 30 31 33 36 38 40 42 44 46 48 50 51 53 55];
end


%for sbj=1:length(sbjlst),
    
% %% Input data
% fileID=fopen([prefix 'subject_dB_' num2str(sbjlst(sbj)) '.txt'], 'r'); %dit nog zo maken dat de loop weer werkt, zodat alle ppn in 1 keer kunnen
% Audiodata=textscan(fileID, '%s');
% for i=1:length(Audiodata) dataPP(:,i)=Audiodata{i}; end
% fclose(fileID);
% 
% for i=[1]
%     for j=trial1:size(dataPP,1)
%         [token remain]=strtok(dataPP{i},'"'); datadB(j-trial1+1,i)=str2num(token); clear token remain
%     end
% end

% time en dB inlezen
file_sbj = ['subject_dB_' num2str(sbjlst(sbj)) '.txt']
T = readtable([file_sbj]);
A = table2array(T);
time = A(1:2:end,:);
dB = A(2:2:end,:);

% checken of time en dB evenveel waarden bevatten, en anders corrigeren
n1 = numel(time);
n2 = numel(dB);

disp(['time: ' num2str(n1)]);
disp(['dB: ' num2str(n2)]); 

cor = input ('Zelfde lengte? (0 = zelfde, 1 = time > dB, 2 = dB > time)');

if cor == 1 time(end)=[]; 
elseif cor == 2 dB(end)=[];
elseif cor == 0 time=time; dB=dB;
end

% verhouding tussen volgende en vorige dB-waardes berekenen + verschuiven
ratio_dB1 = dB(2:end)./dB(1:end-1);
ratio_dBn1 = ratio_dB1.';
ratio_dBn1 = [0 ratio_dBn1];
ratio_dB1 = ratio_dBn1.';

% verhouding tussen vorige en volgende dB-waardes berekenen
ratio_dB2 = dB(1:end-1)./dB(2:end);
ratio_dBn2 = ratio_dB2.';
ratio_dBn2 = [ratio_dBn2 0];
ratio_dB2 = ratio_dBn2.';

% alles in 1 matrix, met 3 kolommen
ts_dB = [time(:),dB(:),ratio_dB1(:),ratio_dB2(:)];

% rijen verwijderen waarbij ratio_dB1 > 1 en ratio_dB2 < 1
% op die manier gaat de toename van dal tot piek niet meer geleidelijk,
% maar in 1 keer

index = find((ts_dB(:,3) > 1) & (ts_dB(:,4) < 1));
ts_dB(index,:)=[];

% verschil tussen opeenvolgende dB-waardes berekenen
dB2 = ts_dB(:,2);

diff_dB2 = diff(dB2);
diff_dB2n = diff_dB2.';
diff_dB2n = [0 diff_dB2n];
diff_dB2 = diff_dB2n.';
ts_dB = [ts_dB diff_dB2];

% verhouding tussen volgende en vorige dB-waardes berekenen
ratio_dB3 = dB2(2:end)./dB2(1:end-1);
ratio_dBn3 = ratio_dB3.';
ratio_dBn3 = [ratio_dBn3 0];
ratio_dB3 = ratio_dBn3.';
ts_dB = [ts_dB ratio_dB3];

% ratio_dB1 en ratio_dB2 verwijderen
ts_dB(:,3:4) = [];

% kleine toenames in ts_dB verwijderen
index2 = find((ts_dB(:,3)>0) & (ts_dB(:,3)<1) & (ts_dB(:,4)<1));
ts_dB(index2,:) = [];

% nieuwe verhoudingen tussen volgende en vorige dB-waardes berekenen
ts_dB(:,4) = [];
dB3 = ts_dB(:,2);

ratio_dB4 = dB3(2:end)./dB3(1:end-1);
ratio_dBn4 = ratio_dB4.';
ratio_dBn4 = [ratio_dBn4 0];
ratio_dB4 = ratio_dBn4.';
ts_dB = [ts_dB ratio_dB4];

% verhoudingen die kleiner dan lim (limit) zijn verwijderen
lim=input('Welke limiet? (=>1, lagere limiet = vaker knippen) ');

if lim < 1
    lim=input('Welke limiet? (=>1, lagere limiet = vaker knippen) ');
else
    cuttime = [ts_dB(:,1) , ts_dB(:,4)];
    index2 = find(cuttime(:,2) < lim);
    cuttime(index2,:)=[];

    eps = [1:length(cuttime)].';
    cuttime = [cuttime, eps];

% verhoudingen-kolom weg
    cuttime_2 = cuttime;
    cuttime_2(:,2) = [];
end

disp(cuttime_2);

for k = 1:100
loop_lim = input ('Nog eens een limiet bepalen om cuttime te berekenen? (1 = ja, 2 = nee) ');

if loop_lim == 1
    lim=input('Welke limiet? (=>1, lagere limiet = vaker knippen) ');

    if lim < 1
        lim=input('Welke limiet? (=>1, lagere limiet = vaker knippen) ');
    else
        cuttime = [ts_dB(:,1) , ts_dB(:,4)];
        index2 = find(cuttime(:,2) < lim);
        cuttime(index2,:)=[];

        eps = [1:length(cuttime)].';
        cuttime = [cuttime, eps];

    % verhoudingen-kolom weg
        cuttime_2 = cuttime;
        cuttime_2(:,2) = [];
    end
    
    disp(cuttime_2);
elseif loop_lim > 1
    break
end
end

write2csv = input ('Wil je cuttime naar een .csv bestand schrijven? (1 = ja, 2 = nee) ');

if write2csv == 1
    filename = ['cutaudio_subject-' num2str(sbjlst(sbj)) '_lim-' num2str(lim) '.csv'];
    csvwrite([filename],cuttime_2);
else
    disp('Geen .csv bestand opgeslagen.')
end