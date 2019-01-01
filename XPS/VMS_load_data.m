%Licence: GNU General Public License version 2 (GPLv2)
function data = VMS_load_data(fid)
    global param
    param = struct;
    % ### Settings ########################################################
    param.f_vsEkin = false; % x-axis as kinetic energy?, else binding energy
    param.f_posEbin = false; % positive binding energy?
    param.f_divbyNscans = true;
    param.f_divbytime = true;
    param.f_includeTF = false;
    % ### Settings ########################################################
    param.first_end_x = 0;
    param.last_end_x = 0;
    param.first_end_y = 0;
    param.last_end_y = 0;
    param.first_start_x = 0;
    param.first_start_y = 0;
    param.cor_var = 0; % # of corresponding variables

    exp_modes = {'MAP','MAPDP','MAPSV','MAPSVDP','NORM','SDP','SDPSV','SEM','NOEXP'};
    scan_modes = {'REGULAR','IRREGULAR','MAPPING'};
    
    % sometimes there are empty lines at the beginning
    % need to find the magic line
    while ~feof(fid)
        line = fgetl(fid);
        val = strcmp(line, 'VAMAS Surface Chemical Analysis Standard Data Transfer Format 1988 May 4');
        if(val == 1)
            %disp('Found beginning of standard Vamas file.');
            break 
        end
        if(val == 1)
            disp('Found beginning of non standard Vamas file. Trying to import!');
            break 
        end
        if(feof(fid))
            data = 0;
            return ;
        end
    end
    %comment = '';
    comment = sprintf('institution identifier: %s',fgetl(fid)); % institution identifier
    comment = sprintf('%s\ninstitution model identifier: %s',comment,fgetl(fid)); % institution model identifier
    comment = sprintf('%s\noperator identifier: %s',comment,fgetl(fid)); % operator identifier
    comment = sprintf('%s\nexperiment identifier: %s',comment,fgetl(fid)); % experiment identifier
    % 'n' comment lines
    n = str2double(fgetl(fid));
    for i=1:n
        comment = sprintf('%s\nheader comment #%s:%s',comment,num2str(i),fgetl(fid));
    end
    exp_mode = fgetl(fid);
    if(~any(startsWith(exp_modes, exp_mode)))
        fprintf('Exp mode has an invalid value: %s\n',exp_mode);
    end
    scan_mode = fgetl(fid);
    if(~any(startsWith( scan_modes,  scan_mode)))
        fprintf('Scan mode has an invalid value: %s\n',scan_mode);
    end
    
    %some exp_mode specific file-scope meta-info
    if (strcmp("MAP",exp_mode) || strcmp("MAPD",exp_mode) || strcmp("NORM",exp_mode) || strcmp("SDP",exp_mode))
        comment = sprintf('%s\nnumber of spectral regions: %s',comment,fgetl(fid));
    end

    if (strcmp("MAP",exp_mode) || strcmp("MAPD",exp_mode))
        comment = sprintf('%s\nnumber of analysis positions: %s',comment,fgetl(fid));
        param.discrete_xdim = fgetl(fid);
        param.discrete_ydim = fgetl(fid);
        comment = sprintf('%s\nnumber of discrete x coordinates available in full map: %s',comment,param.discrete_xdim);
        comment = sprintf('%s\nnumber of discrete y coordinates available in full map: %s',comment,param.discrete_ydim);
    end
    % experimental variables
    exp_var_cnt = str2double(fgetl(fid));
    for i = 1:exp_var_cnt
        comment = sprintf('%s\nexperimental variable label %s: %s',comment,num2str(i),fgetl(fid));
        comment = sprintf('%s\nexperimental variable unit %s: %s',comment,num2str(i),fgetl(fid));
    end
    
    
    % fill `include' table
    % This next line is a relic of an earlier version of the format.
    % In that version, this line contained an integer whose value indicated a number of optional features to follow.
    % In the current version of the standard, these optional features have been removed, so the value should always be 0.
    % Software which could read the old file format will therefore remain compatible with the new version, but
    % this VAMASParser will not be able to read the old file format, and must simply throw an exception if the
    % value is not 0.
    n = str2double(fgetl(fid)); % # of entries in inclusion or exclusion list
    if(n~=0)
        fprintf('Error reading VAMAS file; expected 0, read %s.\n',num2str(n));
        disp('Somehow a continuous mode which is not supported yet or very old VAMAS standard!');
    end
    d = ~(n>0);
    includew = ones(40,1);
    inclusionlist = d*ones(41,1);
    inclusionlist(41)=0;
    
    d = ~(d==1);
    if (n<0)
        n=-1*n;
    end
    for i=1:n
        idx = str2double(fgetl(fid));
        inclusionlist(idx) = d;
    end
    
    
    % # of manually entered items in block
    % list any manually entered items
    n = str2double(fgetl(fid));
    for i=1:n
        fgetl(fid)
    end

    
    % list any future experiment upgrade entries
    exp_fue = str2double(fgetl(fid));
    blk_fue = str2double(fgetl(fid));
    for i=1:exp_fue
        fgetl(fid)
    end

    %param.cor_var=0;
    % handle the blocks
    blk_cnt = str2double(fgetl(fid));
    data = struct([]);
    for i = 1:blk_cnt
        if(i==1)
            for j=1:40
                includew(j)=inclusionlist(j);
            end
        end
        blkdata = VMS_read_block(fid, includew,exp_mode,exp_var_cnt, scan_mode,blk_fue, comment,i);%, cor_var, param);
        
        if ~isempty(blkdata)
            if(i==1)
                data = struct('sampleID',blkdata(1),'blockID',blkdata(2),'spectrum',blkdata(3),'comment',blkdata(4),...
                    'scanmode',blkdata(5),'expmode',blkdata(6),'tech',blkdata(7));
            else
                data = [data;struct('sampleID',blkdata(1),'blockID',blkdata(2),'spectrum',blkdata(3),'comment',blkdata(4),...
                    'scanmode',blkdata(5),'expmode',blkdata(6),'tech',blkdata(7))];
            end
        else
            disp('Error reading block.');
            return;
        end
    end
end
