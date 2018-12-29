%Licence: GNU General Public License version 2 (GPLv2)
%import CasaXPS report file
function data = import_VMSreport(file)
    fid=fopen(file);
    for i=1:3
        fgetl(fid);
    end %ignore first 3 lines
    
	h=fgets(fid); % column names
	columnnames = strsplit(h,'\t')';
	tmp = strsplit(h,'\t');
    cols = size(tmp,2);
    if(isempty(char(tmp(1,end))) == 1)
       cols = cols -1; 
    end
    y= textread(file,'%s','delimiter','\t','headerlines',4,'emptyvalue', NaN);
    y=str2double(y);
    rows = size(y,1)/cols;
    y = [reshape(y,cols,rows)]';
    y1 = {columnnames; y};
    fclose(fid);
    data = y1;
end
