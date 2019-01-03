%Licence: GNU General Public License version 2 (GPLv2)
function spectra = RIXS_dload()
    [FileNamecell,PathName,Fileindex] = uigetfile({'*.txt;*.TXT', '1D RIXS ASCII'},'Select 1D RIXS TXT file','MultiSelect', 'on');
	spectra = struct([]);
    if(Fileindex == 0)
        return;
    end
	FileName = char(FileNamecell); % convert from cell to string list
    for i=1:size(FileName,1)
        [~,name,~] = fileparts(FileName(i,:));
        filetoopen = stripstrfirstlastspaces(sprintf('%s%s',PathName,FileName(i,:)));
        fid=fopen(filetoopen);
        data = RIXS_1Dtxtload(fid);
        fclose(fid);
        fclose all;
        if i > 1
            spectra = [spectra, data(:,2)];
        else
            spectra = data(:,2);
        end
    end
end
