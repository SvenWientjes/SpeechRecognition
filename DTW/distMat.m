function plotobject = distMat(Matrix)
%% This function automatically creates a nice plot of a distance matrix:
% It is written for the BachelorThesis Gesture and Speech coordination
% supervised by Lisette Hoekstra. The goal for it is to be used within
% a simple speech recognition script.

imagesc(Matrix) %Should invert the y-axis...
set(gca, 'YDir', 'normal')
hold on
colorbar
