function [f] = plotSolution(Problems,varargin)
%PLOTSOLUTION Given a problem, plots the mesh results x,c.
%Returns the figure
%init empty opts
opts=[];

% Handle optional variables to function.
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
        %varargins available
        if ischar(varargin(1))
            extraFcn=varargin{1};
        else
            extraFcn=varargin{2};
        end
else
    extraFcn='@(aa) 0;';
end

%Sets the defaults for this function and overrides any with user set options.
plotSolutionDefaults; 

%Set whether to display figure.
if (isfield(opts,'displaytype') && opts.displaytype==false)
    f = figure('visible','off','Name',fname);
else
    f = figure('visible','on');
end

hold on

for i=1:size(Problems,2) %Loop through each problem and plot the results.
x=Problems{i}.mesh.nvec;
y=Problems{i}.c';
plot(x,y,nodePlot{i}); % Plot with the graphing options set in PlotOptions.nodePlot
end
eval(extraFcn); % Run the extra functions passed in with extraFcn
title(plotTitle);
xlabel(xlabel_title);
ylabel(ylabel_title);

% Get legends from PlotOpts via plotDefaults.
if iscell(legend_text)
    legend(legend_text,'Location',legend_pos, 'Interpreter','latex');
end
if(isfield(opts,'filepath'))
    saveas(f,opts.filepath); % Save to filepath if specified.
end

end

