function imdb = imdb_test_oneFixed_multiGT()
%% Image A
path_to_data = 'G:\Pascal_BBox3\Train';

szImagePath = fullfile(path_to_data, 'Images');
bbPath = fullfile(path_to_data, 'BBox');
Image_Sizepath =  fullfile(path_to_data, 'Image_Size');
proposal_path =  fullfile(path_to_data, 'Proposals');

dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
props_dir =dir (proposal_path);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
props_dir(1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
propsAll = cell(numel(props_dir), 1);

for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(numel(imgList), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(numel(valueList), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(numel(sizevalueList), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(numel(propsList), 1);
    
    for jj = 1 : numel(imgList)
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(jj).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(jj).name));
        bboxAll{ii}{jj} = inter_bbox.BBox';
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name, sizevalueList(jj).name));
        sizeAll{ii}{jj}= sizeImageInter.Imsize';
        
        propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
            propsList(jj).name));
        propsAll{ii}{jj}= propsInter.props';
        
        label_B{ii}{jj,1} = ii;
    end
end

imgsAll_reserved_copy =  imgsAll;
for ii = 1 : numel(imgsAll)
    rp = randperm(numel(imgsAll{ii}));
    imgsAll{ii} = imgsAll{ii}(rp);
    bboxAll{ii} = bboxAll{ii}(rp);
    sizeAll{ii} = sizeAll{ii}(rp);
    propsAll{ii} = propsAll{ii}(rp);
    label_B{ii} =  label_B{ii}(rp);    
end
imdb.imagesA.name = {};
imdb.bboxA.gtbox = {};
imdb.bboxA.Imagesize = {};
imdb.bboxA.label ={};
imdb.bboxA.proposal ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesA.name = [imdb.imagesA.name; imgsAll{ii}];
    imdb.bboxA.gtbox = [imdb.bboxA.gtbox; bboxAll{ii}];
    imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize; sizeAll{ii}];
    imdb.bboxA.label = [imdb.bboxA.label; label_B{ii}];
    imdb.bboxA.proposal = [imdb.bboxA.proposal; propsAll{ii}];
end
imdb.imagesA.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb.imagesA.set = [imdb.imagesA.set;ones(numel(imdb.imagesA.name),1)];



%% ImagesB


dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
props_dir =dir (proposal_path);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
props_dir(1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
propsAll = cell(numel(props_dir), 1);

for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(numel(imgList), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(numel(valueList), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(numel(sizevalueList), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(numel(propsList), 1);
    
    for jj = 1 : numel(imgList)
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(jj).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(jj).name));
        bboxAll{ii}{jj} = inter_bbox.BBox';
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name, sizevalueList(jj).name));
        sizeAll{ii}{jj}= sizeImageInter.Imsize';
        
        propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
            propsList(jj).name));
        propsAll{ii}{jj}= propsInter.props';
        
        label_B{ii}{jj,1} = ii;
    end
end

imgsAll_reserved_copy =  imgsAll;
for ii = 1 : numel(imgsAll)
    rp = randperm(numel(imgsAll{ii}));
    imgsAll{ii} = imgsAll{ii}(rp);
    bboxAll{ii} = bboxAll{ii}(rp);
    sizeAll{ii} = sizeAll{ii}(rp);
    propsAll{ii} = propsAll{ii}(rp);
    label_B{ii} =  label_B{ii}(rp);    
end
imdb.imagesB.name = {};
imdb.bboxB.gtbox = {};
imdb.bboxB.Imagesize = {};
imdb.bboxB.label ={};
imdb.bboxB.proposal ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesB.name = [imdb.imagesB.name; imgsAll{ii}];
    imdb.bboxB.gtbox = [imdb.bboxB.gtbox; bboxAll{ii}];
    imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize; sizeAll{ii}];
    imdb.bboxB.label = [imdb.bboxB.label; label_B{ii}];
    imdb.bboxB.proposal = [imdb.bboxB.proposal; propsAll{ii}];
end
imdb.imagesB.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb.imagesB.set = [imdb.imagesB.set;ones(numel(imdb.imagesB.name),1)];
%% Make multiple BBox availible

% for k= 1:numel(imdb.imagesA.name)
%     if size(imdb.bboxA.gtbbox{k},1) > 1
%         for m=1: size(imdb.bboxA.gtbbox{k},1)
%             
%         end
% end
%%
shaffle_rp = randperm(numel(imdb.imagesA.name));
imdb.imagesA.name = imdb.imagesA.name(shaffle_rp);
imdb.imagesA.set = imdb.imagesA.set(shaffle_rp);
imdb.bboxA.gtbox = imdb.bboxA.gtbox(shaffle_rp);
imdb.bboxA.Imagesize = imdb.bboxA.Imagesize(shaffle_rp);
imdb.bboxA.proposal = imdb.bboxA.proposal(shaffle_rp);
imdb.bboxA.label = imdb.bboxA.label(shaffle_rp);
imdb.imagesB.name = imdb.imagesB.name(shaffle_rp);
imdb.imagesB.set = imdb.imagesB.set(shaffle_rp);
imdb.bboxB.gtbox = imdb.bboxB.gtbox(shaffle_rp);
imdb.bboxB.Imagesize = imdb.bboxB.Imagesize(shaffle_rp);
imdb.bboxB.proposal = imdb.bboxB.proposal(shaffle_rp);
imdb.bboxB.label = imdb.bboxB.label(shaffle_rp);
%%
imdb.classes.name = {'aeroplane', 'bicycle', 'bird', ...
    'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
    'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
    'sofa', 'train', 'tvmonitor'};
