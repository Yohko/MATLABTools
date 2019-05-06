%Licence: GNU General Public License version 2 (GPLv2)
% plots VMS data and returns array of graphics objects (lines, image..) and
% sample and block ID
function retval = VMS_plotspectra(data, filenum, spectranum, fitparam)
    VMS_options; % load settings from file
    retval = {};
    h = 0;
    plotcount = 0;
    sampleID = "";
    blockID = "";
    % check if selected file is valid
    if(size(data,2)<filenum || filenum < 1)
        disp('filenum not valid');
       return; 
    end
    % check if selected spectra is valid
    if(size(data(filenum).data,1)<spectranum || spectranum < 1)
        disp('spectranum not valid');
       return; 
    end
    plotdata = data(filenum).data(spectranum).spectrum;
    xdata = plotdata(:,1);
    ydata = plotdata(:,2);

    hold on;

    if(fitparam(1))
        % get calibration
        for ii=1:size(data(filenum).data(spectranum).calib,1)
            calib = data(filenum).data(spectranum).calib(ii);
            tmp = textscan(calib, "%s", 'delimiter',' ');
            switch tmp{1}{1}
                case 'Calib'
                    shift = str2double(tmp{1}{7})-str2double(tmp{1}{4});
                    xdata = xdata-shift;
            end
        end
        
        % calculate background
        %BG = ydata;
        BG = zeros(length(xdata),1);
        for ii=1:size(data(filenum).data(spectranum).region,1)
            region = data(filenum).data(spectranum).region(ii);
            tmp = textscan(region, "%s", 'delimiter','*');
            tmp = tmp{1}{4};
            tmp = textscan(tmp, "%s", 'delimiter','(');
            switch tmp{1}{1}
                case 'Shirley'
                    BG = BG+VMS_region_Shirley(region,xdata,ydata,data(filenum).data(spectranum).excenergy);
                case 'Offset Shirley'
                    BG = BG+VMS_region_OffsetShirley(region,xdata,ydata,data(filenum).data(spectranum).excenergy);
            end
        end
        idx = find(BG == 0);
        BG(idx) = ydata(idx);
        plot(xdata, BG);
    end
    
    % plot style depends on scanmode
    switch data(filenum).data(spectranum).scanmode
        case 'MAPPING'
            plotcount = plotcount + 1;
            h(plotcount) = imagesc(plotdata);
            sampleID(plotcount) = string(data(filenum).data(spectranum).sampleID);
            blockID(plotcount) = string(data(filenum).data(spectranum).blockID);
        case 'REGULAR'
            if(fitparam(1))
                plotcount = plotcount + 1;
                %h = plot(xdata,plotdata(:,2)/plotdata(:,3));
                h(plotcount) = plot(xdata,plotdata(:,2),'o');
                sampleID(plotcount) = string(data(filenum).data(spectranum).sampleID);
                blockID(plotcount) = string(data(filenum).data(spectranum).blockID);
            else
                plotcount = plotcount + 1;
                h(plotcount) = plot(xdata,plotdata(:,2));
                sampleID(plotcount) = string(data(filenum).data(spectranum).sampleID);
                blockID(plotcount) = string(data(filenum).data(spectranum).blockID);
            end
        otherwise
            plotcount = plotcount + 1;
            h(plotcount) = plot(xdata,plotdata(:,2));
            sampleID(plotcount) = string(data(filenum).data(spectranum).sampleID);
            blockID(plotcount) = string(data(filenum).data(spectranum).blockID);
    end
    
    % plot components
    if(fitparam(1)==2)
        for ii=1:size(data(filenum).data(spectranum).comp,1)
            comp = data(filenum).data(spectranum).comp(ii);
            tmp = textscan(comp, "%s", 'delimiter','*');
            tmp = tmp{1}{4};
            tmp = textscan(tmp, "%s", 'delimiter','(');
            tmp=tmp{1}{1};
            switch tmp
                case 'GL'
                    ydata = VMS_comp_GL(comp,xdata,data(filenum).data(spectranum).excenergy);
                    plotcount = plotcount + 1;
                    h(plotcount) = plot(xdata,BG+ydata);
                    sampleID(plotcount) = string(data(filenum).data(spectranum).sampleID);
                    blockID(plotcount) = string(data(filenum).data(spectranum).blockID);
            end
        end
    end
    hold off;    
    retval = {sampleID; blockID; h};
end
