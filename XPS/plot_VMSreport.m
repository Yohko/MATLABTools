%License: GNU General Public License version 2 (GPLv2)
%function y = plot_VMSreport2(data, colors,scaling,seq,varargin)
function y = plot_VMSreport(data,varargin)
    % data: use 'import_VMSreport(file)'
    if ~exist('data','var')
      y = 0;
      return;
    end
    % colors: color of sectra, e.g. [1,0,0;1,0,0;1,0.67,0;1,0.67,0;0,0,1;0,0,1]
	colors = [0,0,0;0,0,0;0,0,0];% 1 BG, 2 envelope, 3 CPS
    % scaling(1) switch normalization mode
    % scaling(2) y-scaling
    % scaling(3) y-offset
    % scaling(4) x-offset
	scaling = [1,1,0,0];
    % seq: sequence of spectra when plotted, e.g.[5,6,3,4,1,2]
	seq = 1;
    f_envelope = false;
    v_envelope = 1;
    for i = 1:2:numel(varargin)
        if strcmp(varargin{i}, 'envelope')
            f_envelope = true;
            v_envelope = varargin{i+1};
            if (v_envelope <1)
                f_envelope = false;
            end
        elseif strcmp(varargin{i}, 'colors')
            colors = varargin{i+1};
        elseif strcmp(varargin{i}, 'xoffset')
            scaling(4) = varargin{i+1};
        elseif strcmp(varargin{i}, 'yoffset')
            scaling(3) = varargin{i+1};
        elseif strcmp(varargin{i}, 'yscale')
            scaling(2) = varargin{i+1};
        elseif strcmp(varargin{i}, 'seq')
            seq = varargin{i+1};
        elseif strcmp(varargin{i}, 'style')
            if strcmp(varargin{i+1}, 'submin')
                scaling(1) = 2;
            elseif strcmp(varargin{i+1}, 'zeroone')
                scaling(1) = 1;
            else
                scaling(1) = 0;
            end                
            scaling(1) = varargin{i+1};
        end
    end
    dataplot = cell2mat(data(2));
    dataplot = dataplot';
    switch scaling(1)
        case 0
        case 1 % 0 .. 1 scale
            dataplot(3:end,:) = dataplot(3:end,:)-min(min(dataplot(3:end,:)));
            dataplot(3:end,:) = dataplot(3:end,:)/max(max(dataplot(3:end,:)));
        case 2 % sub min
            dataplot(3:end,:) = dataplot(3:end,:)-min(min(dataplot(3:end,:)));
        case 4     % 0 .. 1 scale, only 3-CPS will be plotted
            dataplot(3:end,:) = dataplot(3:end,:)-min(min(dataplot(3:end,:)));
            dataplot(3:end,:) = dataplot(3:end,:)/max(max(dataplot(3:end,:)));
    end
    dataplot(3:end,:) = dataplot(3:end,:)*scaling(2);
    dataplot(3:end,:) = dataplot(3:end,:)+scaling(3);
    dataplot(2,:) = dataplot(2,:)+scaling(4);

    % 1 KE
    % 2 BE
    % 3 CPS
    % n-1 BG
    % n Envelope
    
    n = size(dataplot,1);
    BG = dataplot(n-1,:);
    Envelope = dataplot(n,:);
    
    hold on;
    if scaling(1)==4
        y = plot(dataplot(2,:),dataplot(3,:),'color',colors(3,:),'Linewidth',1);
    else
        plot(dataplot(2,:),BG,'color',colors(1,:),'Linewidth',1);
        for i=4:n-2
            if(size(seq,2)<(i-3))
                j=i;
            else
                j = 3+seq(i-3);
            end
            if(size(colors,1)<(j))
                color = [1 1 1];
            else
                color = colors(j,:);
            end
            inBetween = [dataplot(j,:), fliplr(BG)];
            fill([dataplot(2,:), fliplr(dataplot(2,:))], inBetween, color);
        end
        y = plot(dataplot(2,:),dataplot(3,:),'o', 'color',colors(3,:),'MarkerSize',3);
        if f_envelope
            plot(dataplot(2,:),Envelope,'-', 'color',colors(2,:),'Linewidth',v_envelope);%,'MarkerSize',3);
        end
    end
    hold off;
end
