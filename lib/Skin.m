function [Skin] = Skin()
%SKIN Return a Skin structure
%   Contains the required coeffs for different skin regions.
%TC = Thermal Conductivity Component
%HS = Heat Sink Component
%Tb = Blood Temperature
%Epidermis (0-E)
Skin.E.TC=25/(1200*3300);
Skin.E.HS=0;
Skin.E.xend=0.00166667;

%Dermis (E-D)
Skin.D.TC=40/(1200*3300);
Skin.D.HS=(0.0375*1060*3770)/(1200*3300);
Skin.D.Tb=310.15;
Skin.D.xend=0.005;

%Sub-Cutaneous (D-B)
Skin.SC.TC=20/(1200*3300);
Skin.SC.HS=(0.0375*1060*3770)/(1200*3300);
Skin.SC.Tb=310.15;
Skin.SC.xend=0.01;

Skin.B=Skin.SC;
end

