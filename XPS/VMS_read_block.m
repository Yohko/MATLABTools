%Licence: GNU General Public License version 2 (GPLv2)
function data = VMS_read_block(fid, includew,exp_mode,exp_var_cnt, scan_mode,blk_fue, comment, count)%, param.cor_var, param)%,impname, dfSave)
    global param
    x_start = 0.0;
    x_step = 0.0;
    x_name = '';
    tmps = '';
    excenergy = 0;
    dwelltime = 1;
    scancount = 1;
    tech_modes = {'AES diff','AES dir','EDX','ELS','FABMS','FABMS energy spec','ISS','SIMS','SIMS energy spec','SNMS','SNMS energy spec','UPS','XPS','XRF'};

    blockid = fgetl(fid);
    sampleid = fgetl(fid);
    if includew(1)
        comment = sprintf('%s\nyear: %s',comment,fgetl(fid));
    end
    if includew(2)
        comment = sprintf('%s\nmonth: %s',comment,fgetl(fid));
    end
    if includew(3)
        comment = sprintf('%s\nday: %s',comment,fgetl(fid));
    end
    if includew(4)
        comment = sprintf('%s\nhour: %s',comment,fgetl(fid));
    end
    if includew(5)
        comment = sprintf('%s\nminute: %s',comment,fgetl(fid));
    end
    if includew(6)
        comment = sprintf('%s\nsecond: %s',comment,fgetl(fid));
    end
    if includew(7)
        comment = sprintf('%s\nno. of hours in advanced GMT: %s',comment,fgetl(fid));
    end
    cmt_lines = 0;
    if includew(8) % skip comments on this block
        cmt_lines = str2double(fgetl(fid));
        if (~(isnumeric(cmt_lines)) || isnan(cmt_lines))
            disp('Error opening Vamas file (cmt_lines)!');
            data = {};
            return;
       end
        for i=1:cmt_lines
            tmps = fgetl(fid);
            if(length(tmps) == 0)
                %disp('Unexpected end of VMS-file.');
                %return;
            end
            comment = sprintf('%s\nspectra comment #%s: %s',comment,num2str(i),tmps);
        end
    end
    tech = '';
    if includew(9)
        tech = fgetl(fid);
        comment = sprintf('%s\ntech: %s',comment, tech);
        if(~any(startsWith(tech_modes, tech)))
            fprintf('Tech mode has an invalid value: %s\n',tech);
        end
    end
    if includew(10)
        if (strcmp('MAP',exp_mode) || strcmp('MAPDP',exp_mode))
            comment = sprintf('%s\nx coordinate: %s',comment,fgetl(fid));
            comment = sprintf('%s\ny coordinate: %s',comment,fgetl(fid));
        end
    end
    if includew(11)
        for i=1:exp_var_cnt
            comment = sprintf('%s\nexperimental variable value %s: %s',comment,num2str(i),fgetl(fid));
        end
    end
    if includew(12)
        comment = sprintf('%s\nanalysis source label: %s',comment,fgetl(fid));
    end
    if includew(13)
        if (strcmp('MAPDP',exp_mode) || strcmp('MAPSVDP',exp_mode) || ...
            strcmp('SDP',exp_mode) || strcmp('SDPSV',exp_mode) || ...
            strcmp('SNMS energy spec',tech) || strcmp('FABMS',tech) || ...
            strcmp('FABMS energy spec',tech) || strcmp('ISS',tech) || ...
            strcmp('SIMS',tech) || strcmp('SIMS energy spec',tech) || ...
            strcmp('SNMS',tech))
            comment = sprintf('%s\nsputtering ion or atom atomic number: %s',comment,fgetl(fid));
            comment = sprintf('%s\nnumber of atoms in sputtering ion or atom particle: %s',comment,fgetl(fid));
            comment = sprintf('%s\nsputtering ion or atom charge sign and number: %s',comment,fgetl(fid));
        end
    end
    if includew(14)
        excenergy =  str2double(fgetl(fid));
        comment = sprintf('%s\nanalysis source characteristic energy: %s',comment, num2str(excenergy));
    end
    if includew(15)
        comment = sprintf('%s\nanalysis source strength: %s',comment,fgetl(fid));
    end
    if includew(16)
        comment = sprintf('%s\nanalysis source beam width x: %s',comment,fgetl(fid));
        comment = sprintf('%s\nanalysis source beam width y: %s',comment,fgetl(fid));
    end
    if includew(17)
        if (strcmp('MAP',exp_mode) || strcmp('MAPDP',exp_mode) || ...
            strcmp('MAPSV',exp_mode)  || strcmp('MAPSVDP',exp_mode) || ...
            strcmp('SEM',exp_mode))
            param.FOV_x = str2double(fgetl(fid));
            param.FOV_y = str2double(fgetl(fid));
            comment = sprintf('%s\nfield of view x: %s',comment,num2str(param.FOV_x));
            comment = sprintf('%s\nfield of view y: %s',comment,num2str(param.FOV_y));
        end
    end
    if includew(18)
        if (strcmp('SEM',exp_mode) || strcmp('MAPSV',exp_mode) || ...
            strcmp('MAPSVDP',exp_mode))
            param.first_start_x = str2double(fgetl(fid));
            param.first_start_y = str2double(fgetl(fid));
            param.first_end_x = str2double(fgetl(fid));
            param.first_end_y = str2double(fgetl(fid));
            param.last_end_x = str2double(fgetl(fid));
            param.last_end_y = str2double(fgetl(fid));
            comment = sprintf('%s\nFirst Line Scan Start X-Coordinate: %s',comment,num2str(param.first_start_x));
            comment = sprintf('%s\nFirst Line Scan Start Y-Coordinate: %s',comment,num2str(param.first_start_y));
            comment = sprintf('%s\nFirst Line Scan Finish X-Coordinate: %s',comment,num2str(param.first_end_x));
            comment = sprintf('%s\nFirst Line Scan Finish Y-Coordinate: %s',comment,num2str(param.first_end_y));
            comment = sprintf('%s\nLast Line Scan Finish X-Coordinate: %s',comment,num2str(param.last_end_x));
            comment = sprintf('%s\nLast Line Scan Finish Y-Coordinate: %s',comment,num2str(param.last_end_y));
        end
    end
    if includew(19)
        comment = sprintf('%s\nanalysis source polar angle of incidence: %s',comment,fgetl(fid));
    end
    if includew(20)
        comment = sprintf('%s\nanalysis source azimuth: %s',comment,fgetl(fid));
    end
    if includew(21)
        comment = sprintf('%s\nanalyser mode: %s',comment,fgetl(fid));
    end
    if includew(22)
        comment = sprintf('%s\nanalyser pass energy or retard ratio or mass resolution: %s',comment,fgetl(fid));
    end
    if includew(23)
        if strcmp('AES diff',tech)
            comment = sprintf('%s\ndifferential width: %s',comment,fgetl(fid));
        end
    end
    if includew(24)
        comment = sprintf('%s\nmagnification of analyser transfer lens: %s',comment,fgetl(fid));
    end
    % QAZ semantics of next element depends on technique
    if includew(25)
        comment = sprintf('%s\nanalyser work function or acceptance energy of atom or ion: %s',comment,fgetl(fid));
    end
    if includew(26)
        comment = sprintf('%s\ntarget bias: %s',comment,fgetl(fid));
    end
    if includew(27)
        comment = sprintf('%s\nanalysis width x: %s',comment,fgetl(fid));
        comment = sprintf('%s\nanalysis width y: %s',comment,fgetl(fid));
    end
    if includew(28)
        comment = sprintf('%s\nanalyser axis take off polar angle: %s',comment,fgetl(fid));
        comment = sprintf('%s\nanalyser axis take off azimuth: %s',comment,fgetl(fid));
    end
    if includew(29)
        comment = sprintf('%s\nspecies label: %s',comment,fgetl(fid));
    end
    if includew(30)
        comment = sprintf('%s\ntransition or charge state label: %s',comment,fgetl(fid));
        comment = sprintf('%s\ncharge of detected particle: %s',comment,fgetl(fid));
    end
    if includew(31)
        if strcmp('REGULAR',scan_mode)
            x_name =  fgetl(fid);
            comment = sprintf('%s\nabscissa label: %s',comment,x_name);
            comment = sprintf('%s\nabscissa units: %s',comment,fgetl(fid));
            x_start = str2double(fgetl(fid));
            x_step = str2double(fgetl(fid));
        else
            param.cor_var = str2double(fgetl(fid));
            if (isnan(param.cor_var) || param.cor_var == 0)
                disp('Error opening Vamas file (cor_var)!');
                data = {};
                return;
            end
            x_name =  fgetl(fid);
            comment = sprintf('%s\nabscissa label: %s',comment,x_name);
            comment = sprintf('%s\nabscissa units: %s',comment,fgetl(fid));
            for i=1:(param.cor_var-1)
                comment = sprintf('%s\nName Col%s: %s',comment,num2str(i),fgetl(fid));
                fgetl(fid); % corresponding variable unit
            end
            includew(32) = 0;
        end
    else
        disp('How to find abscissa properties in this file?');
    end    
    if includew(32)
        param.cor_var = str2double(fgetl(fid));
        if isnan(param.cor_var)
            disp('Error opening Vamas file (cor_var)!');
            data = {};
            return;
        end
        %inclusionlist[40] = param.cor_var
        % columns initialization
        for i=1:param.cor_var
            comment = sprintf('%s\nName Col%s: %s',comment,num2str(i),fgetl(fid));            
            fgetl(fid); % corresponding variable unit
        end
    end
    if includew(33)
        comment = sprintf('%s\nsignal mode: %s',comment,fgetl(fid));
    end
    if includew(34)
        dwelltime =  str2double(fgetl(fid));
        comment = sprintf('%s\nsignal collection time: %s',comment,num2str(dwelltime));
    end
    if includew(35)
        scancount =  str2double(fgetl(fid));
        comment = sprintf('%s\n# of scans to compile this blk: %s',comment,num2str(scancount));
    end
    if includew(36)
        comment = sprintf('%s\nsignal time correction: %s',comment,fgetl(fid));
    end
    if includew(37)
        if (( strcmp('AES diff',tech) || strcmp('AES dir',tech) || ...
                strcmp('EDX',tech) || strcmp('ELS',tech) || ...
                strcmp('UPS',tech) || strcmp('XPS',tech) || ...
                strcmp('XRF',tech)) && ( strcmp('MAPDP',exp_mode) ||  ...
                strcmp('MAPSVDP',exp_mode) || strcmp('SDP',exp_mode) ||  strcmp('SDPSV',exp_mode)))
            comment = sprintf('%s\nSputtering Source Energy: %s',comment,fgetl(fid));
            comment = sprintf('%s\nSputtering Source BeamCurrent: %s',comment,fgetl(fid));
            comment = sprintf('%s\nSputtering Source WidthX: %s',comment,fgetl(fid));
            comment = sprintf('%s\nSputtering Source WidthY: %s',comment,fgetl(fid));
            comment = sprintf('%s\nSputtering Source PolarAngle Of Incidence: %s',comment,fgetl(fid));
            comment = sprintf('%s\nSputtering Source Azimuth: %s',comment,fgetl(fid));
            comment = sprintf('%s\nSputtering Mode: %s',comment,fgetl(fid));
        end
    end
    if includew(38)
        comment = sprintf('%s\nsample normal polar angle of tilt: %s',comment,fgetl(fid));
        comment = sprintf('%s\nsample normal polar tilt azimuth: %s',comment,fgetl(fid));
    end
    if includew(39)
        comment = sprintf('%s\nsample rotate angle: %s',comment,fgetl(fid));
    end
    if includew(40)
        n = str2double(fgetl(fid)); % # of additional numeric parameters
        for i=1:n
            % 3 items in every loop: param_label, param_unit, param_value
            param_label =  fgetl(fid);
            param_unit =  fgetl(fid);
            param_value =  fgetl(fid);
            comment = sprintf('%s\n%s: %s %s',comment, param_label, param_value, param_unit);
        end
    end
    for i=1:blk_fue
        fgetl(fid);
    end
    cur_blk_steps = str2double(fgetl(fid));
    if(cur_blk_steps == 0)
       data = {};
       return; 
    end
    for i=1:(2*param.cor_var) % min & max ordinate
        fgetl(fid);
    end
    tmpd=0;
    xdim=0;
    ydim=0;
    if (param.first_end_x>=param.last_end_x)
        xdim = param.first_end_x;
    else
        xdim = param.last_end_x;
    end
    if (param.first_end_y>=param.last_end_y)
        ydim = param.first_end_y;
    else
        ydim = param.last_end_y;
    end
    xdim = xdim-(param.first_start_x-1);
    ydim = ydim-(param.first_start_y-1);
    
	% TODO speed up reading here
    switch scan_mode
        case 'MAPPING'
            if (xdim*ydim ~= cur_blk_steps)
                disp('Error. xdim*ydim != cur_blk_steps.')
                data = {};
                return;
            end
            ycols = zeros(xdim,ydim);
            for j=1:xdim
                for i=1:ydim
                    ycols(j,i)=str2double(fgetl(fid));
                end
            end
        otherwise
            col = 1;
            n = 1;
            ycols = zeros(cur_blk_steps/param.cor_var,param.cor_var+1);
            if (strcmp('UPS',tech) ||  strcmp('XPS',tech)) 
                if strcmp(x_name,'Kinetic Energy')
                    if ~(param.f_vsEkin)
                        if ~(param.f_posEbin)
                            ycols(:,1) = x_start-excenergy:x_step:x_start-excenergy+(cur_blk_steps/param.cor_var-1)*x_step;
                        else
                            ycols(:,1) = -1*(x_start-excenergy:x_step:x_start-excenergy+(cur_blk_steps/param.cor_var-1)*x_step);
                        end
                     else
                        ycols(:,1) = x_start:x_step:x_start+(cur_blk_steps/param.cor_var-1)*x_step;
                    end
                elseif strcmp(x_name,'Binding Energy')
                    if ~(param.f_vsEkin)
                        if ~(param.f_posEbin)
                            ycols(:,1) = -1*(x_start:x_step:x_start+(cur_blk_steps/param.cor_var-1)*x_step);
                        else
                            ycols(:,1) = x_start:x_step:x_start+(cur_blk_steps/param.cor_var-1)*x_step;
                        end
                    else
                        ycols(:,1) = excenergy-x_start:x_step:excenergy-x_start+(cur_blk_steps/param.cor_var-1)*x_step;
                    end
                %elseif strcmp(x_name,'time of day')
                else
                    ycols(:,1) = x_start:x_step:x_start+(cur_blk_steps/param.cor_var-1)*x_step;
                end
            else
                ycols(:,1) = x_start:x_step:x_start+(cur_blk_steps/param.cor_var-1)*x_step;
            end

            for i=1:cur_blk_steps
                tmpd=str2double(fgetl(fid));
                if isnan(tmpd)
                    % some VMS files have empty lines here, CasaXPS still loads these files properly
                    disp('Error in countlist, trying to skip line!');
                    tmpd=str2double(fgetl(fid));
                end
                ycols(n,1+col)=tmpd;
                if(feof(fid))
                    disp('Unexpected end of VMS-file (reading data).');
                    data = {};
                    return;
                end
                col = 1+mod(col,param.cor_var);
                n = (i+2-mod(i,param.cor_var))/param.cor_var;
            end
            
            
            if param.f_divbyNscans
                ycols(:,2:end)=ycols(:,2:end)/scancount;
            end
            if param.f_divbytime
                ycols(:,2:end) = ycols(:,2:end)/dwelltime;
            end         
    end
    data = {sampleid; blockid; ycols; comment; scan_mode; exp_mode; tech};
end
