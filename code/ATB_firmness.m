%% Silenced_firmness.xlsx
% empty>Kir(2), ATB-1>Kir(5) ATB-1>GFP(11)
% PU-1>Kir(13), PU-2>Kir(14), PU-1>GFP(15), PU-2>GFP(16)

opts = spreadsheetImportOptions("NumVariables", 5);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A1:E2788";

% Specify column names and types
opts.VariableNames = ["VarName3", "VarName4", "VarName5", "VarName6", "VarName7"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Import the data
Penedata = readtable("silenced_firmness.xlsx", opts, "UseExcel", false);
p = table2array(Penedata);

% Clear temporary variables
clear opts Penedata

conc = [.25 .5 .75 1.0 1.25 1.5 1.75];
%
mineggs = 1;

clear a maxn
g = 11; %ATB-1>GFP
for c = 1:6
    currg = find(p(:,1)==g & p(:,2) == conc(c));
    for cg = 1:length(currg)
        a(c).tot1(cg) = sum(p(currg(cg),3:5));
        if a(c).tot1(cg)>mineggs
            a(c).PI1(cg) = (2*p(currg(cg),3)+1*p(currg(cg),4))/(2*a(c).tot1(cg));
        else
            a(c).PI1(cg) = NaN;
        end
    end
end

g = 2; %empty>Kir
for c = 1:6
    currg = find(p(:,1)==g & p(:,2) == conc(c));
    for cg = 1:length(currg)
        b(c).tot1(cg) = sum(p(currg(cg),3:5));
        if b(c).tot1(cg)>mineggs
            b(c).PI1(cg) = (2*p(currg(cg),3)+1*p(currg(cg),4))/(2*b(c).tot1(cg));
        else
            b(c).PI1(cg) = NaN;
        end
    end
end

g = 5; %ATB-1>Kir
for c = 1:6
    currg = find(p(:,1)==g & p(:,2) == conc(c));
    for cg = 1:length(currg)
        d(c).tot1(cg) = sum(p(currg(cg),3:5));
        if d(c).tot1(cg)>mineggs
            d(c).PI1(cg) = (2*p(currg(cg),3)+1*p(currg(cg),4))/(2*d(c).tot1(cg));
        else
            d(c).PI1(cg) = NaN;
        end
    end
end

% IOSR, BOXPLOT
maxn = 0;
for k = 1:6
    maxn = max([maxn length(a(k).tot1) length(b(k).tot1) length(d(k).tot1)]);  
end

ioT = NaN*ones(maxn,6,3);
ioP = NaN*ones(maxn,6,3);
for k = 1:6
    ioT(1:length(a(k).tot1),k,1) = a(k).tot1';
    ioT(1:length(b(k).tot1),k,2) = b(k).tot1';
    ioT(1:length(d(k).tot1),k,3) = d(k).tot1';
    ioP(1:length(a(k).PI1),k,1) = a(k).PI1';
    ioP(1:length(b(k).PI1),k,2) = b(k).PI1';
    ioP(1:length(d(k).PI1),k,3) = d(k).PI1';
end

% Individual genotype plots (boxplot AND beehive)

figure('pos',[0.2594e+03 0.1474e+03 368 382.4000])
iosr.statistics.boxPlot(ioP(:,:,1),'theme','default','boxColor',[.3 .3 1],'medianColor',[0 0 0],'xSeparator',false,'symbolMarker','+','symbolColor','k');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
xticks(1)
xlabel('groups')
ylabel('P')
title('P1')

figure('pos',[0.2594e+03 0.1474e+03 368 382.4000])
iosr.statistics.boxPlot(ioP(:,:,2),'theme','default','boxColor',[.5 .5 .5],'medianColor',[0 0 0],'xSeparator',false,'symbolMarker','+','symbolColor','k');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
xticks(1)
xlabel('groups')
ylabel('P')
title('P2')

figure('pos',[0.2594e+03 0.1474e+03 368 382.4000])
iosr.statistics.boxPlot(ioP(:,:,3),'theme','default','boxColor',[1,.7 .3],'medianColor',[0 0 0],'xSeparator',false,'symbolMarker','+','symbolColor','k');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
xticks(1)
xlabel('groups')
ylabel('P')
title('P3')
ax1 = axis;
yticklabels({'0','10','20','30','40','50','0.6'})

figure('pos',[0.2594e+03 0.1474e+03 368 382.4000])
iosr.statistics.boxPlot(ioT(:,:,1),'theme','default','boxColor',[.3 .3 1],'medianColor',[0 0 0],'xSeparator',false,'symbolMarker','+','symbolColor','k');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
xticks(1)
xlabel('groups')
ylabel('T')
title('T1')
ax2 = axis;
yticklabels({'0','10','20','30','40','50','0.6'})

figure('pos',[0.2594e+03 0.1474e+03 368 382.4000])
iosr.statistics.boxPlot(ioT(:,:,2),'theme','default','boxColor',[.5 .5 .5],'medianColor',[0 0 0],'xSeparator',false,'symbolMarker','+','symbolColor','k');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
xticks(1)
xlabel('groups')
ylabel('T')
title('T2')
axis(ax2);
yticklabels({'0','10','20','30','40','50','0.6'})

figure('pos',[0.2594e+03 0.1474e+03 368 382.4000])
iosr.statistics.boxPlot(ioT(:,:,3),'theme','default','boxColor',[1,.7 .3],'medianColor',[0 0 0],'xSeparator',false,'symbolMarker','+','symbolColor','k');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
xticks(1)
xlabel('groups')
ylabel('T')
title('T3')
axis(ax2)

% %>>>>>>>>>>>>>>>>>>>>>>>>  beehive  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
for i = 1:3
    
    figure, plotSpread(squeeze(ioT(:,:,i)),'distributioncolors','k','distributionmarkers','o')
    set(gcf,'pos',[0.2594e+03 0.1474e+03 368 382.4000])
    ylabel('T')
    set(findall(gcf,'-property','FontSize'),'FontSize',12)
    xlabel('groups')
    axis(ax2)
    eval(sprintf('title(''T%1.0d'')',i))
    yticklabels({'0','10','20','30','40','50','0.6'})
    
    figure, plotSpread(squeeze(ioP(:,:,i)),'distributioncolors','k','distributionmarkers','o')
    set(gcf,'pos',[0.2594e+03 0.1474e+03 368 382.4000])
    ylabel('P')
    set(findall(gcf,'-property','FontSize'),'FontSize',12)
    xlabel('groups')
    axis(ax1)
    eval(sprintf('title(''P%1.0d'')',i))
    
    
end