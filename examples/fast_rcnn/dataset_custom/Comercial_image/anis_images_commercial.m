function imdb = anis_images_commercial()
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
Number_images =5;
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(Number_images), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(Number_images), 1);
   
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(Number_images), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(floor(Number_images), 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(Number_images), 1);
    index_matrixA{ii} = cell(floor(Number_images), 1);
    for jj = 1 : floor(Number_images)
        new_ind = randperm(numel(imgList),1);
        while any(cell2mat(index_matrixA{1,ii})== new_ind)
            new_ind = randperm(numel(imgList),1); end
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
for ii = 1 : numel(imgsAll)
    rp = randperm(numel(imgsAll{ii}));
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
% imdb = load('imdb_2012_norepeatetive.mat');
% imdb = imdb.imdb;
 other_path = 'C:\G_drive_data\test_images_Pinterest\';
 other_path_google = 'C:\G_drive_data\test_images_google\';
for i=1:numel(imdb.imagesA.name)
    source = imdb.imagesA.name{i};
    [~,name,~] = fileparts(source);
    destination = strcat(other_path, name, '.jpg');
    copyfile (source, destination);
end
for i= 1: numel(imdb.imagesA.name)
    gtbbA = imdb.bboxA.gtbox{i};
    rdA = randperm(size(gtbbA,1),1); 
    imdb.bboxA.gt_single{i} =  gtbbA(rdA,:);
end
for i=1: numel(imdb.imagesA.name)
    image = imread(imdb.imagesA.name{i});
    source = imdb.imagesA.name{i};
    [~,name,~] = fileparts(source);
    bbox = imdb.bboxA.gt_single{i};
    image_size = imdb.bboxA.Imagesize{i};
    image_crop = imcrop(image, [bbox(1), bbox(2),...
        bbox(3)-bbox(1),...
        bbox(4)-bbox(2)]);
    imwrite (image_crop, strcat(other_path_google, name ,'.jpg'));
%     figure; imshow(image_crop);
%     figure; imshow(image);
end