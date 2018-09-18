%Licence: GNU General Public License version 2 (GPLv2)
function poselastic = RIXS_findelesticchannel(data, start,range)
    % data: RIXS map
    % start: position of elastic channel in first spextra in px
    % range: box search range in px
    numspec = size(data,2);
    poselastic = zeros(numspec,1);
    for i=1:numspec
        tmp = data(start-range:start+range,i);
        [~, I] = max(tmp);
        I = start-range+I-1;
        start = I;
        poselastic(i) = I;
    end
end

