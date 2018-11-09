folder=fileparts(which(mfilename));
addpath(genpath(folder));
rmpath('.git');
rmpath('src/deprecated');