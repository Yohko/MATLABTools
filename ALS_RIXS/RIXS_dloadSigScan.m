%Licence: GNU General Public License version 2 (GPLv2)
function spectra = RIXS_dloadSigScan()
    [FileNamecell,PathName,Fileindex] = uigetfile({'*.txt;*.TXT', 'SigScan ASCII'},'Select SigScan TXT file','MultiSelect', 'on');
    FileName = char(FileNamecell); % convert from cell to string list
    spectra = struct([]);
    if(Fileindex == 0)
        return;
    end
    for i=1:size(FileName,1)
        [~,name,~] = fileparts(FileName(i,:));
        filetoopen = stripstrfirstlastspaces(sprintf('%s%s',PathName,FileName(i,:)));
        fid=fopen(filetoopen);
        data = RIXS_SigScanload(fid);
        fclose(fid);
        fclose all;
        if i > 1
            spectra = [spectra, data];
        else
            spectra = data;
        end
    end
end
