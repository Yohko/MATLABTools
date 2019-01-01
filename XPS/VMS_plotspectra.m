%Licence: GNU General Public License version 2 (GPLv2)
function retval = VMS_plotspectra(data, filenum, spectranum)
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
    % plot style depends on scanmode
    hold on;
    switch data(filenum).data(spectranum).scanmode
        case 'MAPPING'
            h = imagesc(plotdata);
        otherwise
            h = plot(plotdata(:,1),plotdata(:,2));
    end
    hold off; 
    % return sampleID and blockID
    retval = {string(data(filenum).data(spectranum).sampleID); string(data(filenum).data(spectranum).blockID); h};
end
