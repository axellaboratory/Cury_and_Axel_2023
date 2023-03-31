load('PU_2photon.mat')

ani = 3;

load(sprintf('%s',PU_2p(ani).gc))
PU_i = PU_2p(ani).PU_i;

for i = 1:numel(PU_i)
    events = PU_2p(ani).i(i).pre_events;
    
    FPS = 10;
    windowSize1 = 3; 
    smoothe_trace = 3;
    event_nan = 15;
    
    gc1(i,:) = norm_jump_fix_gcamp_XPS16(gcamp1(PU_i(i),:), events, FPS, event_nan, windowSize1, smoothe_trace);
    gc2(i,:) = norm_jump_fix_gcamp_XPS16(gcamp2(PU_i(i),:), events, FPS, event_nan, windowSize1, smoothe_trace);    
end

frames = [8347 8515 8620 8710 8830];
range = 8170:9070;
time = 1/FPS:1/FPS:numel(range)/FPS;
figure('pos',[1375 381.6667 1.0047e+03 468.6667])
ae = 0;
for i = 1:length(PU_i)
    subplot(length(PU_i)+2,1,i), plot(time,gc2(i,range)','r','linewidth',1.5), hold on
    subplot(length(PU_i)+2,1,i), plot(time,gc1(i,range)','g','linewidth',1.5)
    set(gca,'xtick',[])
    axis tight, ax = axis;
    axmin(i) = ax(3); axmax(i) = ax(4);
    for f = 1:length(frames)
        line([time(frames(f)-range(1)) time(frames(f)-range(1))], [axmin(i) axmax(i)],'color',[.4 .4 .4],'linewidth',1,'linestyle','--')
    end
    
    for e = 1:numel(PU_2p(ani).i(i).pre_events)
        ei = find(range == PU_2p(ani).i(i).pre_events(e));
        if ~isempty(ei)
            ae = ae + 1;
            all_events(ae,:) = [i ei];
            line([time(ei) time(ei)], [axmin(i) axmax(i)],'color','k','linewidth',1,'linestyle','-')
        end
    end
    
    plot(time,gc2(i,range)','r','linewidth',1.5)
    plot(time,gc1(i,range)','g','linewidth',1.5)
end

subplot(length(PU_i)+2,1,i+1)
plot(time,PU_2p(ani).npdxy(4,range),'b','linewidth',1.5)
axis tight, ax = axis;
plot(time,PU_2p(ani).npdxy(5,range),'m','linewidth',1.5)
hold on
plot(time,PU_2p(ani).npdxy(4,range),'b','linewidth',1.5)
set(gca,'xtick',[])
axis tight, ax2 = axis;
axis([ax(1) ax(2) ax2(3) ax(4)+.3])
for f = 1:length(frames)
    line([time(frames(f)-range(1)) time(frames(f)-range(1))], [ax2(3) ax(4)+.1],'color',[.4 .4 .4],'linewidth',1,'linestyle','--')
end

ax = axis;
yrange = diff([ax(3) ax(4)]);
for a = 1:length(PU_i)
    yquart(a,:) = [ax(4) - (a-1)*yrange/4 ax(4) - a*yrange/4];
end
for e = 1:size(all_events,1)
    line([time(all_events(e,2)) time(all_events(e,2))], [yquart(all_events(e,1),1) yquart(all_events(e,1),2)],'color','k','linewidth',1,'linestyle','-')
end

subplot(length(PU_i)+2,1,i+2)

egg_in = PU_2p(ani).o_e(range)<0;
plot(time,PU_2p(ani).o_e(range),'k','linewidth',1.5), hold on
plot(time(egg_in),PU_2p(ani).o_e(range(egg_in)),'color',[.4 .4 .4],'linewidth',1.5)

axis tight, ax = axis;
for f = 1:length(frames)
    line([time(frames(f)-range(1)) time(frames(f)-range(1))], [ax(3) ax(4)],'color',[.4 .4 .4],'linewidth',1,'linestyle','--')
end

ax = axis;
yrange = diff([ax(3) ax(4)]);
for a = 1:length(PU_i)
    yquart(a,:) = [ax(4) - (a-1)*yrange/4 ax(4) - a*yrange/4];
end
for e = 1:size(all_events,1)
    line([time(all_events(e,2)) time(all_events(e,2))], [yquart(all_events(e,1),1) yquart(all_events(e,1),2)],'color','k','linewidth',1,'linestyle','-')
end

xlabel('time (s)')
set(gca,'xtick',0:10:90)
set(findall(gcf,'-property','FontSize'),'FontSize',12)