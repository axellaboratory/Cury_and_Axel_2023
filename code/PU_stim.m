load PU_stim

stims = [0.1 0 2.5 5 20 0.2];

for s = 1:length(stims)
    rows = find(PU_stim(:,1) == stims(s));
    delay{s} = PU_stim(rows,3)';
    light{s} = -1*PU_stim(rows,2)';
    eb{s} = PU_stim(rows,4)';
    quiet{s} = PU_stim(rows,5)';
    detach_light{s} = PU_stim(rows,2)';
    last_b_light{s} = PU_stim(rows,7)';
end

figure('pos',[2.0266e+03 393 360.0000 733.6000])
for i = 1:length(stims)-1
    if stims(i) == 0.2
        stims(i) = 20;
    end
    subplot(length(stims),1,i), hold on
    histogram(delay{i},0:.5:21,'FaceColor',[.33 .33 .85],'EdgeColor','none','FaceAlpha',1)
    xticks(0:2.5:20)
    title(sprintf('%1.1f sec. light',stims(i)))
    
    d = delay{i};
    e = eb{i};
    
    deb = d(e>0);
    histogram(deb,0:.5:21,'FaceColor',[.33 .85 .85],'EdgeColor','none','FaceAlpha',1)    
    ax = axis;
    axis([ax(1) 21.05 0 max([ax(4) 10])])
end
xlabel('time to burrow stop after egg expulsion')
stims(i) = 0.2;