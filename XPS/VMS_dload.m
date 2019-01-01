%Licence: GNU General Public License version 2 (GPLv2)
%load multiple VAMAS ASCII files
function spectraVMS = VMS_dload()
    spectraVMS = struct([]);
    [FileNamecell,PathName,Fileindex] = uigetfile({'*.vms;*.VMS', 'VAMAS'},'Select a VAMAS file','MultiSelect', 'on');
    if(Fileindex == 0)
        return;
    end
    FileName = char(FileNamecell); % convert from cell to string list
    for i=1:size(FileName,1)
        [~,name,~] = fileparts(FileName(i,:));
        fid=fopen(stripstrfirstlastspaces(sprintf('%s%s',PathName,FileName(i,:))),'r');
        fprintf('Loading file: %s\n',name);
        data = VMS_load_data(fid);
        fclose(fid);
        if i > 1
            spectraVMS = [spectraVMS, struct('filename',name,'data',data)];
        else
            spectraVMS = struct('filename',name,'data',data);
        end
    end
end
