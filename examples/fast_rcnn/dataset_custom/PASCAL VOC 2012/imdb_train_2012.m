function imdb = imdb_train_2012()
%% Image A
path_to_data = '/data/sidra/VOC2012_sorted/train';
szImagePath = fullfile(path_to_data, 'Images');
bbPath = fullfile(path_to_data, 'BBoxcort');
Image_Sizepath =  fullfile(path_to_data, 'Image_Sizecort');
% proposal_path =  fullfile(path_to_data, 'Proposals');
object_list = fullfile(path_to_data, 'object_list');

dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
% props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
% props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
% propsAll = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list));
N=2.5;
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)/N), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)/N), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)/N), 1);
    
%     propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
%     propsAll{ii} = cell(floor(numel(propsList)/2), 1);
    
    objList = dir(fullfile(object_list, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)/N), 1);
    index_matrixA{ii} = cell(floor(numel(objList)/N), 1);
    for jj = 1 : floor(numel(imgList)/N)
%         j = randperm(numel(imgList),1);
        new_ind = randperm(numel(imgList),1);
        while any(cell2mat(index_matrixA{1,ii})== new_ind)
            new_ind = randperm(numel(imgList),1); end
        index_matrixA{ii}{jj}= new_ind;
        j= index_matrixA{ii}{jj};
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(j).name));
        bboxAll{ii}{jj} = inter_bbox.gtbox;
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name,...
            sizevalueList(j).name));
        sizeAll{ii}{jj}= sizeImageInter.Image_size;
        
%         propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
%             propsList(j).name));
%         propsAll{ii}{jj}= propsInter.props';
        
        [~, name_file,~] = fileparts(imgsAll{ii}{jj});
        objInter = load(fullfile(object_list,obj_list(ii).name,...
            strcat(name_file,'.mat')));
        objAll{ii}{jj,1}= objInter.label';
        
        label_B{ii}{jj,1} = ii;
    end
end

imgsAll_reserved =  imgsAll;
for ii = 1 : numel(imgsAll)
    rp = randperm(numel(imgsAll{ii}));
    imgsAll{ii} = imgsAll{ii}(rp);
    bboxAll{ii} = bboxAll{ii}(rp);
    sizeAll{ii} = sizeAll{ii}(rp);
%     propsAll{ii} = propsAll{ii}(rp);
    label_B{ii} =  label_B{ii}(rp); 
    objAll{ii} = objAll{ii}(rp);
end
imdb.imagesA.name = {};
imdb.bboxA.gtbox = {};
imdb.bboxA.Imagesize = {};
imdb.bboxA.label ={};
% imdb.bboxA.proposal ={};
imdb.bboxA.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesA.name = [imdb.imagesA.name; imgsAll{ii}];
    imdb.bboxA.gtbox = [imdb.bboxA.gtbox; bboxAll{ii}];
    imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize; sizeAll{ii}];
    imdb.bboxA.label = [imdb.bboxA.label; label_B{ii}];
%     imdb.bboxA.proposal = [imdb.bboxA.proposal; propsAll{ii}];
    imdb.bboxA.objlist = [imdb.bboxA.objlist;objAll{ii}];
end
imdb.imagesA.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb.imagesA.set = [imdb.imagesA.set;ones(numel(imdb.imagesA.name),1)];
%% ImagesB
dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
% props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
% props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
% propsAll = cell(numel(props_dir), 1);
%rois_neg = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list),1);
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)/N), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)/N), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)/N), 1);
    
%     propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
%     propsAll{ii} = cell(floor(numel(propsList)/2), 1);
    
    objList = dir(fullfile(object_list, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)/N), 1);
    index_matrixB{ii} = cell(floor(numel(objList)/N), 1); 
    for jj = 1 : floor(numel(imgList)/N)
        new_ind = randperm(numel(imgList),1);
%         if ii~=17
            while any(cell2mat(index_matrixA{1,ii})== new_ind) ||...
                    any(cell2mat(index_matrixB{1,ii})== new_ind)
                new_ind = randperm(numel(imgList),1); end
%         else
%             if jj>=88
%                 new_ind = randperm(numel(imgList),1);
%             end
%         end
        index_matrixB{ii}{jj}= new_ind;
        j= index_matrixB{ii}{jj};
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(j).name));
        bboxAll{ii}{jj} = inter_bbox.gtbox;
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name, ...
            sizevalueList(j).name));
        sizeAll{ii}{jj}= sizeImageInter.Image_size;
        
%         propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
%             propsList(j).name));
%         propsAll{ii}{jj}= propsInter.props';
        
        [~, name_file,~] = fileparts(imgsAll{ii}{jj});
        objInter = load(fullfile(object_list,obj_list(ii).name,...
            strcat(name_file,'.mat')));
        objAll{ii}{jj,1}= objInter.label';
        
        label_B{ii}{jj,1} = ii;
    end
end

%%
for ii = 1 : numel(imgsAll)
    rp = randperm(numel(imgsAll{ii}));
    imgsAll{ii} = imgsAll{ii}(rp);
    bboxAll{ii} = bboxAll{ii}(rp);
    sizeAll{ii} = sizeAll{ii}(rp);
%     propsAll{ii} = propsAll{ii}(rp);
    label_B{ii} =  label_B{ii}(rp);   
    objAll{ii} = objAll{ii}(rp);
    
end
imdb.imagesB.name = {};
imdb.bboxB.gtbox = {};
imdb.bboxB.Imagesize = {};
imdb.bboxB.label ={};
% imdb.bboxB.proposal ={};
imdb.bboxB.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesB.name = [imdb.imagesB.name; imgsAll{ii}];
    imdb.bboxB.gtbox = [imdb.bboxB.gtbox; bboxAll{ii}];
    imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize; sizeAll{ii}];
    imdb.bboxB.label = [imdb.bboxB.label; label_B{ii}];
%     imdb.bboxB.proposal = [imdb.bboxB.proposal; propsAll{ii}];
    imdb.bboxB.objlist = [imdb.bboxB.objlist;objAll{ii}];
    
end
imdb.imagesB.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb.imagesB.set = [imdb.imagesB.set;ones(numel(imdb.imagesB.name),1)];

%% Negative samples
% path_to_data = 'C:\Users\Sidra\Desktop\VOC and COCO\VOC2012\VOC2012_sorted\train';
szImagePath = fullfile(path_to_data, 'Images');
bbPath = fullfile(path_to_data, 'BBoxcort');
Image_Sizepath =  fullfile(path_to_data, 'Image_Sizecort');
% proposal_path =  fullfile(path_to_data, 'Proposals');
object_list = fullfile(path_to_data, 'object_list');

dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
% props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
% props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
% propsAll = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list));
N =3.6;
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)/N), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)/N), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)/N), 1);
    
%     propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
%     propsAll{ii} = cell(floor(numel(propsList)/3), 1);
    
    objList = dir(fullfile(object_list, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)/N), 1);
    index_matrixA{ii} = cell(floor(numel(objList)/N), 1);
    for jj = 1 : floor(numel(imgList)/N)
%         j = randperm(numel(imgList),1);
        new_ind = randperm(numel(imgList),1);
        while any(cell2mat(index_matrixA{1,ii})== new_ind)
            new_ind = randperm(numel(imgList),1); end
        index_matrixA{ii}{jj}= new_ind;
        j= index_matrixA{ii}{jj};
%     for jj = 1 : floor(numel(imgList)/3)
%         j = randperm(numel(imgList),1);
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(j).name));
        bboxAll{ii}{jj} = inter_bbox.gtbox;
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name,...
            sizevalueList(j).name));
        sizeAll{ii}{jj}= sizeImageInter.Image_size;
        
%         propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
%             propsList(j).name));
%         propsAll{ii}{jj}= propsInter.props';
        
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
imdb1.imagesA.name = {};
imdb1.bboxA.gtbox = {};
imdb1.bboxA.Imagesize = {};
imdb1.bboxA.label ={};
% imdb1.bboxA.proposal ={};
imdb1.bboxA.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb1.imagesA.name = [imdb1.imagesA.name; imgsAll{ii}];
    imdb1.bboxA.gtbox = [imdb1.bboxA.gtbox; bboxAll{ii}];
    imdb1.bboxA.Imagesize = [imdb1.bboxA.Imagesize; sizeAll{ii}];
    imdb1.bboxA.label = [imdb1.bboxA.label; label_B{ii}];
%     imdb1.bboxA.proposal = [imdb1.bboxA.proposal; propsAll{ii}];
    imdb1.bboxA.objlist = [imdb1.bboxA.objlist;objAll{ii}];
end
imdb1.imagesA.set = [];
%for ii = 1 : numel(triplets.imageA)

imdb1.imagesA.set = [imdb1.imagesA.set;ones(numel(imdb1.imagesA.name),1)];
%% reserve image iAll
% path_to_data = 'C:\Users\Sidra\Desktop\VOC and COCO\VOC2012\VOC2012_sorted\train';
szImagePath = fullfile(path_to_data, 'Images');
bbPath = fullfile(path_to_data, 'BBoxcort');
Image_Sizepath =  fullfile(path_to_data, 'Image_Sizecort');
% proposal_path =  fullfile(path_to_data, 'Proposals');
object_list = fullfile(path_to_data, 'object_list');

dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
% props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
% props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
% propsAll = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list));

for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)), 1);
    
%     propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
%     propsAll{ii} = cell(floor(numel(propsList)), 1);
    
    objList = dir(fullfile(object_list, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)), 1);
    
    for jj = 1 : floor(numel(imgList))
        j = randperm(numel(imgList),1);
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(j).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(j).name));
        bboxAll{ii}{jj} = inter_bbox.gtbox;
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name,...
            sizevalueList(j).name));
        sizeAll{ii}{jj}= sizeImageInter.Image_size;
        
%         propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
%             propsList(j).name));
%         propsAll{ii}{jj}= propsInter.props';
        
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
iAll = imgsAll; bAll = bboxAll; sAll = sizeAll;
% pAll = propsAll; 
lAll = label_B; oAll = objAll;
%% ImagesB
dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
% props_dir =dir (proposal_path);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
% props_dir(1:2) =[];
obj_list (1:2) =[];

imgsAll = cell(numel(dirList), 1);
negAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
% propsAll = cell(numel(props_dir), 1);
%rois_neg = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list),1);
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)/N), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)/N), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)/N), 1);
    
%     propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
%     propsAll{ii} = cell(floor(numel(propsList)), 1);
    
    objList = dir(fullfile(object_list, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)/N), 1);   
%     negList = length(dir(fullfile(szImagePath, dirList(ii).name, '*.jpg')));
%     negAll{ii} = cell(floor(negList), 1);
%     negprop{ii} = cell(floor(negList), 1);
%     
    for jj = 1 : floor(numel(imgList)/N)            
        j = randperm(numel(dirList),1);
        while j==ii,  j = randperm(numel(dirList),1); end
        list_neg = dir(fullfile(szImagePath, dirList(j).name, '*.jpg'));
        in = randperm(floor(numel(list_neg)),1);
        while any(oAll{j, 1}{in, 1}==ii), 
           in = randperm(floor(numel(list_neg)),1);
        end 
        %while j == ii; j = randperm(numel(dirList),1); end
        %if any (imdb.bboxB.)
%        negAll{ii}{jj} = imgsAll{j,1}{in,1};
%        negprop{ii}{jj} = propsAll{j,1}{in,1}(randperm(5,1),:);
        imgsAll{ii}{jj} = iAll{j,1}{in,1};
        bboxAll{ii}{jj} = bAll{j,1}{in,1};
        sizeAll{ii}{jj}= sAll{j,1}{in,1};
%         propsAll{ii}{jj}= pAll{j,1}{in,1};
        objAll{ii}{jj,1}= oAll{j,1}{in,1};
        label_B{ii}{jj,1} = lAll{j,1}{in,1};
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
% imdb1.bboxB.proposal ={};
imdb1.bboxB.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb1.imagesB.name = [imdb1.imagesB.name; imgsAll{ii}];
    imdb1.bboxB.gtbox = [imdb1.bboxB.gtbox; bboxAll{ii}];
    imdb1.bboxB.Imagesize = [imdb1.bboxB.Imagesize; sizeAll{ii}];
    imdb1.bboxB.label = [imdb1.bboxB.label; label_B{ii}];
%     imdb1.bboxB.proposal = [imdb1.bboxB.proposal; propsAll{ii}];
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
% imdb.bboxA.proposal = [imdb.bboxA.proposal; imdb1.bboxA.proposal];

imdb.imagesB.name = [imdb.imagesB.name; imdb1.imagesB.name];
imdb.imagesB.set = [imdb.imagesB.set ; imdb1.imagesB.set ];
imdb.bboxB.gtbox = [imdb.bboxB.gtbox ; imdb1.bboxB.gtbox ];
imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize ; imdb1.bboxB.Imagesize ];
imdb.bboxB.label = [imdb.bboxB.label ; imdb1.bboxB.label ];
imdb.bboxB.objlist = [imdb.bboxB.objlist; imdb1.bboxB.objlist];
% imdb.bboxB.proposal = [imdb.bboxB.proposal; imdb1.bboxB.proposal];
%%
shaffle_rp = randperm(numel(imdb.imagesA.name));
imdb.imagesA.name = imdb.imagesA.name(shaffle_rp);
imdb.imagesA.set = imdb.imagesA.set(shaffle_rp);
imdb.bboxA.gtbox = imdb.bboxA.gtbox(shaffle_rp);
imdb.bboxA.Imagesize = imdb.bboxA.Imagesize(shaffle_rp);
% imdb.bboxA.proposal = imdb.bboxA.proposal(shaffle_rp);
imdb.bboxA.label = imdb.bboxA.label(shaffle_rp);
imdb.imagesB.name = imdb.imagesB.name(shaffle_rp);
imdb.imagesB.set = imdb.imagesB.set(shaffle_rp);
imdb.bboxB.gtbox = imdb.bboxB.gtbox(shaffle_rp);
imdb.bboxB.Imagesize = imdb.bboxB.Imagesize(shaffle_rp);
% imdb.bboxB.proposal = imdb.bboxB.proposal(shaffle_rp);
imdb.bboxB.label = imdb.bboxB.label(shaffle_rp);
imdb.bboxA.objlist = imdb.bboxA.objlist(shaffle_rp);
imdb.bboxB.objlist = imdb.bboxB.objlist(shaffle_rp);

%%
imdb.classes.name = {'aeroplane', 'bicycle', 'bird', ...
    'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
    'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
    'sofa', 'train', 'tvmonitor'};
