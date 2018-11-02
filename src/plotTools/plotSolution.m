function [f] = plotSolution(Problems,varargin)
%PLOTSOLUTION Given a problem, plots the mesh results x,c.
%Returns the figure
%init empty opts
opts=[];

if (size(varargin,2)==2)
        %varargins available
        %See if number 1 is a func. If not it should be opts.
        if ischar(varargin(1))
            opts=varargin{2};
            extraFcn=varargin{1};
        else
            opts=varargin{1};
            extraFcn=varargin{2};
        end
elseif (size(varargin,2)==1)
        if ischar(varargin(1))
            extraFcn=varargin{1};
        else
            extraFcn=varargin{2};
        end
else
    extraFcn='@(aa) 0;';
end


plotSolutionDefaults; %Sets the defaults for this function and overrides any with user set options.

%Set whether to display figure.
if (isfield(opts,'displaytype') && opts.displaytype==false)
    f = figure('visible','off','Name',fname);
else
    f = figure('visible','on');
end

hold on

for i=1:size(Problems,2)
x=Problems{i}.mesh.nvec;
y=Problems{i}.c';
plot(x,y,nodePlot{i});
end
eval(extraFcn);
title(plotTitle);
xlabel(xlabel_title);
ylabel(ylabel_title);
if iscell(legend_text)
    legend(legend_text,'Location',legend_pos);
end
if(isfield(opts,'filepath'))
saveas(f,opts.filepath);
end

end

