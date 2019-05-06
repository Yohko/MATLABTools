%Licence: GNU General Public License version 2 (GPLv2)
%load multiple VAMAS ASCII files
function spectraVMS = VMS_dload(inputfiles)
    if nargin < 1
        spectraVMS = struct([]);
        [FileNamecell,PathName,Fileindex] = uigetfile({'*.vms;*.VMS', 'VAMAS'},'Select a VAMAS file','MultiSelect', 'on');
        if(Fileindex == 0)
            return;
        end
        FileName = char(FileNamecell); % convert from cell to string list
    else
        FileName = inputfiles;
        PathName = '';
    end
    for ii=1:size(FileName,1)
        [~,name,~] = fileparts(FileName(ii,:));
        fid=fopen(stripstrfirstlastspaces(sprintf('%s%s',PathName,FileName(ii,:))),'r');
        fprintf('Loading file: %s\n',name);
        data = VMS_load_data(fid);
        fclose(fid);
        if ii > 1
            spectraVMS = [spectraVMS, struct('filename',name,'data',data)];
        else
            spectraVMS = struct('filename',name,'data',data);
        end
    end
end
