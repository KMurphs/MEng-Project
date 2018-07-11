Utilities Downloaded from: 
https://www.mathworks.com/matlabcentral/fileexchange/38641-reading-and-saving-of-data-in-the-edf+



From the comments section:

Günther Müller
2 May 2018

Important: You really need to change one line of the code to make it work. 
1. Download 
2. Put the downloaded files into a folder ( directory of the folder should not change) 
2. Change one line of the code (have a look at the comment of Victor (21 Jun 2015)) 
3. Add the directory of the folder to Matlab (fastest way: -> 'Set Path' Button (beneath preferences) -> add folder -> choose the directory of your folder

After fixing that bug, it's a great edf reader!




Victor
21 Jun 2015

THERE IS AN ERROR IN:

Rs=cumsum([1; header.duration*header.samplerate]); % строка индексов подблоков каналов Rs(k):Rs(k+1)-1

PLEASE FIX IT TO:

Rs=cumsum([1; header.samplerate]); % строка индексов подблоков каналов Rs(k):Rs(k+1)-1

Since header.samplerate is not a sampling frequency, but Nr of samples in one epoch, which can be more than 1 second.
