%% DESCRIPTION
%  Entry point. Launches the Octave Filter Designer GUI.
%% INPUTS
%  none
%% OUTPUTS
%  none — opens a figure window

pkg load signal;

root = fileparts(mfilename('fullpath'));
addpath(fullfile(root, 'src', 'design'));
addpath(fullfile(root, 'src', 'validation'));
addpath(fullfile(root, 'src', 'plots'));
addpath(fullfile(root, 'src', 'ui'));
addpath(fullfile(root, 'src', 'callbacks'));

build_main_window();
