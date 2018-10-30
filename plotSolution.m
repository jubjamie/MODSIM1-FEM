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

%Set name of figure or default.
if (isfield(opts,'name'))
    fname=opts.name;
else
    fname='FEM Figure';
end

%Set plot option for nodes
if (isfield(opts,'nodePlot'))
    nodePlot=opts.nodePlot;
else
    nodePlot.LineStyle='-';
    nodePlot.Color='r';
    nodePlot.Marker='o';
    nodePlot.MarkerEdgeColor='k';    
end

%Set plot title
if (isfield(opts,'title'))
    plotTitle=opts.title;
else
    plotTitle='';
end

%Set xlabel
if (isfield(opts,'x') && isfield(opts.x,'label'))
    xlabel_title=opts.x.label;
else
    xlabel_title='';
end

%Set ylabel
if (isfield(opts,'y') && isfield(opts.y,'label'))
    ylabel_title=opts.y.label;
else
    ylabel_title='';
end

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

