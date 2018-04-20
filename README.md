# SpeechRecognition

This repository holds programs designed to perform parts of simple speech recognition. It is designed for a thesis in which three words will have to be recognized ('Links', 'Midden', 'Rechts'). 

# How to test the current version:

1. Download all the files in the master branch
2. Place them all in the same folder
3. Move to that folder using MATLAB
4. Load up WordClassificationScript.m
5. Simply click the run button
6. In the command window a printed string will tell you what it thinks the unknown word is
7. Three plots appear: they are the Dynamic Time Warping paths of least cost. The title of the plot states which word it belongs to.
8. Change the audioread() call for 'Woord =' at line 11 to any other soundbite from this master branch
9. Check if classification is correct
