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

mineggs = 1;

% PU-1>Kir

g = 13; %PU-1>Kir
for c = 1:6
    currg = find(p(:,1)==g & p(:,2) == conc(c));
    for cg = 1:length(currg)
        a(c).tot1(cg) = sum(p(currg(cg),3:5));
        if a(c).tot1(cg)>=mineggs
            a(c).PI1(cg) = (2*p(currg(cg),3)+2*p(currg(cg),4))/(2*a(c).tot1(cg));
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
        if b(c).tot1(cg)>=mineggs
            b(c).PI1(cg) = (2*p(currg(cg),3)+2*p(currg(cg),4))/(2*b(c).tot1(cg));
        else
            b(c).PI1(cg) = NaN;
        end
    end
end

g = 15; %PU-1>GFP
for c = 1:6
    currg = find(p(:,1)==g & p(:,2) == conc(c));
    for cg = 1:length(currg)
        d(c).tot1(cg) = sum(p(currg(cg),3:5));
        if d(c).tot1(cg)>=mineggs
            d(c).PI1(cg) = (2*p(currg(cg),3)+2*p(currg(cg),4))/(2*d(c).tot1(cg));
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
    ioT(1:length(d(k).tot1),k,1) = d(k).tot1';
    ioT(1:length(b(k).tot1),k,2) = b(k).tot1';
    ioT(1:length(a(k).tot1),k,3) = a(k).tot1';
    ioP(1:length(d(k).PI1),k,1) = d(k).PI1';
    ioP(1:length(b(k).PI1),k,2) = b(k).PI1';
    ioP(1:length(a(k).PI1),k,3) = a(k).PI1';
end

figure, iosr.statistics.boxPlot(ioT(:,4,:),'theme','colorall','themeColors',@gray,'symbolMarker','+');
ylabel('total eggs laid')
xticks([.75 1 1.25])
xticklabels({'GAL4','UAS','PU-1'})
axis([0.6 1.4 0 50.0000])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[1.8466e+03 838.6000 190.4000 380.8000])

figure, iosr.statistics.boxPlot(ioP(:,4,:),'theme','colorall','themeColors',@gray,'symbolMarker','+');
ylabel('Egg Depth')
xticks([.75 1 1.25])
xticklabels({'GAL4','UAS','PU-1'})
axis([0.6 1.4 0 1])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[1.8466e+03 838.6000 190.4000 380.8000])

for k = 1:6
    Tma(k) = mean(a(k).tot1);
    Tsa(k) = std(a(k).tot1)./sqrt(length(a(k).tot1));
    Pma(k) = nmean(a(k).PI1);
    Psa(k) = nstd(a(k).PI1)./sqrt(length(a(k).tot1));
    
    Tmb(k) = mean(b(k).tot1);
    Tsb(k) = std(b(k).tot1)./sqrt(length(b(k).tot1));
    Pmb(k) = nmean(b(k).PI1);
    Psb(k) = nstd(b(k).PI1)./sqrt(length(b(k).tot1));
    
    Tmd(k) = mean(d(k).tot1);
    Tsd(k) = std(d(k).tot1)./sqrt(length(d(k).tot1));
    Pmd(k) = nmean(d(k).PI1);
    Psd(k) = nstd(d(k).PI1)./sqrt(length(d(k).tot1));
end

Tm = [Tmd; Tmb; Tma];
Ts = [Tsd; Tsb; Tsa];
Pm = [Pmd; Pmb; Pma];
Ps = [Psd; Psb; Psa];

figure('pos',[1.8466e+03 838.6000 190.4000 380.8000]), hold on
barc = [.33 .33 .33; .67 .67 .67; 1 0 0];

for i = 1:3
    bar(i,Tm(i,4),'FaceColor',barc(i,:))
end

errorbar(1:3,Tm(:,4),Ts(:,4),'.','Color','k')
ylabel('total eggs laid')
axis([.4 3.6 0 40])
xticks([1 2 3])
xticklabels({'GAL4','UAS','PU-1'})
set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(findall(gcf,'-property','LineWidth'),'LineWidth',1.5)

figure('pos',[1.8466e+03 838.6000 190.4000 380.8000]), hold on
barc = [.33 .33 .33; .67 .67 .67; 1 0 0];

for i = 1:3
    bar(i,Pm(i,4),'FaceColor',barc(i,:))
end

errorbar(1:3,Pm(:,4),Ps(:,4),'.','Color','k')
ylabel('average egg depth')
axis([.4 3.6 0 1])
xticks([1 2 3])
xticklabels({'GAL4','UAS','PU-1'})
set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(findall(gcf,'-property','LineWidth'),'LineWidth',1.5)

% BEEHIVE PLOTS

data{1} = d(4).tot1;
data{2} = b(4).tot1;
data{3} = a(4).tot1;
figure, plotSpread(data,'distributioncolors',[.33 .33 .33; .67 .67 .67; 1 0 0],'distributionmarkers','o')
axis([.5 3.5 0 50])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Number of eggs laid in 4h')

hh = figure; plotSpread(data,'showMM',4)
set(findall(hh,'type','line','color','b'),'markerSize',80)
axis([.5 3.5 0 50])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Number of eggs laid in 4h')

data{1} = d(4).PI1;
data{2} = b(4).PI1;
data{3} = a(4).PI1;
figure, plotSpread(data,'distributioncolors',[.33 .33 .33; .67 .67 .67; 1 0 0],'distributionmarkers','o')
axis([.5 3.5 0 1])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Average egg depth')

hh = figure; plotSpread(data,'showMM',4)
set(findall(hh,'type','line','color','b'),'markerSize',80)
axis([.5 3.5 0 1])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Average egg depth')

%PU-2>Kir

clear a d

g = 14; %PU-2>Kir
for c = 1:6
    currg = find(p(:,1)==g & p(:,2) == conc(c));
    for cg = 1:length(currg)
        a(c).tot1(cg) = sum(p(currg(cg),3:5));
        if a(c).tot1(cg)>=mineggs
            a(c).PI1(cg) = (2*p(currg(cg),3)+1*p(currg(cg),4))/(2*a(c).tot1(cg));
        else
            a(c).PI1(cg) = NaN;
        end
    end
end

g = 16; %PU-2>GFP
for c = 1:6
    currg = find(p(:,1)==g & p(:,2) == conc(c));
    for cg = 1:length(currg)
        d(c).tot1(cg) = sum(p(currg(cg),3:5));
        if d(c).tot1(cg)>=mineggs
            d(c).PI1(cg) = (2*p(currg(cg),3)+1*p(currg(cg),4))/(2*d(c).tot1(cg));
        else
            d(c).PI1(cg) = NaN;
        end
    end
end

% IOSR,BOXPLOT
maxn = 0;
for k = 1:6
    maxn = max([maxn length(a(k).tot1) length(b(k).tot1) length(d(k).tot1)]);  
end

ioT = NaN*ones(maxn,6,3);
ioP = NaN*ones(maxn,6,3);
for k = 1:6
    ioT(1:length(d(k).tot1),k,1) = d(k).tot1';
    ioT(1:length(b(k).tot1),k,2) = b(k).tot1';
    ioT(1:length(a(k).tot1),k,3) = a(k).tot1';
    ioP(1:length(d(k).PI1),k,1) = d(k).PI1';
    ioP(1:length(b(k).PI1),k,2) = b(k).PI1';
    ioP(1:length(a(k).PI1),k,3) = a(k).PI1';
end

figure, iosr.statistics.boxPlot(ioT(:,4,:),'theme','colorall','themeColors',@gray,'symbolMarker','+');
ylabel('total eggs laid')
xticks([.75 1 1.25])
xticklabels({'GAL4','UAS','PU-2'})
axis([0.6 1.4 0 55.0000])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[1.8466e+03 838.6000 190.4000 380.8000])

figure, iosr.statistics.boxPlot(ioP(:,4,:),'theme','colorall','themeColors',@gray,'symbolMarker','+');
ylabel('Egg Depth')
xticks([.75 1 1.25])
xticklabels({'GAL4','UAS','PU-2'})
axis([0.6 1.4 0 1])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[1.8466e+03 838.6000 190.4000 380.8000])

for k = 1:6
    Tma(k) = mean(a(k).tot1);
    Tsa(k) = std(a(k).tot1)./sqrt(length(a(k).tot1));
    Pma(k) = nmean(a(k).PI1);
    Psa(k) = nstd(a(k).PI1)./sqrt(length(a(k).tot1));
    
    Tmb(k) = mean(b(k).tot1);
    Tsb(k) = std(b(k).tot1)./sqrt(length(b(k).tot1));
    Pmb(k) = nmean(b(k).PI1);
    Psb(k) = nstd(b(k).PI1)./sqrt(length(b(k).tot1));
    
    Tmd(k) = mean(d(k).tot1);
    Tsd(k) = std(d(k).tot1)./sqrt(length(d(k).tot1));
    Pmd(k) = nmean(d(k).PI1);
    Psd(k) = nstd(d(k).PI1)./sqrt(length(d(k).tot1));
end

Tm = [Tmd; Tmb; Tma];
Ts = [Tsd; Tsb; Tsa];
Pm = [Pmd; Pmb; Pma];
Ps = [Psd; Psb; Psa];

figure('pos',[1.8466e+03 838.6000 190.4000 380.8000]), hold on
barc = [.33 .33 .33; .67 .67 .67; 1 0 0];

for i = 1:3
    bar(i,Tm(i,4),'FaceColor',barc(i,:))
end

errorbar(1:3,Tm(:,4),Ts(:,4),'.','Color','k')
ylabel('total eggs laid')
axis([.4 3.6 0 40])
xticks([1 2 3])
xticklabels({'GAL4','UAS','PU-2'})
set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(findall(gcf,'-property','LineWidth'),'LineWidth',1.5)

figure('pos',[1.8466e+03 838.6000 190.4000 380.8000]), hold on
barc = [.33 .33 .33; .67 .67 .67; 1 0 0];

for i = 1:3
    bar(i,Pm(i,4),'FaceColor',barc(i,:))
end

errorbar(1:3,Pm(:,4),Ps(:,4),'.','Color','k')
ylabel('average egg depth')
axis([.4 3.6 0 1])
xticks([1 2 3])
xticklabels({'GAL4','UAS','PU-2'})
set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(findall(gcf,'-property','LineWidth'),'LineWidth',1.5)


% BEEHIVE PLOTS

data{1} = d(4).tot1;
data{2} = b(4).tot1;
data{3} = a(4).tot1;
figure, plotSpread(data,'distributioncolors',[.33 .33 .33; .67 .67 .67; 1 0 0],'distributionmarkers','o')
axis([.5 3.5 0 55])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Number of eggs laid in 4h')

hh = figure; plotSpread(data,'showMM',4)
set(findall(hh,'type','line','color','b'),'markerSize',80)
axis([.5 3.5 0 55])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Number of eggs laid in 4h')

data{1} = d(4).PI1;
data{2} = b(4).PI1;
data{3} = a(4).PI1;
figure, plotSpread(data,'distributioncolors',[.33 .33 .33; .67 .67 .67; 1 0 0],'distributionmarkers','o')
axis([.5 3.5 0 1])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Average egg depth')

hh = figure; plotSpread(data,'showMM',4)
set(findall(hh,'type','line','color','b'),'markerSize',80)
axis([.5 3.5 0 1])
set(findall(gcf,'-property','FontSize'),'FontSize',10);
set(gcf,'pos',[2.2482e+03 636.2000 190.4000 380.8000])
yticks(0:10:50)
ylabel('Average egg depth')