load('PU_2photon.mat')

post_expel = 150;
pre = 50;
post = 100;

FPS = 10;
windowSize1 = 3;
smoothe_trace = 3;
event_nan = 15;

all_bo = [];
all_be = [];
all_oe = [];
all_gc = [];
for ani = 1:8
   
    load(sprintf('%s',PU_2p(ani).gc))
    PU_i = PU_2p(ani).PU_i;
    
    if ~isempty(PU_2p(ani).egg_lost)
        egg_lost = PU_2p(ani).egg_lost;
        PU_2p(ani).npdxy(5,egg_lost:end) = PU_2p(ani).npdxy(5,egg_lost-1);
        PU_2p(ani).o_e(egg_lost:end) = PU_2p(ani).o_e(egg_lost-1);
    end
    
    for i = 1:numel(PU_i)
        
        pre_events = PU_2p(ani).i(i).cross_ts(PU_2p(ani).i(i).cross_ts<(PU_2p(ani).expel+post_expel/10));  %DO YOU WANT THIS POST_EXPEL BUFFER?
        PU_2p(ani).i(i).pre_events = pre_events;
        pre_events = pre_events(pre_events > pre);
        
        events = PU_2p(ani).i(i).pre_events;
        gc1 = norm_jump_fix_gcamp_XPS16(gcamp1(PU_i(i),:), events, FPS, event_nan, windowSize1, smoothe_trace);
        
        clear bo be oe gc
        for j = 1:numel(pre_events)
            bo(j,:) = PU_2p(ani).npdxy(4,pre_events(j)-pre:pre_events(j)+post);
            be(j,:) = PU_2p(ani).npdxy(5,pre_events(j)-pre:pre_events(j)+post);
            oe(j,:) = PU_2p(ani).o_e(pre_events(j)-pre:pre_events(j)+post);
            gc(j,:) = gc1(pre_events(j)-pre:pre_events(j)+post);
        end
        all_bo = [all_bo; mean(bo,1)];
        all_be = [all_be; mean(be,1)];
        all_oe = [all_oe; mean(oe,1)];
        all_gc = [all_gc; mean(gc,1)];
    end
end

N = size(all_bo,1);
C = repmat(linspace(.7,0.3,N).',1,3);

figure('pos',[1.4137e+03 901 282 420])
subplot(4,1,1)
for i = 1:size(all_bo,1)
    plot(all_bo(i,:),'color',C(i,:)), hold on
end
plot(mean(all_bo),'color','r','linewidth',2)
title('B:O')
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')

subplot(4,1,2)
for i = 1:size(all_bo,1)
    plot(all_be(i,:),'color',C(i,:)), hold on
end
plot(mean(all_be),'color','r','linewidth',2)
title('B:E')
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')

subplot(4,1,3)
for i = 1:size(all_bo,1)
    plot(all_oe(i,:),'color',C(i,:)), hold on
end
plot(mean(all_oe),'color','r','linewidth',2)
title('O:E')
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')

subplot(4,1,4)
for i = 1:size(all_bo,1)
    plot(all_gc(i,:),'color',C(i,:)), hold on
end
plot(mean(all_gc),'color','r','linewidth',2)
title('GC')
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')

figure('pos',[1.4137e+03 901 282 420])
subplot(4,1,1)
sem = std(all_bo)/sqrt(size(all_bo,1));
errorpatch(1:size(all_bo,2),mean(all_bo),sem,[0 0 1],1.5,.5)
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
title('B:O')
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')

subplot(4,1,2)
sem = std(all_be)/sqrt(size(all_be,1));
errorpatch(1:size(all_be,2),mean(all_be),sem,[1 0 1],1.5,.5)
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
title('B:E')
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')

subplot(4,1,3)
sem = std(all_oe)/sqrt(size(all_oe,1));
errorpatch(1:size(all_oe,2),mean(all_oe),sem,[0 0 0],1.5,.5)
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
title('O:E')
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')

subplot(4,1,4)
sem = std(all_gc)/sqrt(size(all_gc,1));
errorpatch(1:size(all_gc,2),mean(all_gc),sem,[0 1 0],1.5,.5)
set(gca,'xtick',[1 50 100 150])
xticklabels({'-5','0','5','10'})
title('GC')
axis tight, ax = axis;
line([pre+1 pre+1],[ax(3) ax(4)],'color',[.4 .4 .4],'linestyle','--')