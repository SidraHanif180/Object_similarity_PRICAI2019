function fast_rcnn_demo(varargin)
%FAST_RCNN_DEMO  Demonstrates Fast-RCNN
%
% Copyright (C) 2016 Abhishek Dutta and Hakan Bilen.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).
tic
imdb = load('C:\G_drive_data\Sidra\matconvnet_1_accv\data\fast_rcnn_retrieval\imdb_test_all');
imdb = imdb.imdb;
run(fullfile(fileparts(mfilename('fullpath')), ...
    '..', '..', 'matlab', 'vl_setupnn.m')) ;

addpath(fullfile(vl_rootnn,'examples','fast_rcnn','bbox_functions')) ;

opts.modelPath = '' ;
opts.classes = {'aeroplane', 'bicycle', 'bird', ...
    'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
    'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
    'sofa', 'train', 'tvmonitor'};
opts.gpu = 1 ;
opts.confThreshold = 0.5 ;
opts.nmsThreshold = 0.3 ;
opts = vl_argparse(opts, varargin) ;

% Load or download the Fast RCNN model
paths = {opts.modelPath, ...
    './fast-rcnn-vgg16-dagnn.mat', ...
    fullfile(vl_rootnn, 'data', 'models', 'fast-rcnn-vgg16-pascal07-dagnn.mat'), ...
    fullfile(vl_rootnn, 'data', 'models-import', 'fast-rcnn-vgg16-pascal07-dagnn.mat')} ;
ok = min(find(cellfun(@(x)exist(x,'file'), paths))) ;

if isempty(ok)
    fprintf('Downloading the Fast RCNN model ... this may take a while\n') ;
    opts.modelPath = fullfile(vl_rootnn, 'data', 'models', 'fast-rcnn-vgg16-pascal07-dagnn.mat') ;
    mkdir(fileparts(opts.modelPath)) ;
    urlwrite('http://www.vlfeat.org/matconvnet/models/fast-rcnn-vgg16-pascal07-dagnn.mat', ...
        opts.modelPath) ;
else
    opts.modelPath = paths{ok} ;
end

% Load the network and put it in test mode.
net = load(opts.modelPath) ;
net = dagnn.DagNN.loadobj(net);
net.mode = 'test' ;

% Mark class and bounding box predictions as `precious` so they are
% not optimized away during evaluation.
net.vars(net.getVarIndex('cls_prob')).precious = 1 ;
net.vars(net.getVarIndex('bbox_pred')).precious = 1 ;
gpuDevice(1);
net.move('gpu') ;
for num=1:numel(imdb.imagesB.name)
    % Load a test image and candidate bounding boxes.
    im = single(imread(imdb.imagesB.name{num})) ;
    imo = im; % keep original image
    boxes = uint16(imdb.bboxB.proposal_SS{num});%load('000004_boxes.mat') ;
    boxes = single(boxes') + 1 ; %single(boxes.boxes') + 1 ;
    boxeso = boxes - 1; % keep original boxes
    
    % Resize images and boxes to a size compatible with the network.
    imageSize = size(im) ;
    fullImageSize = net.meta.normalization.imageSize(1) ...
        / net.meta.normalization.cropSize ;
    scale = max(fullImageSize ./ imageSize(1:2)) ;
    im = imresize(im, scale, ...
        net.meta.normalization.interpolation, ...
        'antialiasing', false) ;
    boxes = bsxfun(@times, boxes - 1, scale) + 1 ;
    
    % Remove the average color from the input image.
    imNorm = bsxfun(@minus, im, net.meta.normalization.averageImage) ;
    
    % Convert boxes into ROIs by prepending the image index. There is only
    % one image in this batch.
    rois = [ones(1,size(boxes,2)) ; boxes] ;
    
    % Evaluate network either on CPU or GPU.
    if numel(opts.gpu) > 0
        
        imNorm = gpuArray(imNorm) ;
        rois = gpuArray(rois) ;
    end
    
    %net.conserveMemory = false ;
    net.eval({'data', imNorm, 'rois', rois});
    
    % Extract class probabilities and  bounding box refinements
    probs = squeeze(gather(net.vars(net.getVarIndex('cls_prob')).value)) ;
    deltas = squeeze(gather(net.vars(net.getVarIndex('bbox_pred')).value)) ;
    features{num} = squeeze(gather(net.vars(net.getVarIndex('conv5_3x')).value)) ;
    % Visualize results for one class at a time
    for i = 1:numel(opts.classes)
        c = find(strcmp(opts.classes{i}, net.meta.classes.name)) ;
        cprobs = probs(c,:) ;
        cdeltas = deltas(4*(c-1)+(1:4),:)' ;
        cboxes = bbox_transform_inv(boxeso', cdeltas);
        cls_dets = [cboxes cprobs'] ;
        
        keep = bbox_nms(cls_dets, opts.nmsThreshold) ;
        cls_dets = cls_dets(keep, :) ;
        
        sel_boxes = find(cls_dets(:,end) >= opts.confThreshold) ;
        box_prop{num,i} = cls_dets(sel_boxes,:);
        
%         imo = bbox_draw(imo/255,cls_dets(sel_boxes,:));
%         title(sprintf('Detections for class ''%s''', opts.classes{i})) ;
%         
%         fprintf('Detections for category ''%s'':\n', opts.classes{i});
%         for j=1:size(sel_boxes,1)
%             bbox_id = sel_boxes(j,1);
%             fprintf('\t(%.1f,%.1f)\t(%.1f,%.1f)\tprobability=%.6f\n', ...
%                 cls_dets(bbox_id,1), cls_dets(bbox_id,2), ...
%                 cls_dets(bbox_id,3), cls_dets(bbox_id,4), ...
%                 cls_dets(bbox_id,end));
%         end
    end
end
toc
save('boxB.mat', 'box_prop');
save('featuresB.mat','features','-v7.3' );