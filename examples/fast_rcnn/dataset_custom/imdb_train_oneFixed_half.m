function imdb = imdb_train_oneFixed_half()
%% Image A
path_to_data = 'G:\Pascal_BBox3\Train';
szImagePath = fullfile(path_to_data, 'Images');
bbPath = fullfile(path_to_data, 'BBox');
Image_Sizepath =  fullfile(path_to_data, 'Image_Size');
proposal_path =  fullfile(path_to_data, 'Proposals');
object_list = fullfile(path_to_data, 'object_list');

dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
propsAll = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list));

for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)*0.5), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)*0.5), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)*0.5), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(floor(numel(propsList)*0.5), 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)*0.5), 1);
    
    for jj = 1 : floor(numel(imgList)*0.5)
        j = randperm(numel(imgList),1);
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(j).name));
        bboxAll{ii}{jj} = inter_bbox.BBox';
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name,...
            sizevalueList(j).name));
        sizeAll{ii}{jj}= sizeImageInter.Imsize';
        
        propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
            propsList(j).name));
        propsAll{ii}{jj}= propsInter.props';
        
        [~, name_file,~] = fileparts(imgsAll{ii}{jj});
        objInter = load(fullfile(object_list,obj_list(ii).name,...
            strcat(name_file,'.mat')));
        objAll{ii}{jj,1}= objInter.label';
        
        label_B{ii}{jj,1} = ii;
    end
end

imgsAll_reserved =  imgsAll;
for ii = 1 : numel(imgsAll)
    rp = randperm(floor(numel(imgsAll{ii})));
    imgsAll{ii} = imgsAll{ii}(rp);
    bboxAll{ii} = bboxAll{ii}(rp);
    sizeAll{ii} = sizeAll{ii}(rp);
    propsAll{ii} = propsAll{ii}(rp);
    label_B{ii} =  label_B{ii}(rp); 
    objAll{ii} = objAll{ii}(rp);
end
imdb.imagesA.name = {};
imdb.bboxA.gtbox = {};
imdb.bboxA.Imagesize = {};
imdb.bboxA.label ={};
imdb.bboxA.proposal ={};
imdb.bboxA.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesA.name = [imdb.imagesA.name; imgsAll{ii}];
    imdb.bboxA.gtbox = [imdb.bboxA.gtbox; bboxAll{ii}];
    imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize; sizeAll{ii}];
    imdb.bboxA.label = [imdb.bboxA.label; label_B{ii}];
    imdb.bboxA.proposal = [imdb.bboxA.proposal; propsAll{ii}];
    imdb.bboxA.objlist = [imdb.bboxA.objlist;objAll{ii}];
end
imdb.imagesA.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb.imagesA.set = [imdb.imagesA.set;ones(numel(imdb.imagesA.name),1)];
%% ImagesB
dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
propsAll = cell(numel(props_dir), 1);
%rois_neg = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list),1);
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)*0.5), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)*0.5), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)*0.5), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(floor(numel(propsList)*0.5), 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)*0.5), 1);
    
    for jj = 1 : floor(numel(imgList)*0.5)
        j = randperm(numel(imgList),1);
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(j).name));
        bboxAll{ii}{jj} = inter_bbox.BBox';
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name, ...
            sizevalueList(j).name));
        sizeAll{ii}{jj}= sizeImageInter.Imsize';
        
        propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
            propsList(j).name));
        propsAll{ii}{jj}= propsInter.props';
        
        [~, name_file,~] = fileparts(imgsAll{ii}{jj});
        objInter = load(fullfile(object_list,obj_list(ii).name,...
            strcat(name_file,'.mat')));
        objAll{ii}{jj,1}= objInter.label';
        
        label_B{ii}{jj,1} = ii;
    end
end

%%
for ii = 1 : numel(imgsAll)
    rp = randperm(floor(numel(imgsAll{ii})));
    imgsAll{ii} = imgsAll{ii}(rp);
    bboxAll{ii} = bboxAll{ii}(rp);
    sizeAll{ii} = sizeAll{ii}(rp);
    propsAll{ii} = propsAll{ii}(rp);
    label_B{ii} =  label_B{ii}(rp);   
    objAll{ii} = objAll{ii}(rp);
    
end
imdb.imagesB.name = {};
imdb.bboxB.gtbox = {};
imdb.bboxB.Imagesize = {};
imdb.bboxB.label ={};
imdb.bboxB.proposal ={};
imdb.bboxB.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesB.name = [imdb.imagesB.name; imgsAll{ii}];
    imdb.bboxB.gtbox = [imdb.bboxB.gtbox; bboxAll{ii}];
    imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize; sizeAll{ii}];
    imdb.bboxB.label = [imdb.bboxB.label; label_B{ii}];
    imdb.bboxB.proposal = [imdb.bboxB.proposal; propsAll{ii}];
    imdb.bboxB.objlist = [imdb.bboxB.objlist;objAll{ii}];
    
end
imdb.imagesB.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb.imagesB.set = [imdb.imagesB.set;ones(numel(imdb.imagesB.name),1)];

%% Neagtive samples
path_to_data = 'G:\Pascal_BBox3\Train';
szImagePath = fullfile(path_to_data, 'Images');
bbPath = fullfile(path_to_data, 'BBox');
Image_Sizepath =  fullfile(path_to_data, 'Image_Size');
proposal_path =  fullfile(path_to_data, 'Proposals');
object_list = fullfile(path_to_data, 'object_list');

dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
propsAll = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list));

for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)*0.5), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)*0.5), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)*0.5), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(floor(numel(propsList)*0.5), 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)*0.5), 1);
    
    for jj = 1 : floor(numel(imgList)*0.5)
        j = randperm(numel(imgList),1);
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(j).name));
        bboxAll{ii}{jj} = inter_bbox.BBox';
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name,...
            sizevalueList(j).name));
        sizeAll{ii}{jj}= sizeImageInter.Imsize';
        
        propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
            propsList(j).name));
        propsAll{ii}{jj}= propsInter.props';
        
        [~, name_file,~] = fileparts(imgsAll{ii}{jj});
        objInter = load(fullfile(object_list,obj_list(ii).name,...
            strcat(name_file,'.mat')));
        objAll{ii}{jj,1}= objInter.label';
        
        label_B{ii}{jj,1} = ii;
    end
end

% for ii = 1 : numel(imgsAll)
%     rp = randperm(numel(imgsAll{ii}));
%     imgsAll{ii} = imgsAll{ii}(rp);
%     bboxAll{ii} = bboxAll{ii}(rp);
%     sizeAll{ii} = sizeAll{ii}(rp);
%     propsAll{ii} = propsAll{ii}(rp);
%     label_B{ii} =  label_B{ii}(rp); 
%     objAll{ii} = objAll{ii}(rp);
% end
% iAll = imgsAll; bAll = bboxAll; sAll = sizeAll;
% pAll = propsAll; lAll = label_B; oAll = objAll;

imdb1.imagesA.name = {};
imdb1.bboxA.gtbox = {};
imdb1.bboxA.Imagesize = {};
imdb1.bboxA.label ={};
imdb1.bboxA.proposal ={};
imdb1.bboxA.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb1.imagesA.name = [imdb1.imagesA.name; imgsAll{ii}];
    imdb1.bboxA.gtbox = [imdb1.bboxA.gtbox; bboxAll{ii}];
    imdb1.bboxA.Imagesize = [imdb1.bboxA.Imagesize; sizeAll{ii}];
    imdb1.bboxA.label = [imdb1.bboxA.label; label_B{ii}];
    imdb1.bboxA.proposal = [imdb1.bboxA.proposal; propsAll{ii}];
    imdb1.bboxA.objlist = [imdb1.bboxA.objlist;objAll{ii}];
end
imdb1.imagesA.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb1.imagesA.set = [imdb1.imagesA.set;ones(numel(imdb1.imagesA.name),1)];
%% ImagesB
dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
props_dir(1:2) =[];
obj_list (1:2) =[];
%%
imgsAllN = cell(numel(dirList), 1);
bboxAllN = cell(numel(bboxList), 1);
sizeAllN = cell(numel(sizeList), 1);
label_BN = cell(numel(sizeList), 1);
propsAllN = cell(numel(props_dir), 1);
objAllN = cell(numel(obj_list));

for ii = 1 : numel(dirList)
    imgListN = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAllN{ii} = cell(floor(numel(imgListN)), 1);
    
    valueListN = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAllN{ii} = cell(floor(numel(valueListN)), 1);
   
    sizevalueListN = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAllN{ii} = cell(floor(numel(sizevalueListN)), 1);
    
    propsListN = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAllN{ii} = cell(floor(numel(propsListN)), 1);
    
    objListN = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAllN{ii} = cell(floor(numel(objListN)), 1);
    
    for jj = 1 : floor(numel(imgListN))
        j = randperm(numel(imgListN),1);
        imgsAllN{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgListN(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueListN(j).name));
        bboxAllN{ii}{jj} = inter_bbox.BBox';
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name,...
            sizevalueListN(j).name));
        sizeAllN{ii}{jj}= sizeImageInter.Imsize';
        
        propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
            propsListN(j).name));
        propsAllN{ii}{jj}= propsInter.props';
        
        [~, name_file,~] = fileparts(imgsAllN{ii}{jj});
        objInter = load(fullfile(object_list,obj_list(ii).name,...
            strcat(name_file,'.mat')));
        objAllN{ii}{jj,1}= objInter.label';
        
        label_BN{ii}{jj,1} = ii;
    end
end

%%
imgsAll = cell(numel(dirList), 1);
negAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
propsAll = cell(numel(props_dir), 1);
%rois_neg = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list),1);
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)*0.5), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)*0.5), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)*0.5), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(floor(numel(propsList)*0.5), 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)*0.5), 1);   
%     negList = length(dir(fullfile(szImagePath, dirList(ii).name, '*.jpg')));
%     negAll{ii} = cell(floor(negList), 1);
%     negprop{ii} = cell(floor(negList), 1);
%     
    for jj = 1 : floor(numel(imgList)*0.5)            
        j = randperm(numel(dirList),1);
        while j==ii,  j = randperm(numel(dirList),1); end
        list_neg = dir(fullfile(szImagePath, dirList(j).name, '*.jpg'));
        in = randperm(floor(numel(list_neg)),1);
        while any(objAllN{j, 1}{in, 1}==ii), 
           in = randperm(floor(numel(list_neg)),1);
        end 
        %while j == ii; j = randperm(numel(dirList),1); end
        %if any (imdb.bboxB.)
%        negAll{ii}{jj} = imgsAll{j,1}{in,1};
%        negprop{ii}{jj} = propsAll{j,1}{in,1}(randperm(5,1),:);
        imgsAll{ii}{jj} = imgsAllN{j,1}{in,1};
        bboxAll{ii}{jj} = bboxAllN{j,1}{in,1};
        sizeAll{ii}{jj}= sizeAllN{j,1}{in,1};
        propsAll{ii}{jj}= propsAllN{j,1}{in,1};
        objAll{ii}{jj,1}= objAllN{j,1}{in,1};
        label_B{ii}{jj,1} = label_BN{j,1}{in,1};
    end
end

% for ii = 1 : numel(imgsAll)
%     rp = randperm(numel(imgsAll{ii}));
%     imgsAll{ii} = imgsAll{ii}(rp);
%     bboxAll{ii} = bboxAll{ii}(rp);
%     sizeAll{ii} = sizeAll{ii}(rp);
%     propsAll{ii} = propsAll{ii}(rp);
%     label_B{ii} =  label_B{ii}(rp);   
%     objAll{ii} = objAll{ii}(rp);
%     
% end
imdb1.imagesB.name = {};
imdb1.bboxB.gtbox = {};
imdb1.bboxB.Imagesize = {};
imdb1.bboxB.label ={};
imdb1.bboxB.proposal ={};
imdb1.bboxB.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb1.imagesB.name = [imdb1.imagesB.name; imgsAll{ii}];
    imdb1.bboxB.gtbox = [imdb1.bboxB.gtbox; bboxAll{ii}];
    imdb1.bboxB.Imagesize = [imdb1.bboxB.Imagesize; sizeAll{ii}];
    imdb1.bboxB.label = [imdb1.bboxB.label; label_B{ii}];
    imdb1.bboxB.proposal = [imdb1.bboxB.proposal; propsAll{ii}];
    imdb1.bboxB.objlist = [imdb1.bboxB.objlist;objAll{ii}];
    
end
imdb1.imagesB.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb1.imagesB.set = [imdb1.imagesB.set;ones(numel(imdb1.imagesB.name),1)];
%%
imdb.imagesA.name = [imdb.imagesA.name; imdb1.imagesA.name];
imdb.imagesA.set = [imdb.imagesA.set ; imdb1.imagesA.set ];
imdb.bboxA.gtbox = [imdb.bboxA.gtbox ; imdb1.bboxA.gtbox ];
imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize ; imdb1.bboxA.Imagesize ];
imdb.bboxA.label = [imdb.bboxA.label ; imdb1.bboxA.label ];
imdb.bboxA.objlist = [imdb.bboxA.objlist; imdb1.bboxA.objlist];
imdb.bboxA.proposal = [imdb.bboxA.proposal; imdb1.bboxA.proposal];

imdb.imagesB.name = [imdb.imagesB.name; imdb1.imagesB.name];
imdb.imagesB.set = [imdb.imagesB.set ; imdb1.imagesB.set ];
imdb.bboxB.gtbox = [imdb.bboxB.gtbox ; imdb1.bboxB.gtbox ];
imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize ; imdb1.bboxB.Imagesize ];
imdb.bboxB.label = [imdb.bboxB.label ; imdb1.bboxB.label ];
imdb.bboxB.objlist = [imdb.bboxB.objlist; imdb1.bboxB.objlist];
imdb.bboxB.proposal = [imdb.bboxB.proposal; imdb1.bboxB.proposal];
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
imdb.bboxA.objlist = imdb.bboxA.objlist(shaffle_rp);
imdb.bboxB.objlist = imdb.bboxB.objlist(shaffle_rp);

%%
imdb.classes.name = {'aeroplane', 'bicycle', 'bird', ...
    'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
    'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
    'sofa', 'train', 'tvmonitor'};
