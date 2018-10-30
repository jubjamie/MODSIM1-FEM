function [f] = plotSolution(Problem,varargin)
%PLOTSOLUTION Given a problem, plots the mesh results x,c.
%Returns the figure
%init empty opts
opts=[];

if(size(varargin,1)>0)
%varargins available
%Number 1 is opts.
opts=varargin{1};
end

plotSolutionDefaults; %Sets the defaults for this function and overrides any with user set options.

%Set whether to display figure.
if (isfield(opts,'displaytype') && opts.displaytype==false)
    f = figure('visible','off','Name',fname);
else
    f = figure('visible','on');
end

x=Problem.mesh.nvec;
y=Problem.c';
p=plot(x,y,nodePlot);
title(plotTitle);
xlabel(xlabel_title);
ylabel(ylabel_title);
if(isfield(opts,'filepath'))
saveas(f,opts.filepath);
end

end

