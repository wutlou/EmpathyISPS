clear,clc;

ISPSDir = '\WW_Task_ISPS\';
HRFConvDir = '\Task_HRF_Conv_Model\SPMFiles_HRFConv\';

nROI = 5;
SF = dir([ISPSDir,'Con*']);

for i=1:length(SF)
    
    load([HRFConvDir,SF(i).name,'/',SF(i).name,'_HRFConv_Run1.mat']);
    load([HRFConvDir,SF(i).name,'/',SF(i).name,'_HRFConv_Run2.mat']);
    load([HRFConvDir,SF(i).name,'/',SF(i).name,'_HRFConv_Run3.mat']);
    
    X1 = [ones(261,1),HRF1(:,1:2)];
    X2 = [ones(261,1),HRF2(:,1:2)];
    X3 = [ones(261,1),HRF3(:,1:2)];
    
    clear HRF1 HRF2 HRF3
    
    load([ISPSDir,SF(i).name,'/',SF(i).name,'_Task1_ROITC_bf3_BP004_007_ISPS.mat']);
    for r1 = 1:nROI
        for r2 = 1:nROI
            y = squeeze(ISBPS_WithinCon(r1,r2,:));
            b = regress(y,X1);
            Run1_b(r1,r2,:) = b(2:end);
            
            clear y b
        end
    end
    
    clear ISBPS_WithinCon
    
    
    
    load([ISPSDir,SF(i).name,'/',SF(i).name,'_Task2_ROITC_bf3_BP004_007_ISPS.mat']);
    for r1 = 1:nROI
        for r2 = 1:nROI
            y = squeeze(ISBPS_WithinCon(r1,r2,:));
            
            b = regress(y,X2);
            Run2_b(r1,r2,:) = b(2:end);
            
            clear y b
        end
    end
    
    clear ISBPS_WithinCon

    
    
	load([ISPSDir,SF(i).name,'/',SF(i).name,'_Task3_ROITC_bf3_BP004_007_ISPS.mat']);
    for r1 = 1:nROI
        for r2 = 1:nROI
            y = squeeze(ISBPS_WithinCon(r1,r2,:));            
            b = regress(y,X3);
            Run3_b(r1,r2,:) = b(2:end);
            
            clear y b
        end
    end
    
        clear ISBPS_WithinCon

    
    SFName = [ISPSDir,SF(i).name,'/',SF(i).name,'_ISPS_GLM.mat'];
    save(SFName,'Run1_b','Run2_b','Run3_b');
    clear X1 X2 X3 SFName 
    clear Run1_b Run2_b Run3_b 
end

    

%% Exp
SF = dir([ISPSDir,'Exp*']);

for i=1:length(SF)
    
    load([HRFConvDir,SF(i).name,'/',SF(i).name,'_HRFConv_Run1.mat']);
    load([HRFConvDir,SF(i).name,'/',SF(i).name,'_HRFConv_Run2.mat']);
    load([HRFConvDir,SF(i).name,'/',SF(i).name,'_HRFConv_Run3.mat']);
    
    X1 = [ones(261,1),HRF1(:,1:2)];
    X2 = [ones(261,1),HRF2(:,1:2)];
    X3 = [ones(261,1),HRF3(:,1:2)];
    
    clear HRF1 HRF2 HRF3
    
    load([ISPSDir,SF(i).name,'/',SF(i).name,'_Task1_ROITC_bf3_BP004_007_ISPS.mat']);
    for r1 = 1:nROI
        for r2 = 1:nROI
            y = squeeze(ISBPS_WithinExp(r1,r2,:));
            
            b = regress(y,X1);
            Run1_b(r1,r2,:) = b(2:end);
            
            clear y b
        end
    end
    
    clear ISBPS_WithinExp
    
    
    
    load([ISPSDir,SF(i).name,'/',SF(i).name,'_Task2_ROITC_bf3_BP004_007_ISPS.mat']);
    for r1 = 1:nROI
        for r2 = 1:nROI
            y = squeeze(ISBPS_WithinExp(r1,r2,:));
            
            b = regress(y,X2);
            Run2_b(r1,r2,:) = b(2:end);
            
            clear y b
        end
    end
    
    clear ISBPS_WithinExp

    
    
	load([ISPSDir,SF(i).name,'/',SF(i).name,'_Task3_ROITC_bf3_BP004_007_ISPS.mat']);
    for r1 = 1:nROI
        for r2 = 1:nROI
            y = squeeze(ISBPS_WithinExp(r1,r2,:));
            
            b = regress(y,X3);
            Run3_b(r1,r2,:) = b(2:end);
            
            clear y b
        end
    end
    
        clear ISBPS_WithinExp

    
    SFName = [ISPSDir,SF(i).name,'/',SF(i).name,'_ISPS_GLM.mat'];
    save(SFName,'Run1_b','Run2_b','Run3_b');
    clear X1 X2 X3 SFName 
    clear Run1_b Run2_b Run3_b
end
