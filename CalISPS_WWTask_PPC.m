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
NyqF = 1/(2*TR);
Wn = FreBand./NyqF;
[bfilter, afilter] = butter(3, Wn);%3-order butterworth filter
clear FreBand NyqF Wn


for i=1:length(SF)
    cd([myDir,SF(i).name]);
    for k=1:3
        KF = dir([myDir,SF(i).name,'\Task',num2str(k),'\*Task*.txt']);
        for j=1:length(KF)
            tmptc = load([myDir,SF(i).name,'\Task',num2str(k),'\',KF(j).name]);
            bptmptc= filtfilt(bfilter, afilter, tmptc);
%             TaskROITC(:,j) = zscore(tmptc);
            BPTaskROITC(:,j) = zscore(bptmptc);
            clear tmptc bptmptc;
        end
%         ROITCName = [SF(i).name,'_Task',num2str(k),'_ROITC.mat'];
        BPROITCName = [SF(i).name,'_Task',num2str(k),'_ROITC_BP004_007.mat'];
%         save(ROITCName,'TaskROITC');
        save(BPROITCName,'BPTaskROITC');
        clear KF BPTaskROITC TaskROITC ROITCName BPROITCName;
    end
    cd ..
end

            
            
%% Step02:Calcuate the intersubject phase synchronization Con
for k=1:3
    fprintf('======Calculate ISPS for Run %d of the Control group...\n',k);
    % For task k, calcaluate the intersubject phase synchronization for Con
    for i=1:length(SF1)
        fprintf('======  %d th subject: %s...\n',i,SF1(i).name);

        current_tcdata = load([myDir,SF1(i).name,'\',SF1(i).name,'_Task',num2str(k),'_ROITC_BP004_007.mat']);
        current_tc = current_tcdata.BPTaskROITC;
        clear current_tcdata;
        for r=1:nROI
        	 current_phase(:,r)= hilbert(current_tc(:,r));

        end
        
        %% withingroup PS for Con
        ConISIdx = 1:length(SF1);
        ConISIdx(i) = [];
        
        absAngDist = zeros(nROI,nROI,nLen);
        for j=1:length(ConISIdx)
            tmpIS_tcdata = load([myDir,SF1(ConISIdx(j)).name,'\',SF1(ConISIdx(j)).name,'_Task',num2str(k),'_ROITC_BP004_007.mat']);
            tmpIS_tc = tmpIS_tcdata.BPTaskROITC;
            clear tmpIS_tcdata;
            
            for r=1:nROI
                  tmpIS_phase(:,r)= hilbert(tmpIS_tc(:,r));
            end
            
            for r1 = 1:nROI
                for r2 = 1:nROI

                    y1 = current_phase(:,r1);
                    y2 = tmpIS_phase(:,r2);
                    
                    absAngDist(r1,r2,:) = squeeze(absAngDist(r1,r2,:))+abs(angle(y1.*conj(y2)));
                    clear y1 y2
                end
            end
            
            clear tmpIS_tc tmpIS_phase
            
        end
 
        ISBPS_WithinCon = 1-(absAngDist./length(ConISIdx))/pi;
        clear ConISIdx absAngDist;
        clear current_tc current_phase
        
        SFName = [SF1(i).name,'_Task',num2str(k),'_ROITC_BP004_007_ISPS.mat'];
        save(SFName,'ISBPS_WithinCon');
    end
end



%% Step02:Calcuate the intersubject phase synchronization Exp
for k=1:3
    fprintf('======Calculate ISPS for Run %d of the Exptrol group...\n',k);
    % For task k, calcaluate the intersubject phase synchronization for Exp
    for i=1:length(SF2)
        fprintf('======  %d th subject: %s...\n',i,SF2(i).name);

        current_tcdata = load([myDir,SF2(i).name,'\',SF2(i).name,'_Task',num2str(k),'_ROITC_BP004_007.mat']);
        current_tc = current_tcdata.BPTaskROITC;
        clear current_tcdata;
        for r=1:nROI
        	 current_phase(:,r)= hilbert(current_tc(:,r));

        end
        
        %% withingroup PS for Exp
        ExpISIdx = 1:length(SF2);
        ExpISIdx(i) = [];
        
        absAngDist = zeros(nROI,nROI,nLen);
        for j=1:length(ExpISIdx)
            tmpIS_tcdata = load([myDir,SF2(ExpISIdx(j)).name,'\',SF2(ExpISIdx(j)).name,'_Task',num2str(k),'_ROITC_BP004_007.mat']);
            tmpIS_tc = tmpIS_tcdata.BPTaskROITC;
            clear tmpIS_tcdata;
            
            for r=1:nROI
                  tmpIS_phase(:,r)= hilbert(tmpIS_tc(:,r));

            end
            
            for r1 = 1:nROI
                for r2 = 1:nROI
                    y1 = current_phase(:,r1);
                    y2 = tmpIS_phase(:,r2);
                    absAngDist(r1,r2,:) = squeeze(absAngDist(r1,r2,:))+abs(angle(y1.*conj(y2)));
                    clear y1 y2
                end
            end
            
            clear tmpIS_tc tmpIS_phase
            
        end
 
        ISBPS_WithinExp = 1-(absAngDist./length(ExpISIdx))/pi;
        clear ExpISIdx absAngDist;
        clear current_tc current_phase
        
        SFName = [SF2(i).name,'_Task',num2str(k),'_ROITC_BP004_007_ISPS.mat'];
        save(SFName,'ISBPS_WithinExp');
    end
end
