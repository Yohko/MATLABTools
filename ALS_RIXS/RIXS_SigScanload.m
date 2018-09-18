%Licence: GNU General Public License version 2 (GPLv2)
function y = RIXS_SigScanload(fid)
    h=fgetl(fid);
    [month, day, year] = strread(h, 'Date: %d/%d/%d');
	h=fgetl(fid); %empty line
    h=fgetl(fid); %empty line
    if(strcmp(h,'From File') == 1)
        disp('from file');
        for i=1:12
            h=fgetl(fid);
        end
    elseif(strcmp(h,'Start, Stop, Increment') == 1)
        disp('Start, Stop, Increment');
        for i=1:11
            h=fgetl(fid);
        end
    end
    h=fgetl(fid); % header
    header = textscan(h,'%s','delimiter','\t');
    cols = size(header{1},1);
    y1 = textscan(fid,'%f','delimiter','\t','emptyvalue', NaN);
    rows = size(y1{1},1)/cols;
    y =[reshape(y1{1},[cols,rows])]';
end
