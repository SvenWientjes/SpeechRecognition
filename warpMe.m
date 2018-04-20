function [path, cost] = warpMe(ClassCoefs, SpeechCoefs)
%% Elementary DTW 
% This function uses the coefficient matrices from speech signals to
% calculate: distances -> accumulated costs -> optimal path (path) -> cost of
% optimal path (cost).
% Enter the exemplar first. The unlabeled data second!

%Build a huge distance matrix of Sum of Squares for the feature vectors
%between every speech index vs exemplar index
distances = zeros(length(ClassCoefs(:,1)), length(SpeechCoefs(:,1)));
for class = 1:length(ClassCoefs(:,1))
    for speech = 1:length(SpeechCoefs(:,1))
        rawDist = ClassCoefs(class,:) - SpeechCoefs(speech,:);
        difMC = sqrt(rawDist*rawDist');
        distances(class,speech) = difMC;
    end
end

%Build a similar matrix but for cumulative (lowest) cost of moving to a 
%certain position.
accum_cost = zeros(length(ClassCoefs(:,1)), length(SpeechCoefs(:,1))); %preallocate
accum_cost(1,1) = distances(1,1); %Always start at the bottom
% now move only to the right
for i = 2:length(SpeechCoefs(:,1))
    accum_cost(1,i) = distances(1,i) + accum_cost(1, i-1);
end
% now move only upward
for i = 2:length(ClassCoefs(:,1))
    accum_cost(i,1) = distances(i,1) + accum_cost(i-1, 1);
end
% now fill in the rest:
for i = 2:length(ClassCoefs(:,1))
    for j = 2:length(SpeechCoefs(:,1))
        accum_cost(i,j) = distances(i,j) + min([...
            accum_cost(i-1, j-1), accum_cost(i-1,j),...
            accum_cost(i,j-1)]);
    end
end

%Find the actual warping path with the lowest cost
path{1} = [length(SpeechCoefs(:,1)), length(ClassCoefs(:,1))];
pathIndex = 2;
cost = 0;
i = length(ClassCoefs(:,1));
j = length(SpeechCoefs(:,1));

while i>1 && j>1
    if i==1
        j = j-1;
    elseif j==1
        i = i-1;
    else
        if accum_cost(i-1, j) == min([accum_cost(i-1,j-1)...
                accum_cost(i-1, j), accum_cost(i,j-1)])
            i = i-1;
        elseif accum_cost(i, j-1) == min([accum_cost(i-1,j-1),...
                accum_cost(i-1, j), accum_cost(i,j-1)])
            j = j-1;
        else
            i = i-1;
            j = j-1;
        end
    end
    path{pathIndex} = [j i];
    pathIndex = pathIndex+1;
end
path{pathIndex} = [1 1];

%Extract the optimal path indices
path_x = zeros(length(path),1);
path_y = zeros(length(path),1);

for index = 1:length(path)
    path_x(index) = path{index}(1);
    path_y(index) = path{index}(2);
end

%Extract the cost of this optimal path
for place = 1:length(path_x)
    cost = cost + distances(path_y(place), path_x(place));
end

%Diagnostic plots
distMat(accum_cost)
hold on
plot(path_x, path_y)




