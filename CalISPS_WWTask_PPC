% CalISPS_WWTask_PPC.m
%
% Estimate the inter-subject phase synchronization during a empathy task using PPC approach
%
% Wutao LOU
% <wlou@cuhk.edu.hk>
% Last updated 23 May, 2022
%==================================
clear,clc;
myDir = '\WW_Task_ISPS_TCs\';
SF1 = dir([myDir,'Con*']);
SF2 = dir([myDir,'Exp*']);

nROI = 5;
nLen = 261;

%% Step01: Reorganize the data from txt to mat and band-pass filtered using a butterworth filter
SF(1:length(SF1))= SF1;
SF(length(SF1)+(1:length(SF2)))=SF2;

% Bandpass filter settings
TR = 2;
FreBand = [0.04 0.07];% frequency band
