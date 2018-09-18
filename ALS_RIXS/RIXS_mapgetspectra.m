%Licence: GNU General Public License version 2 (GPLv2)
function data = RIXS_mapgetspectra(fid)
    h=fgetl(fid);
    subdir=fgetl(fid); % subdirectory for data
    scantype = fgetl(fid);
    skiplines = 0;
    offset = 0;
    if(strcmp(scantype,'Scan Type: One Motor, Start, Stop, Increment') == 1)
        skiplines = 11;
        offset = 1;
    elseif(strcmp(scantype,'Scan Type: One Motor From File') == 1)
        skiplines = 9;
    end    
    for i=1:skiplines
        h=fgetl(fid);
    end
    h = fgetl(fid);
    header = textscan(h,'%s','delimiter','\t');
    cols = size(header{1},1)+offset;
    y1 = textscan(fid,'%s','delimiter','\t','emptyvalue', NaN);
    rows = size(y1{1},1)/cols;
    y =[reshape(y1{1},[cols,rows])]';
    data = {subdir;header;y};
end
