%Set name of figure or default.
if (isfield(opts,'name'))
    fname=opts.name;
else
    fname='FEM Figure';
end

%Set plot option for nodes
if (isfield(opts,'nodePlot'))
    nodePlot=opts.nodePlot;
    if (~isfield(opts.nodePlot,'LineStyle'))
    nodePlot.LineStyle='-';
    end
    if (~isfield(opts.nodePlot,'Color'))
    nodePlot.Color='r';
    end
    if (~isfield(opts.nodePlot,'Marker'))
    nodePlot.Marker='o';
    end
    if (~isfield(opts.nodePlot,'MarkerEdgeColor'))
    nodePlot.MarkerEdgeColor='k';  
    end
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