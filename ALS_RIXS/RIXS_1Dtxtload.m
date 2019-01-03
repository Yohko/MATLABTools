%Licence: GNU General Public License version 2 (GPLv2)
function y1 = RIXS_1Dtxtload(fid)
    for i=1:10 % skip lines
        h = fgetl(fid);
    end
    cols = 2;
    y = textscan(fid,'%f','delimiter','\t','emptyvalue', NaN);
    rows = size(y{1},1)/cols; % 2048 for full detector
    y =[reshape(y{1},[cols,rows])]';
    y1 = y;
end
