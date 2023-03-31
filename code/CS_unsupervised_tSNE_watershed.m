%% t-SNE embedding with multiple ITERATIONS (fixed distance, perplexity)

load CS_unsupervised_catex catex

%tSNE
dis = 'seuclidean';
per = 750;
options = statset('MaxIter',1000);
clear Y
for p = 1:30
    fprintf('perplexity - %1.0f\n',per)
    Y(:,:,p) = tsne(catex(1:1:end,:),'Algorithm','barneshut','Distance',dis,'NumPCAComponents',0, 'Verbose', 1,'Perplexity',per,'Options',options,'Exaggeration',5);
    
    figure
    h = histogram2(Y(:,1,p),Y(:,2,p),150,'DisplayStyle','tile','ShowEmptyBins','on');
    Iblur1 = imgaussfilt(h.Values,2);
    close
    figure, imagesc(Iblur1'), axis image
    set(gcf,'pos',[1.9597e+03 675 470 341.3333]), axis image, axis off
    eval(sprintf('title(''%s Perplexity %0d, ITER %1.0f'')',dis,per,p))
    pause(0.5)
    save CS_unsupervised_tSNE Y per dis
end

%% watershed segmentation

Y = squeeze(Y(:,:,1));  %select iteration

%watershed segmentation of tsne map
figure
step = 0.089;
maxmin = max([abs(min(min(Y))) abs(max(max(Y)))]);
span = (-1*round(maxmin))-1:step:round(maxmin)+1;
h = histogram2(Y(:,1),Y(:,2),span,span,'DisplayStyle','tile','ShowEmptyBins','on');
Iblur1 = imgaussfilt(h.Values',12.7);
close
ic = imcomplement(Iblur1);
BW = imhmin(ic,0.0015*(1-(min(min(ic)))));
L = watershed(BW);

max(max(L)) %number of clusters

ic3 = ic;
ic3(L == 0) = min(min(ic));
figure, imagesc(ic3)
axis image, axis off, %axis xy
caxis([min(min(ic)) max(max(ic))])
colormap('jet')
c = colormap;
c(1,:) = [0 0 0];
colormap(c)

%get cluster ID for tsne entries
warpY = round(Y/step)+round(numel(span)/2);
for c = 1:length(Y)
    clustY(c) = L(warpY(c,2),warpY(c,1));
end
clustY = double(clustY);

%fix clustY values on watershed edge (were set to 0)
Y0 = find(clustY==0);
%set to mode of 100 knns
kn = knnsearch(catex,catex(Y0,:),'dist','seuclidean','K',100);    %find 100 nearest neighbors
clustY(Y0) = mode(clustY(kn'));

save CS_unsupervised_tSNE_watershed Y clustY step