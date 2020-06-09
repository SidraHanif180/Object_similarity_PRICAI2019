function [imoA, roisA, imoB, roisB,pboxesA , pboxesB,...
    imB_plot]= fast_rcnn_test_get_batch_6(imdb, batch, opts)
 
imsA   = cell(1,numel(batch));
imsB  = cell(1,numel(batch));

for b=1:numel(batch)
  imagesA{b}= imdb.imagesA.name{batch(b)};
  imagesB{b}= imdb.imagesB.name{batch(b)};
end
imsA = vl_imreadjpeg(imagesA','numThreads',opts.numThreads) ;
imsB = vl_imreadjpeg(imagesB','numThreads',opts.numThreads) ;
maxW = 0;
maxH = 0;
% labels = imdb.images.label(:,batch);

pboxesA   = cell(1,numel(batch));
%labelA = cell(1,numel(batch));
pboxesB   = cell(1,numel(batch));
%labelB = cell(1,numel(batch));
for b=1:numel(batch)
  
  pboxesA{b}   = single(imdb.bboxA.gt_single{batch(b)}); 
  % gt for A
  pboxesB{b}   = single(imdb.bboxB.proposal{batch(b)});  
  %Imagesize for B
  
end

roisA = [];
imreA = cell(1,numel(batch));
% rois = [];
% imre = cell(1,numel(batch));
for b=1:numel(batch)
  imSize = size(imsA{b});

  h = imSize(1);
  w = imSize(2);

  factor = max(opts.scale(1)/h,opts.scale(1)/w);

  if any([h*factor,w*factor]>opts.maxScale)
    factor = min(opts.maxScale/h,opts.maxScale/w);
  end

  if abs(factor-1)>1e-3
    imreA{b} = imresize(imsA{b},factor,'Method',opts.interpolation);
  else
    imreA{b} = imsA{b};
  end


  imreSize = size(imreA{b});

  maxH = max(imreSize(1),maxH);
  maxW = max(imreSize(2),maxW);

  % adapt bounding boxes into new coord
  bbox = pboxesA{b};
  if any(bbox(:)<=0)
    error('bbox error');
  end

  nB = size(bbox,1);
  tbbox = bbox_scale(bbox,factor,[imreSize(2) imreSize(1)]);
  if any(tbbox(:)<=0)
    error('tbbox error');
  end

  roisA = [roisA [b*ones(1,nB) ; tbbox' ] ];
end

imoA = zeros(maxH,maxW,size(imreA{1},3),numel(batch),'single');
for b=1:numel(batch)
  % subtract mean
  if ~isempty(opts.averageImage)
    imreA{b} = single(bsxfun(@minus,imreA{b},opts.averageImage));
  end
  sz = size(imreA{b});
  imoA(1:sz(1),1:sz(2),:,b) = single(imreA{b});
end

%%
maxW = 0;
maxH = 0;
roisB = [];
imreB = cell(1,numel(batch));
% rois = [];
% imre = cell(1,numel(batch));
for b=1:numel(batch)
    proposal_all = imdb.bboxB.proposal{b,1}; 
    for j=1:size(proposal_all,1)
        
  imSize = size(imsB{b});

  h = imSize(1);
  w = imSize(2);

  factor = max(opts.scale(1)/h,opts.scale(1)/w);

  if any([h*factor,w*factor]>opts.maxScale)
    factor = min(opts.maxScale/h,opts.maxScale/w);
  end

  if abs(factor-1)>1e-3
    imreB{b} = imresize(imsB{b},factor,'Method',opts.interpolation);
  else
    imreB{b} = imsB{b};
  end


  imreSize = size(imreB{b});

  maxH = max(imreSize(1),maxH);
  maxW = max(imreSize(2),maxW);

  % adapt bounding boxes into new coord
  bbox = proposal_all(j,:);
  if any(bbox(:)<=0)
    error('bbox error');
  end

  nB = size(bbox,1);
  tbbox = bbox_scale(bbox,factor,[imreSize(2) imreSize(1)]);
  if any(tbbox(:)<=0)
    error('tbbox error');
  end

  roisB = [roisB [ones(1,nB) ; tbbox' ] ];
    end
end

imoB = zeros(maxH,maxW,size(imreB{1},3),numel(batch),'single');
imreB1= imreB;
for b=1:numel(batch)
  % subtract mean
  if ~isempty(opts.averageImage)
    imreB1{b} = single(bsxfun(@minus,imreB1{b},opts.averageImage));
  end
  sz = size(imreB1{b});
  imoB(1:sz(1),1:sz(2),:,b) = single(imreB1{b});
end
imB_plot = imsB;
% for b=1:numel(batch)
%   % subtract mean
%   if ~isempty(opts.averageImage)
%     imreB{b} = single(imreB{b});
%   end
%   sz = size(imreB{b});
%   imB_plot(1:sz(1),1:sz(2),:,b) = single(imreB{b});
% end


