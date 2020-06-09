function imdb = imdb_test_nonrepetitive_train()
%% Image A
path_to_data = 'C:\G_drive_data\Pascal_BBox3\Test';
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
Number_query = 50;
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(Number_query, 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(Number_query, 1);
    
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(Number_query, 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(Number_query, 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(Number_query, 1);
    index_matrixA{ii} = cell(Number_query, 1);
    for jj = 1 : Number_query
        new_ind = randperm(numel(imgList),1);
        if ii~=17
            while any(cell2mat(index_matrixA{1,ii})== new_ind)
                new_ind = randperm(numel(imgList),1); end
        else
            if jj>=97
                new_ind = randperm(numel(imgList),1);
            else
                while any(cell2mat(index_matrixA{1,ii})== new_ind)
                    new_ind = randperm(numel(imgList),1); end
            end
        end
        
        index_matrixA{ii}{jj}= new_ind;
        j= index_matrixA{ii}{jj};
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
% for ii = 1 : numel(imgsAll)
%     rp = randperm(numel(imgsAll{ii}));
%     imgsAll{ii} = imgsAll{ii}(rp);
%     bboxAll{ii} = bboxAll{ii}(rp);
%     sizeAll{ii} = sizeAll{ii}(rp);
%     propsAll{ii} = propsAll{ii}(rp);
%     label_B{ii} =  label_B{ii}(rp);
%     objAll{ii} = objAll{ii}(rp);
% end
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

imdb.imagesA.set = [imdb.imagesA.set;3*ones(numel(imdb.imagesA.name),1)];
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
Number_database = 50;

imgsAll = cell(numel(dirList), 1);
bboxAll = cell(numel(bboxList), 1);
sizeAll = cell(numel(sizeList), 1);
label_B = cell(numel(sizeList), 1);
propsAll = cell(numel(props_dir), 1);
%rois_neg = cell(numel(props_dir), 1);
objAll = cell(numel(obj_list),1);
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(Number_database, 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(Number_database, 1);
    
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(Number_database, 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(Number_database, 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(Number_database, 1);
    index_matrixB{ii} = cell(Number_database, 1);
    for jj = 1 : Number_database
        new_ind = randperm(numel(imgList),1);
        if ii~=17
            while any(cell2mat(index_matrixA{1,ii})== new_ind) ||...
                    any(cell2mat(index_matrixB{1,ii})== new_ind)
                new_ind = randperm(numel(imgList),1); end
        else
            if jj>=45
                new_ind = randperm(numel(imgList),1);
            else
                while any(cell2mat(index_matrixA{1,ii})== new_ind)
                    new_ind = randperm(numel(imgList),1); end
            end
        end
        index_matrixB{ii}{jj}= new_ind;
        j= index_matrixB{ii}{jj};
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

imdb.imagesB.set = [imdb.imagesB.set;3*ones(numel(imdb.imagesB.name),1)];

%%
imdb.classes.name = {'aeroplane', 'bicycle', 'bird', ...
    'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
    'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
    'sofa', 'train', 'tvmonitor'};
%% attach single GT
imdb.bboxA.gt_single = cell(numel(imdb.imagesA.name),1);
%%

for i= 1: numel(imdb.imagesA.name)
    gtbbA = imdb.bboxA.gtbox{i};
    Area = (gtbbA(:,3)-gtbbA(:,1)).*(gtbbA(:,4)-gtbbA(:,2));
    [~,rdA] = max(Area);
    imdb.bboxA.gt_single{i} =  gtbbA(rdA(1),:);
    clear gtbbA Area rdA;
end
%%
%save('imdb_nonrepetitive_2007.mat', 'imdb');