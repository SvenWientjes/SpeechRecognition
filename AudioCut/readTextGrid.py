#This is a python 3.6 script that reads a .txt file as a string. It serves to extract a list from a TextGrid
#file made by Praat. The list represents the starting or ending times of words, depending on whether the
#TextGrid is the one that contains the starting markers or the ending markers.

#This script could be extended to also contain the participant number and to code for the fact whether the 
#output list is actually the starting or ending time list. It depends on what the slicing script needs
#and on how we want to represent our data in the end.

#Read the TextGrid .txt file
with open('D:/PythonProgs/Speech Recognition/TestTextGrid_End.txt', 'r') as myfile:
	data=myfile.readlines()
	#use this to open the TextGrid file you want to extract the time list of

#Remove all the ugly \n that we get from the readlines() command
for idx in range(len(data)):
	data[idx] = data[idx].replace('\n', '')

#Extract the line from the txt file that should give us the number of placed markers
for line in data:
	if 'xmax' in line:
		nMarks = [int(s) for s in line.split() if s.isdigit()]
nMarks = int(nMarks[0]) #Save it as int object instead of int in list

#Fill a list with all the times of the markers -> list is ordered from first to last marker
timeList = [None] * nMarks
for word in range(nMarks): #nMarks[0] because nMarks is a list, [0] extracts the first element, which is the integer representing the numbers of placed markers
	for idx in range(len(data)):
		if 'points ['+str(word+1)+']' in data[idx]:
			timeList[word] = float(data[idx+1].split()[2])

#timeList now contains a list of all the times as floating point values. We can iterate over this list and combine
#it with the other list (one is of starting times, the other of stopping times) -> we can then automatically
#have the times we want to use in Python! Splitting the audio file up by times can be done automatically then.

#If we rename timeList to startList and copy the commands above to here, use it to open the complementary
#TextGrid that codes for the ends, and call the list output there endList, we have the two objects necessary
#to code for the times we should split the audio signal into.

#The rest of the audio splitting script can be pasted below, slightly modified to iterate over the two lists
#called startList and endList.



