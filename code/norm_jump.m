function dffix3 = norm_jump_fix_gcamp_XPS16(gcamp1,events,FPS, event_nan, windowSize, smoothe_trace)

norm = gcamp1/1;
norm_nan = norm;
for x = 1:length(events)
    norm_nan(:,events(x):events(x)+(FPS*event_nan)) = NaN;   
end
sum_norm_nan = sum(norm_nan);
if sum(sum_norm_nan == 0) > 0
    eval(sprintf('disp(''** Skipped %2.0f ZEROS **'')',sum(sum_norm_nan == 0)))
end
norm_nan(:,sum_norm_nan == 0) = NaN;

for i = 1:size(gcamp1,1)
    baseline = mean(norm_nan(i,1:(events(end)-1)),'omitnan');
    dff(i,:) = (norm(i,:))/baseline;
end

jump_thresh = 1.35;

b = (1/windowSize)*ones(1,windowSize);
a = 1;

for i = 1:size(gcamp1,1)
    dff2(i,:) = filter(b,a,dff(i,:));
end

dffix = dff;
for i = 1:size(gcamp1,1)
    jump_i = find(abs(dff(i,:)-dff2(i,:))>jump_thresh);
    dffix(i,jump_i) = dff2(i,jump_i);
end

if nargin == 6 
    b = (1/smoothe_trace)*ones(1,smoothe_trace);
    for i = 1:size(gcamp1,1)
        dffix2(i,:) = filter(b,a,dffix(i,:));
    end
    dffix2_nan = dffix2;
    for x = 1:length(events)
        dffix2_nan(:,events(x):events(x)+(FPS*event_nan)) = NaN;
    end
    for i = 1:size(gcamp1,1)
        baseline = mean(dffix2_nan(i,1:(events(end)-1)),'omitnan');
        dffix3(i,:) = (dffix2(i,:)/baseline)-1;
    end
    
else   
    dffix_nan = dffix;
    for x = 1:length(events)
        dffix_nan(:,events(x):events(x)+(FPS*event_nan)) = NaN;
    end
    
    for i = 1:size(gcamp1,1)
        baseline = mean(dffix_nan(i,1:(events(end)-1)),'omitnan');
        dffix3(i,:) = (dffix(i,:)/baseline)-1;
    end
end