p = xlsread('CS_firmness.xlsx');

conc = 0.75:.25:2.5;
mineggs = 1;

for c = 1:length(conc)
    currg = find(p(:,1) == conc(c));
    ncg(c) = length(currg);
    j = 0;
    for cg = 1:length(currg)
        b(c).tot1(cg) = sum(p(currg(cg),2:4));
        if b(c).tot1(cg)>=mineggs
            j = j + 1;
            b(c).PI1(cg) = (2*p(currg(cg),2)+1*p(currg(cg),3))/(2*b(c).tot1(cg));
            b(c).in(j) = p(currg(cg),2)/b(c).tot1(cg);
            b(c).part(j) = p(currg(cg),3)/b(c).tot1(cg);
            b(c).on(j) = p(currg(cg),4)/b(c).tot1(cg);
        else
            b(c).PI1(cg) = NaN;
        end
    end
end

% IOSR, BOXPLOT

for k = 1:length(conc)
    num_anis(k) = length(b(k).tot1);  
end
maxn = max(num_anis);

T = NaN*ones(maxn,length(conc));
P = NaN*ones(maxn,length(conc));
for k = 1:length(conc)
    T(1:length(b(k).tot1),k) = b(k).tot1';
    P(1:length(b(k).PI1),k) = b(k).PI1';
end

figure('pos',[210.6000 1.2002e+03 526.4000 382.4000])
iosr.statistics.boxPlot(T,'theme','default','medianColor',@gray,'showScatter',false,'xSeparator',false);
ylabel('total eggs laid')
xticklabels({'0.75','1.0','1.25','1.5','1.75','2.0','2.25','2.5'})
xlabel('agar concentration')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

figure('pos',[210.6000 1.2002e+03 526.4000 382.4000])
iosr.statistics.boxPlot(P,'theme','default','medianColor',@gray,'showScatter',false,'xSeparator',false);
ylabel('egg depth')
xticklabels({'0.75','1.0','1.25','1.5','1.75','2.0','2.25','2.5'})
xlabel('agar concentration')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

% stacked bar graph

for g = 1:length(conc)
    mT(g) = nmean(T(:,g));
    sT(g) = nstd(T(:,g))/(sqrt(sum(~isnan(T(:,g)))));
    mP(g) = nmean(P(:,g));
    sP(g) = nstd(P(:,g))/(sqrt(sum(~isnan(P(:,g)))));
end

figure('pos',[210.6000 1.2002e+03 526.4000 382.4000])
bar([mean(b(1).in) mean(b(1).part) mean(b(1).on); ...
mean(b(2).in) mean(b(2).part) mean(b(2).on);  ...
mean(b(3).in) mean(b(3).part) mean(b(3).on);  ...
mean(b(4).in) mean(b(4).part) mean(b(4).on);  ...
mean(b(5).in) mean(b(5).part) mean(b(5).on);  ...
mean(b(6).in) mean(b(6).part) mean(b(6).on);  ...
mean(b(7).in) mean(b(7).part) mean(b(7).on);  ...
mean(b(8).in) mean(b(8).part) mean(b(8).on)],'stacked')

xticklabels({'0.75','1.0','1.25','1.5','1.75','2.0','2.25','2.5'})
xlabel('agar concentration')
axis([.2188 8.7813 0 1])
ylabel('fraction eggs laid')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
ax = axis;

figure('pos',[210.6000 1.2002e+03 526.4000 382.4000])
bar([mean(b(1).in) mean(b(1).part) mean(b(1).on); ...
mean(b(2).in) mean(b(2).part) mean(b(2).on);  ...
mean(b(3).in) mean(b(3).part) mean(b(3).on);  ...
mean(b(4).in) mean(b(4).part) mean(b(4).on);  ...
mean(b(5).in) mean(b(5).part) mean(b(5).on);  ...
mean(b(6).in) mean(b(6).part) mean(b(6).on);  ...
mean(b(7).in) mean(b(7).part) mean(b(7).on);  ...
mean(b(8).in) mean(b(8).part) mean(b(8).on)],'stacked')

xticklabels({'0.75','1.0','1.25','1.5','1.75','2.0','2.25','2.5'})
xlabel('agar concentration')
axis([.2188 8.7813 0 1])
ylabel('fraction eggs laid')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
hold on
plot(mP,'m')
errorbar(mP,sP,'.','Color','m')
axis(ax)

% bar graphs + sem

figure('pos',[210.6000 1.2002e+03 526.4000 382.4000])
bar(mT), hold on
errorbar(mT,sT,'.','Color','k')
ylabel('total eggs laid')
xticklabels({'0.75','1.0','1.25','1.5','1.75','2.0','2.25','2.5'})
xlabel('agar concentration')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

figure('pos',[210.6000 1.2002e+03 526.4000 382.4000])
bar(mP), hold on
errorbar(mP,sP,'.','Color','k')
ylabel('egg depth')
xticklabels({'0.75','1.0','1.25','1.5','1.75','2.0','2.25','2.5'})
xlabel('agar concentration')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

%beehive plot
for g = 1:length(conc)
    data{g} = (T(:,g));
end
figure, plotSpread(data,'distributioncolors','k','distributionmarkers','o','binWidth',.2)
set(gcf,'pos',[210.6000 1.2002e+03 526.4000 382.4000])

ylabel('total eggs laid')
xticklabels({'0.75','1.0','1.25','1.5','1.75','2.0','2.25','2.5'})
xlabel('agar concentration')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
ax = axis; axis([ax(1) ax(2) 0 45])
yticks(0:10:40)