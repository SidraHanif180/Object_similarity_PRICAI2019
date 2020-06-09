function [imoA, roisA, imoB, roisB,imoBNeg, roisBneg, actual_proposal,...
    gtAllB, targets]...
    = fast_rcnn_test_6(imdb, batch, opts)


imsA   = cell(1,numel(batch));
imsB  = cell(1,numel(batch));

for b=1:numel(batch)
  imagesA{b}= imdb.imagesA.name{batch(b)};
  imagesB{b}= imdb.imagesB.name{batch(b)};
  imagesNeg{b} = imdb.bboxB.negimg{batch(b)};
end
imsA = vl_imreadjpeg(imagesA','numThreads',opts.numThreads) ;
imsB = vl_imreadjpeg(imagesB','numThreads',opts.numThreads) ;
imsNeg = vl_imreadjpeg(imagesB','numThreads',opts.numThreads) ;
maxW = 0;
maxH = 0;
% labels = imdb.images.label(:,batch);

pboxesA   = cell(1,numel(batch));
%labelA = cell(1,numel(batch));
pboxesB   = cell(1,numel(batch));
%labelB = cell(1,numel(batch));
pboxesNeg = cell(1,numel(batch));
for b=1:numel(batch)
  
  pboxesA{b}   = single(imdb.bboxA.gt_single{batch(b)}); 
  % gt for A
  pboxesB{b}   = single(imdb.bboxB.targetpos{batch(b)});  
  %proposal for B  
  pboxesNeg{b} = single(imdb.bboxB.negprop{batch(b)});  
  % proposal for negative for image B
end
for b=1:numel(batch)
actual_proposal{b} =single(imdb.bboxB.targetpos{batch(b)})';
end
for b=1:numel(batch)
  gtAllB{b} = single(imdb.bboxB.target_gt{batch(b)})';  
  % gt B
end

% rescale images and rois
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
roisBneg = [];
imreB = cell(1,numel(batch));
imreBNeg = cell(1,numel(batch));
% rois = [];
% imre = cell(1,numel(batch));
for b=1:numel(batch)
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
  bbox = pboxesB{b};
  if any(bbox(:)<=0)
    error('bbox error');
  end

  nB = size(bbox,1);
  tbbox = bbox_scale(bbox,factor,[imreSize(2) imreSize(1)]);
  if any(tbbox(:)<=0)
    error('tbbox error');
  end

  roisB = [roisB [b*ones(1,nB) ; tbbox' ] ];
  
end
%if roisBneg =[]; roisBneg = 1; end
imoB = zeros(maxH,maxW,size(imreB{1},3),numel(batch),'single');
for b=1:numel(batch)
  % subtract mean
  if ~isempty(opts.averageImage)
    imreB{b} = single(bsxfun(@minus,imreB{b},opts.averageImage));
  end
  sz = size(imreB{b});
  imoB(1:sz(1),1:sz(2),:,b) = single(imreB{b});
end
maxW = 0;
maxH = 0;
for b=1:numel(batch)
  imSize = size(imsNeg{b});

  h = imSize(1);
  w = imSize(2);

  factor = max(opts.scale(1)/h,opts.scale(1)/w);

  if any([h*factor,w*factor]>opts.maxScale)
    factor = min(opts.maxScale/h,opts.maxScale/w);
  end

  if abs(factor-1)>1e-3
    imreBNeg{b} = imresize(imsNeg{b},factor,'Method',opts.interpolation);
  else
    imreBNeg{b} = imsNeg{b};
  end


  imreSize = size(imreBNeg{b});

  maxH = max(imreSize(1),maxH);
  maxW = max(imreSize(2),maxW);

  bboxneg = pboxesNeg{b};
  if any(bboxneg(:)<=0)
    error('bbox error');
  end

  nB = size(bboxneg,1);
  tbbox = bbox_scale(bboxneg,factor,[imreSize(2) imreSize(1)]);
  if any(tbbox(:)<=0)
    error('tbbox error');
  end
   
  roisBneg = [roisBneg [b*ones(1,nB) ; tbbox' ] ];
end
imoBNeg = zeros(maxH,maxW,size(imreBNeg{1},3),numel(batch),'single');
for b=1:numel(batch)
  % subtract mean
  if ~isempty(opts.averageImage)
    imreBNeg{b} = single(bsxfun(@minus,imreBNeg{b},opts.averageImage));
  end
  sz = size(imreBNeg{b});
  imoBNeg(1:sz(1),1:sz(2),:,b) = single(imreBNeg{b});
end
for b=1:numel(batch)
  
  targets{b}   = single(imdb.bboxB.ptarget{batch(b)})'; % imdb.bboxA.label 
end
 targets = (cell2mat(targets));
