%Licence: GNU General Public License version 2 (GPLv2)
function y = plot_VMSreport(data, colors,scaling,seq)
    % data: use 'import_VMSreport(file)'
    % scaling(1) switch normalization mode
    % scaling(2) y-scaling
    % scaling(3) y-offset
    % scaling(4) x-offset
    % colors: color of sectra, e.g. [1,0,0;1,0,0;1,0.67,0;1,0.67,0;0,0,1;0,0,1]
    % seq: sequence of spectra when plotted, e.g.[5,6,3,4,1,2]

    dataplot = cell2mat(data(2));
    dataplot = dataplot';
    switch scaling(1)
        case 0
        case 1 % 0 .. 1 scale
            dataplot(3:end,:) = dataplot(3:end,:)-min(min(dataplot(3:end,:)));
            dataplot(3:end,:) = dataplot(3:end,:)/max(max(dataplot(3:end,:)));
        case 2 % sub min, scale with factor
            dataplot(3:end,:) = dataplot(3:end,:)-min(min(dataplot(3:end,:)));
            dataplot(3:end,:) = dataplot(3:end,:)*scaling(2);
        case 3 % sub min
            dataplot(3:end,:) = dataplot(3:end,:)-min(min(dataplot(3:end,:)));
        case 4     % 0 .. 1 scale, only 3-CPS will be plotted
            dataplot(3:end,:) = dataplot(3:end,:)-min(min(dataplot(3:end,:)));
            dataplot(3:end,:) = dataplot(3:end,:)/max(max(dataplot(3:end,:)));
    end
    dataplot(3:end,:) = dataplot(3:end,:)+scaling(3);
    dataplot(2,:) = dataplot(2,:)+scaling(4);
    
    % 1 KE
    % 2 BE
    % 3 CPS
    % n-1 BG
    % n Envelope
    
    n = size(dataplot,1);
    BG = dataplot(n-1,:);
    
    hold on;
    if scaling(1)==4
        plot(dataplot(2,:),dataplot(3,:),'color','black','Linewidth',1);
    else
        plot(dataplot(2,:),BG);
        for i=4:n-2
            if(size(seq,2)<(i-3))
                j=i;
            else
                j = 3+seq(i-3);
            end
            if(size(colors,1)<(j-3))
                color = [1 1 1];
            else
                color = colors(j-3,:);
            end
            inBetween = [dataplot(j,:), fliplr(BG)];
            fill([dataplot(2,:), fliplr(dataplot(2,:))], inBetween, color);
        end
        plot(dataplot(2,:),dataplot(3,:),'o', 'color','black','MarkerSize',3);
    end
    hold off;
end
