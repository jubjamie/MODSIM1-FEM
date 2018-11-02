%Set name of figure or default.
if (isfield(opts,'name'))
    fname=opts.name;
else
    fname='FEM Figure';
end

nodePlot=cell(1,size(Problems,2));
%Set plot option for nodes
if (isfield(opts,'nodePlot'))
    for j=1:size(Problems,2)
        nodePlot{j}=opts.nodePlot;
        if (~isfield(opts.nodePlot,'LineStyle'))
            nodePlot{j}.LineStyle='-';
            elseif (isfield(opts.nodePlot,'LineStyle') && size(opts.nodePlot.LineStyle,1)>1)
            nodePlot{j}.LineStyle=opts.nodePlot.LineStyle{j};
        else
            nodePlot{j}.LineStyle=opts.nodePlot.LineStyle;
        end
        
        if (~isfield(opts.nodePlot,'Color'))
            nodePlot{j}.Color='r';
        elseif (isfield(opts.nodePlot,'Color') && size(opts.nodePlot.Color,1)>1)
            nodePlot{j}.Color=opts.nodePlot.Color{j};
        else
            nodePlot{j}.Color=opts.nodePlot.Color;
        end
        
        if (~isfield(opts.nodePlot,'Marker'))
            nodePlot{j}.Marker='o';
            elseif (isfield(opts.nodePlot,'Marker') && size(opts.nodePlot.Marker,1)>1)
            nodePlot{j}.Marker=opts.nodePlot.Marker{j};
        else
            nodePlot{j}.Marker=opts.nodePlot.Marker;
        end
        
        if (~isfield(opts.nodePlot,'MarkerEdgeColor'))
            nodePlot{j}.MarkerEdgeColor='k';
            elseif (isfield(opts.nodePlot,'MarkerEdgeColor') && size(opts.nodePlot.MarkerEdgeColor,1)>1)
            nodePlot{j}.MarkerEdgeColor=opts.nodePlot.MarkerEdgeColor{j};
        else
            nodePlot{j}.MarkerEdgeColor=opts.nodePlot.MarkerEdgeColor;
        end
    end
else
    for j=1:size(Problems,2)
    nodePlot{j}.LineStyle='-';
    nodePlot{j}.Color='r';
    nodePlot{j}.Marker='o';
    nodePlot{j}.MarkerEdgeColor='k'; 
    end
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

%Set legend
if (isfield(opts,'legend'))
    legend_text=opts.legend.labels;
    if (isfield(opts.legend,'pos'))
        legend_pos=opts.legend.pos;
    else
        legend_pos='southwest';
    end
else
    legend_text=false;
end