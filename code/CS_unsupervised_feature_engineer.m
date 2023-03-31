load CS_DLC_zscore ani folds
load CS_oviwhite

fps = 20;
options = statset('MaxIter',500);

catex = [];     %matrix of exemplars
frames = [];    %[animal frame_index];

catex_stat = [];     %matrix of stationary frames
frames_stat = [];    %[stationary frame_index];

for f = 1:numel(folds)
    fprintf('%1.0f of %1.0f animals\n',f,numel(folds))
    cd(sprintf('%s\\%s',folds(f).folder, folds(f).name))
    
    clear nw_xy veldtt pe_hc_diff ba velba T1_energy T2_energy T3_energy vel pe_hc bavel T1E T2E T3E
    
    csv = dir('R*DLC*2000000.csv');
    dlc = [];
    for i = 1:numel(csv)
        aba = xlsread(sprintf('%s\\%s',csv(i).folder,csv(i).name));
        dlc = [dlc; aba];
    end
    
    %>>>>>>>>>>>>>>>>>>  cwt of "app" (selected appendage - #2 - Abdomen-ring2
    app = 2;
    binning = 4;
    w_x = abs(cwt(dlc(:,app*3-1),'amor',fps,'FrequencyLimits',[0.5 10]));  %Morlet continuous wavelet transform
    w_y = abs(cwt(dlc(:,app*3),'amor',fps,'FrequencyLimits',[0.5 10]));  %Morlet continuous wavelet transform
    w_xy = (w_x + w_y);
    bin_w_xy = downsamplebin(w_xy,1,binning);
    bin2_w = [(mean(bin_w_xy(1:5,:))); bin_w_xy(6:11,:)];
    bin2_w = log(bin2_w);
    
    %>>>>>>>>>>>>>>>>>>  dtt velocity
    dtt = dlc(:,(12*3)-1:(12*3));
    step = 10; %10 * 50ms = 500ms
    for i = 1:length(dtt)-step
        vel(i+step) = pdist(dtt([i i+step],:));
    end
    veldtt = conv(vel,ones([1 10])/10,'same');
    
    %>>>>>>>>>>>>>>>>>>  proboscis (to head center) energy
    pe = dlc(:,(7*3)-1:(7*3));
    hc = dlc(:,(10*3)-1:(10*3));
    for i = 1:length(pe)
        pe_hc(i) = pdist([pe(i,:); hc(i,:)]);
    end
    pe_hc_diff = conv(abs(diff([0 pe_hc])),ones([1 5])/5,'same');
    
    %>>>>>>>>>>>>>>>>>>  bend angular velocity (+ and -)
    ba = mean([ani(f).zabd_Theta; ani(f).zabd2_Theta]); %mean of angles (VER3)
    step = 10; %10 * 50ms = 500ms
    for i = 1:length(ba)-step
        bavel(i+step) = diff(ba([i i+step]));
    end
    velba = conv(bavel,ones([1 10])/10,'same');
    
    %>>>>>>>>>>>>>>>>>>  leg energy
    %right legs
    T1 = dlc(:,(24*3)-1:(24*3));
    T2 = dlc(:,(25*3)-1:(25*3));
    T3 = dlc(:,(6*3)-1:(6*3));
    
    step = 1; %1 * 50ms = 50ms
    for i = 1:length(T1)-step
        T1E(i+step) = pdist(T1([i i+step],:));
        T2E(i+step) = pdist(T2([i i+step],:));
        T3E(i+step) = pdist(T3([i i+step],:));
    end
    
    RT1_energy = conv(T1E,ones([1 10])/10,'same');
    RT2_energy = conv(T2E,ones([1 10])/10,'same');
    RT3_energy = conv(T3E,ones([1 10])/10,'same');
    
    %left legs
    T1 = dlc(:,(22*3)-1:(22*3));
    T2 = dlc(:,(23*3)-1:(23*3));
    T3 = dlc(:,(5*3)-1:(5*3));
    
    step = 1; %1 * 50ms = 50ms
    for i = 1:length(T1)-step
        T1E(i+step) = pdist(T1([i i+step],:));
        T2E(i+step) = pdist(T2([i i+step],:));
        T3E(i+step) = pdist(T3([i i+step],:));
    end
    
    LT1_energy = conv(T1E,ones([1 10])/10,'same');
    LT2_energy = conv(T2E,ones([1 10])/10,'same');
    LT3_energy = conv(T3E,ones([1 10])/10,'same');
    
    T1_energy(ani(f).right) = RT1_energy(ani(f).right);
    T1_energy(~ani(f).right) = LT1_energy(~ani(f).right);
    T2_energy(ani(f).right) = RT2_energy(ani(f).right);
    T2_energy(~ani(f).right) = LT2_energy(~ani(f).right);
    T3_energy(ani(f).right) = RT3_energy(ani(f).right);
    T3_energy(~ani(f).right) = LT3_energy(~ani(f).right);
    
    %>>>>>>>>>>>>>>>>>>  P(egg)
    Pegg = dlc(:,(13*3)+1)';
    Pegg_smoothe = conv(Pegg,ones([1 20])/20,'same');
    
    %>>>>>>>>>>>>>>>>>>  oviwhite
    binning = 8;
    w_ovi = abs(cwt(ovi(f).oviwhite/1e3,'amor',fps,'FrequencyLimits',[0.75 2.25]));  %Morlet continuous wavelet transform
    [~, fr] = cwt(ovi(f).oviwhite/1e3,'amor',fps,'FrequencyLimits',[0.75 2.25]);
    bin_w_ovi =  downsamplebin(w_ovi,1,binning)/binning;
    thr_w_ovi = zeros(size(bin_w_ovi));
    thr_w_ovi(:,Pegg_smoothe>0.02) = bin_w_ovi(:,Pegg_smoothe>0.02);
    
    %>>>>>>>>>>>>>>>>>>  created compiled matrix
    aug = [bin2_w; veldtt/40; pe_hc_diff/20; ba; velba; T1_energy/20; T2_energy/20; T3_energy/20; Pegg_smoothe*5; thr_w_ovi]';    %VER3 scaling
    
    %>>>>>>>>>>>>>>>>>>  establish critereon for selecting "good" frames
    %compute normalized wing length
    error = ani(f).long > 220;
    P = prctile(ani(f).long(ani(f).good & ~error),97);
    ani(f).nlong = ani(f).long/P;
    ani(f).nlong(ani(f).nlong>1) = 1;
    
    %"good" if all relavant apps visible AND norm. wing length > 0.7
    Papp = (dlc(:,1+app*3));    %dlc probability of selected "app"
    Ppe = (dlc(:,1+7*3));     %dlc probability of pe
    good = ani(f).good & Papp' > .9 & ani(f).nlong > 0.7 & Ppe' > .04 & pe_hc < 140;
    
    %find stretches >4 seconds long (since smallest wavelet is 0.5Hz)
    ons = find(diff([0 good])==1);
    offs = find(diff([good 0])==-1);
    block_length = offs - ons;
    good_blocks = find(block_length>4*20);
    good_frames = [];
    for b = 1:numel(good_blocks)
        good_frames = [good_frames ons(good_blocks(b))+2*20:offs(good_blocks(b))-2*20];
    end
    
    %eliminate ~motionless, resting posture frames
    stationary = sum(bin2_w)<log(50) & veldtt<3 & pe_hc_diff<2 & ba>-.8 & ba<.8 & velba>-.35 & velba<.35 & T1_energy<3 & T2_energy<3 & T3_energy<3 & Pegg_smoothe <.02; %VER3 (adjust bin2_w since using log now)
    good_frames2 = setdiff(good_frames, find(stationary));
    
    %>>>>>>>>>>>>>>>>>>  fraction of good frames that are stationary (for calculating cluster probabilities)
    stat_f(f,:) = [numel(good_frames) - numel(good_frames2) numel(good_frames)];
    
    %>>>>>>>>>>>>>>>>>>  single-animal tsne
    skipx = 4;
    Y = tsne(aug(good_frames2(1:skipx:end),:),'Algorithm','barneshut','Distance','correlation','NumPCAComponents',0, 'Verbose', 1,'Perplexity',250,'Options',options,'Exaggeration',5);
    
    %>>>>>>>>>>>>>>>>>>  single-animal watershed
    figure
    step = 0.05;
    maxmin = max([abs(min(min(Y))) abs(max(max(Y)))]);
    span = (-1*round(maxmin))-1:step:round(maxmin)+1;
    h = histogram2(Y(:,1),Y(:,2),span,span,'DisplayStyle','tile','ShowEmptyBins','on');
    Iblur1 = imgaussfilt(h.Values',20);
    close
    ic = imcomplement(Iblur1);
    BW = imhmin(ic,0.0025*(1-(min(min(ic)))));
    L = watershed(BW);
    ic(L == 0) = 1;
    figure, imagesc(ic)
    title(sprintf('%1.0f - %1.0f clusters',f, max(max(L))))
    max(max(L)) %number of clusters
    pause(0.5)
    
    %>>>>>>>>>>>>>>>>>>  choose 35 points from watershed clusters
    points = 35;
    warpY = round(Y/step)+round(numel(span)/2);
    clear clustY
    for c = 1:length(Y)
        clustY(c) = L(warpY(c,2),warpY(c,1));
    end
    
    self = [];
    for i = 1:max(max(L))
        avail = find(clustY == i);
        self = [self avail(randperm(numel(avail),min([points numel(avail)])))];
    end
    
    self2 = good_frames2(1+(self-1)*skipx); %to map back onto original (since skipped by 4)
    y = sort(self2);
    
    catex = [catex; aug(y,:)];
    frames = [frames; [f.*ones([numel(y) 1]) y']];
    
    %>>>>>>>>>>>>>>>>>>  choose proportional number of "stationary" frames (for later calculating z-scores)
    stat_frames2 = intersect(good_frames, find(stationary));
    stat_r = stat_f(f,1)/stat_f(f,2);   %fraction of good_frames that are stationary;
    y_stat = stat_frames2(randperm(numel(stat_frames2), round((numel(y)/(1-stat_r)) - numel(y))));
    catex_stat = [catex_stat; aug(y_stat,:)];
    frames_stat = [frames_stat; [f.*ones([numel(y_stat) 1]) y_stat']];
    
end

save CS_unsupervised_catex catex frames skipx step fps stat_f catex_stat frames_stat