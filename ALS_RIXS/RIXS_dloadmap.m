%Licence: GNU General Public License version 2 (GPLv2)
function spectra = RIXS_dloadmap()
    [FileNamecell,PathName,Fileindex] = uigetfile({'*.txt;*.TXT', '1D RIXS ASCII'},'Select 1D RIXS TXT file','MultiSelect', 'off');
    FileName = char(FileNamecell); % convert from cell to string list
    spectra = struct([]);
    if(Fileindex == 0)
        return;
    end
	filetoopen = stripstrfirstlastspaces(sprintf('%s%s',PathName,FileName(1,:)));
	fid=fopen(filetoopen);
    data = RIXS_mapgetspectra(fid);
    fclose(fid);
    fclose all;
    subdir = data{1};
    header = data{2};
    fileinfos = data{3};
    rows = size(fileinfos,1);
    cols = size(fileinfos,2);
    offset = 0;
    if(size(header)~=cols)
        offset = 1;
    end
    photonenergy = zeros(rows,1);
    for i=1:rows
        tmp = fileinfos(i,2+offset);
        photonenergy(i) = str2double(tmp{1});
        tmp = fileinfos(i,end);
        filename = sprintf('%s%s/%s-1D.txt',PathName,subdir,tmp{1});
        fid=fopen(filename);
        data = RIXS_1Dtxtload(fid);
        fclose(fid);
        fclose all;
        if i > 1
            spectra = [spectra, data(:,2)];
        else
            spectra = data(:,2);
        end
    end
    emissionenergy = 1:size(data,1);%RIXS_calcenergy();
    spectra = {photonenergy;emissionenergy(1:size(data,1));spectra};
end
