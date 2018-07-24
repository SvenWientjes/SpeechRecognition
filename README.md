# SpeechRecognition

This repository holds programs designed to perform parts of simple speech recognition. It is designed for a thesis in which three words will have to be recognized ('Links', 'Midden', 'Rechts'). 

# How to test the current version:

1. Download all the files in the master branch
2. Place them all in the same folder. Make sure you can access the sound files from your working directory.
3. Move to that folder using MATLAB (set as wd)
4. Load up WordClassificationScript.m for 1NN or WordClassKnn.m for 3NN (can easily be extended to more or less)
5. In the audioread() commands under 'Loading the Signals': change the path to the folder you placed the exemplar files in
6. Simply click the run button
7. In the command window a printed string will tell you what it thinks the unknown word is
8. Three plots appear: they are the Dynamic Time Warping paths of least cost. The title of the plot states which word it belongs to.
9. Change the audioread() call for 'Woord =' at under 'Loading the Signals' to any other soundbite in your folder to test if it can be classified (this is the _test pattern_)
10. Check if classification is correct!
