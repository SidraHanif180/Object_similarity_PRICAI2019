function [net, info] = fast_rcnn_train(varargin)
%FAST_RCNN_TRAIN  Demonstrates training a Fast-RCNN detector

% Copyright (C) 2016 Hakan Bilen.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

 run('/data/cong/matconvnet/matlab/vl_setupnn.m') ;
project_root = '/d/sidra/pascal_2007_2012';
% '/home/sidra/pascal_2007_2012';
addpath(fullfile(project_root,'examples','fast_rcnn','bbox_functions'));
addpath(fullfile(project_root,'examples','fast_rcnn','datasets'));
addpath(fullfile(project_root,'examples','fast_rcnn', 'dataset_custom'));
addpath(fullfile(project_root,'examples','fast_rcnn', '+dagnnLoss'));
addpath(genpath(fullfile('C:\Users\Sidra\Downloads\instre.tar', 'instre')));
% '/data/sidra/instre.tar', 'instre'
% addpath('G:\Sidra\retreival_pascal\cnngeometric_matconvnet-master\matlab\auxiliary_functions');

opts.dataDir   = fullfile(project_root, 'data') ;
% fullfile('/data/sidra', 'data') ;

opts.sswDir    = fullfile(project_root, 'data', 'SSW');
opts.expDir    = fullfile(project_root, 'fast-rcnn_INSTRE_S1') ;
% '/data/sidra', 'fast-rcnn_INSTRE_S1'
opts.imdbPath  = fullfile(opts.expDir, 'imdb.mat');
opts.modelPath = fullfile(project_root, 'data', 'models', ...
  'imagenet-vgg-verydeep-16.mat') ;

opts.piecewise = true;  % piecewise training (+bbox regression)
opts.train.gpus = [1,2,3,4] ;
opts.train.batchSize = 8 ;
opts.train.numSubBatches = 1 ;
opts.train.continue = true ;
opts.train.prefetch = false ; % does not help for two images in a batch
opts.train.learningRate = 1e-3 / 64 * [ones(1,6) ones(1,44) ones(1,20), 0.1*ones(1,50)];
opts.train.weightDecay = 0.0005 ;
opts.train.numEpochs = 120 ;
opts.train.derOutputs = {'lossbbox', 1, 'losssim',1} ;
opts.lite = false  ;
opts.numFetchThreads = 2 ;

opts = vl_argparse(opts, varargin) ;
display(opts);

opts.train.expDir = opts.expDir ;
opts.train.numEpochs = numel(opts.train.learningRate) ;

% -------------------------------------------------------------------------
%                                                    Network initialization
% -------------------------------------------------------------------------
% net = fast_rcnn_init(...
%   'piecewise',opts.piecewise,...
%   'modelPath',opts.modelPath);
net = fast_rcnn_init_siamese (opts);

% -------------------------------------------------------------------------
%                                                   Database initialization
% -------------------------------------------------------------------------
% if exist(opts.imdbPath,'file') == 2
%   fprintf('Loading imdb...');
%   imdb = load(opts.imdbPath) ;
% else
%   if ~exist(opts.expDir,'dir')
%     mkdir(opts.expDir);
%   end
%   fprintf('Setting VOC2007 up, this may take a few minutes\n');
%   imdb = cnn_setup_data_voc07_ssw(...
%     'dataDir', opts.dataDir, ...
%     'sswDir', opts.sswDir, ...
%     'addFlipped', true, ...
%     'useDifficult', true) ;
%   save(opts.imdbPath,'-struct', 'imdb','-v7.3');
%   fprintf('\n');
% end
% fprintf('done\n');

% imdb = imdb_train_nooverlapGT();
% imdb = attach_proposals_onefixed(imdb);
% imdb = imdb_train_2012();
% imdb = attach_proposals_2012(imdb);
% imdb_Train = imdb_train_saliency_T();
% imdb_Test = imdb_test_saliency_T();
% imdb = combine (imdb_Train, imdb_Test);
% %imdb = attach_proposals_saliency_T(imdb);
 %imdb = combine_proposals_saliency_T(imdb);


%%
% imdb_test = load('imdb_test_label_all.mat');
% imdb_test = imdb_test.imdb;
% imdb_test.bboxA.objlist = imdb_test.imagesA.label_all;
% imdb_test.bboxB.objlist = imdb_test.imagesB.label_all;
% imdb_test.imagesA.set = 3* imdb_test.imagesA.set;
% imdb_test.imagesB.set = 3* imdb_test.imagesB.set;
% imdb1= imdb_test;
% %%

%%
% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------
% use train + val split to train
% imdb.images.set(imdb.imagesA.set == 2) = 1;

% minibatch options
bopts = net.meta.normalization;
bopts.useGpu = numel(opts.train.gpus) >  0 ;
bopts.numFgRoisPerImg = 16;
bopts.numRoisPerImg = 64;
bopts.maxScale = 500;
bopts.scale = 300;
% bopts.bgLabel = numel(imdb.classes.name)+1;
bopts.visualize = 0;
bopts.interpolation = net.meta.normalization.interpolation;
bopts.numThreads = opts.numFetchThreads;
bopts.prefetch = opts.train.prefetch;

[net,info] = cnn_train_dag_accv(net, @(i,b) ...
                           getBatch(bopts,i,b), ...
                           opts.train) ;

% --------------------------------------------------------------------
%                                                               Deploy
% --------------------------------------------------------------------
modelPath = fullfile(opts.expDir, 'net-deployed.mat');
if ~exist(modelPath,'file')
  net = deployFRCNN(net,imdb);
  net_ = net.saveobj() ;
  save(modelPath, '-struct', 'net_') ;
  clear net_ ;
end

% --------------------------------------------------------------------
function inputs = getBatch(opts, imdb, batch)
% --------------------------------------------------------------------
opts.visualize = 0;

if isempty(batch)
  return;
end

% images = strcat([imdb.imageDir filesep], imdb.images.name(batch)) ;
% opts.prefetch = (nargout == 0);
% [imoA, roisA, imoB, roisB,imoBNeg, roisBneg, actual_proposal,...
%     gtAllB, targets]
[imA,roisA,imB,roisB_pos,actual_proposals,...
    gtAllB, targets, label_class, Imagesize] = ...
    fast_rcnn_train_get_batch_anchor...
    (imdb,batch, opts);
 
% rois = single(rois);
roisA = single(roisA);
roisB_pos = single(roisB_pos);
if opts.useGpu > 0
  imA = gpuArray(imA) ;
  imB = gpuArray(imB) ;
%  imBNeg = gpuArray(imBNeg);
  roisA = gpuArray(roisA) ;
  roisB_pos = gpuArray(roisB_pos) ;
 % label_class = gpuArray(label_class) ;

%   targets = gpuArray(single(targets)) ;
%   gt_multiple  = gpuArray(single(gt_multiple));
end

inputs = {'AN1input', imA, 'AN2input', imB,...
    'AN1rois', roisA,'AN2rois', roisB_pos, ...
    'proposal', actual_proposals, 'gtAll', gtAllB,...
    'targets', targets,'label_class', label_class};
%, 'Imagesize', Imagesize } ;
% 
% --------------------------------------------------------------------
function net = deployFRCNN(net,imdb)
% --------------------------------------------------------------------
% function net = deployFRCNN(net)
for l = numel(net.layers):-1:1
  if isa(net.layers(l).block, 'dagnn.Loss') || ...
      isa(net.layers(l).block, 'dagnn.DropOut')
    layer = net.layers(l);
    net.removeLayer(layer.name);
    net.renameVar(layer.outputs{1}, layer.inputs{1}, 'quiet', true) ;
  end
end

net.rebuild();

pfc8 = net.getLayerIndex('predcls') ;
net.addLayer('probcls',dagnn.SoftMax(),net.layers(pfc8).outputs{1},...
  'probcls',{});

net.vars(net.getVarIndex('probcls')).precious = true ;

idxBox = net.getLayerIndex('predbbox') ;
if ~isnan(idxBox)
  net.vars(net.layers(idxBox).outputIndexes(1)).precious = true ;
  % incorporate mean and std to bbox regression parameters
  blayer = net.layers(idxBox) ;
  filters = net.params(net.getParamIndex(blayer.params{1})).value ;
  biases = net.params(net.getParamIndex(blayer.params{2})).value ;
  
  boxMeans = single(imdb.boxes.bboxMeanStd{1}');
  boxStds = single(imdb.boxes.bboxMeanStd{2}');
  
  net.params(net.getParamIndex(blayer.params{1})).value = ...
    bsxfun(@times,filters,...
    reshape([boxStds(:)' zeros(1,4,'single')]',...
    [1 1 1 4*numel(net.meta.classes.name)]));

  biases = biases .* [boxStds(:)' zeros(1,4,'single')];
  
  net.params(net.getParamIndex(blayer.params{2})).value = ...
    bsxfun(@plus,biases, [boxMeans(:)' zeros(1,4,'single')]);
end

net.mode = 'test' ;
