load CS_annotations

param_ann2 = param_ann;
for daba = 1:2
    
    if daba == 1
        param_ann(:,:,1202:end) = 0;
    else
        param_ann = param_ann2;
        param_ann(:,:,1:1200) = 0;
    end
    
    for i = 1:size(param_ann,2)
        egg(i,:) = squeeze(param_ann(5,i,:));
        per(i,:) = squeeze(param_ann(2,i,:))' & ~egg(i,:);
        drag(i,:) = squeeze(param_ann(7,i,:))' & ~per(i,:);
        burr(i,:) = squeeze(param_ann(4,i,:))' & ~per(i,:);
        bend(i,:) = squeeze(param_ann(3,i,:))' & ~per(i,:);
        groom(i,:) = squeeze(param_ann(6,i,:))' & ~bend(i,:) & ~burr(i,:) & ~per(i,:);
        move(i,:) = squeeze(param_ann(1,i,:))' & ~groom(i,:) & ~bend(i,:) & ~burr(i,:) & ~per(i,:) & ~egg(i,:);
    end
    
    for i = 1:size(param_ann,2)
        dburr(i,:) = diff([0 burr(i,:)]);
        dper(i,:) = diff([0 per(i,:)]);
        dgroom(i,:) = diff([0 groom(i,:)]);
        ddrag(i,:) = diff([0 drag(i,:)]);
        dbend(i,:) = diff([0 bend(i,:)]);
        degg(i,:) = diff([0 egg(i,:)]);
        dmove(i,:) = diff([0 move(i,:)]);
    end
    
    comb = zeros(size(dper));
    comb(dbend==1) = 3;
    comb(dburr==1) = 4;
    comb(dper==1) = 1;
    comb(dgroom==1) = 7;
    comb(ddrag==1) = 6;
    comb(degg==1) = 5;
    comb(dmove==1) = 2;
    
    %
    tmx = zeros(7,7);
    
    for i = 1:size(comb,1)
        test = comb(i,:);
        seq = test(test>0);
        start(daba,i) = seq(1);     %how the sequence begins
        finish(daba,i) = seq(end);  %how the sequence ends
        for j = 1:numel(seq)-1
            tmx(seq(j),seq(j+1)) = tmx(seq(j),seq(j+1)) +1;
        end
    end
    
    for i = 1:7
        ntmx(i,:) = tmx(i,:)/sum(tmx(i,:));
    end
    

    if daba == 1
        pre_ntmx = ntmx;
    else
        post_ntmx = ntmx;
    end
end

pre_ntmx
post_ntmx