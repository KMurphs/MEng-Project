%EDFFilePath    = "https://www.physionet.org/pn4/eegmmidb/S001/S001R01.edf";
%Press "ctrl + C" to abort
%'This message is sent at time %s\n', datestr(now,'yyyy/mm/dd HH:MM:SS.FFF')
%datestr(now,'yyyy/mm/dd HH:MM:SS.FFF')
EDFFilePath    = 'https://www.physionet.org/pn4/eegmmidb/';


%%
Status = datestr(now,'yyyy/mm/dd HH:MM:SS.FFF') + 'Downloading Subjects Information...';
disp(Status);
%Get Files addresses
Anchor = '<img src="/icons/folder.gif" alSt="[DIR]" width="20" height="22">';
%Note that strings are in single quote not like in other languages where
%double quotes are used.
%Apparently cannot open internet files. Need to download first
%[data, header] = ReadEDF(EDFFilePath);

WebsiteData = webread(EDFFilePath);
TempIndex   = strfind(WebsiteData,Anchor);
WebsiteData = extractAfter(WebsiteData,TempIndex(1)-1);

SubjectsRepository  = [];
Temp_Start          = '<a href="';
Temp_End            = '">S';
Indexes_Start       = strfind(WebsiteData,Temp_Start);
Indexes_End         = strfind(WebsiteData,Temp_End);
NIndexes            = size(Indexes_Start);


for Index = 1:NIndexes(2)-2
    Temp                = extractBetween(WebsiteData, Indexes_Start(Index) + length(Temp_Start), Indexes_End(Index) - 1);
    SubjectsRepository  = [SubjectsRepository, strcat(EDFFilePath, string(Temp))];
    % SubjectsRepository(1) = "https://www.physionet.org/pn4/eegmmidb/S001/"
end


Status = datestr(now,'yyyy/mm/dd HH:MM:SS.FFF') + 'Downloading Subjects Files Information...';
disp(Status);
Anchor = '<img src="/icons/unknown.gif" alt="[   ]" width="20" height="22">';
Files  = [];
for Index = 1:length(SubjectsRepository)
    Status          = '\nDownloading Subject ' + string(Index) + ' Files Information...';
    disp(Status);
    SubjectWebData  = webread(SubjectsRepository(Index));
    TempIndex       = strfind(SubjectWebData,Anchor);
    SubjectWebData  = extractAfter(SubjectWebData,TempIndex(1)-1);
    Temp_Start      = '<a href="';
    Temp_End        = '">S';
    Indexes_Start   = strfind(SubjectWebData,Temp_Start);
    Indexes_End     = strfind(SubjectWebData,Temp_End);
    NIndexes        = size(Indexes_Start);
    
    for SubIndex = 1:NIndexes(2)-1
        Temp        = extractBetween(SubjectWebData, Indexes_Start(SubIndex) + length(Temp_Start), Indexes_End(SubIndex) - 1);
        disp(string(Temp));
        Files       = [Files, strcat(SubjectsRepository(Index), Temp)];
        % Files(1) = "https://www.physionet.org/pn4/eegmmidb/S001/S001R01.edf"
    end
end


%%
%Download all files

Status = 'Downloading Files...';
disp(Status);
BaseRepository                   = 'C:\MEng Thesis\Dataset (physionet.org-pn4-eegmmidb)\RawData\';
Errors = [];
for Index = 1:length(Files)
    [FileURL, FileName, FileExtension] = fileparts(Files(Index));
    FileName                           = BaseRepository + FileName + FileExtension;
    Status                             = string(Index) + '/' +string(length(Files)) + ': Downloading File ' + string(FileName) + '... ';
    disp(Status);
    
    try
        websave(FileName, Files(Index));
    catch ME
        switch ME.identifier
            case 'MATLAB:webservices:Timeout'
                warning('Error occured while downloading file at Index '+ string(Index));
                Errors = [Errors, Index];
            otherwise
                error(ME.identifier, ME.identifier);
                rethrow(ME)
        end
    end
end

%Re-Download failed files
for Index = 1:length(Errors)
    [FileURL, FileName, FileExtension] = fileparts(Files(Errors(Index)));
    FileName                           = BaseRepository + FileName + FileExtension;
    Status                             = string(Index) + '/' +string(length(Errors)) + ': Downloading File ' + string(FileName) + '... ';
    disp(Status);
    
    try
        websave(FileName, Files(Errors(Index)));
    catch ME
        switch ME.identifier
            case 'MATLAB:webservices:Timeout'
                warning('Error occured while downloading file at Index '+ string(Errors(Index)));
                Errors = [Errors, Errors(Index)];
            otherwise
                error(ME.identifier, ME.identifier);
                rethrow(ME)
        end
    end
end

DownloadedFiles = dir(BaseRepository);
%There are 2 extra entries in the DownloadedFiles variables '.','..'
if(length(DownloadedFiles) - 2  == length(Files))
    disp('Download completed successfully!');
else
    disp('Download did not fully complete!');
end