imdb = load('imdb_2012_norepeatetive.mat');
imdb = imdb.imdb;
%%
path_to_data = 'C:\Users\Sidra\Desktop\VOC and COCO\VOC2012\VOC2012_sorted\val';
szImagePath = fullfile(path_to_data, 'Images');
bbPath = fullfile(path_to_data, 'BBox\');
Image_Sizepath =  fullfile(path_to_data, 'Image_Size\');
object_list = fullfile(path_to_data, 'object_list');

dirList = dir(szImagePath);
bboxList = dir(bbPath);
sizeList = dir(Image_Sizepath);
obj_list = dir (object_list);
dirList (1:2) = [];
bboxList(1:2) = [];
sizeList(1:2) =[];
obj_list (1:2) =[];
%% save paths
path_to_data = 'C:\Users\Sidra\Desktop\VOC and COCO\VOC2012\VOC2012_sorted\val';
bbPathsave = fullfile(path_to_data, 'BBoxcort\');
Image_Sizepathsave =  fullfile(path_to_data, 'Image_Sizecort\');
mkdir(bbPathsave); mkdir(Image_Sizepathsave); 
%%
% path_gt = 'C:\Users\Sidra\Desktop\VOC and COCO\VOC2012\VOC2012_sorted\val\BBox\';
classes = {'aeroplane', 'bicycle', 'bird', ...
    'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
    'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
    'sofa', 'train', 'tvmonitor'};
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    mkdir(fullfile(bbPathsave,dirList(ii).name)); 
    mkdir(fullfile(Image_Sizepathsave,dirList(ii).name)); 
    for jj = 1 : floor(numel(imgList))
        full_name = fullfile(szImagePath, dirList(ii).name, imgList(jj).name);
        im = imread(full_name);
        [~, name,~] = fileparts(full_name);
% for i= 1: numel(imdb.imagesA.name)
%     [~, name, ~] = fileparts(imdb.imagesA.name{i});
        bbox = load(char(strcat(bbPath, dirList(ii).name, '\',...
        name, '.mat')));
    bbox_all = bbox.gtbox;
    gtbox = [bbox_all(:,2),bbox_all(:,4),bbox_all(:,1), bbox_all(:,3)];
    if bbox.size(1)~=3
        gtbox = [bbox_all(:,1),bbox_all(:,2),bbox_all(:,3), bbox_all(:,4)];
%         imdb.bboxA.gtbox{i} = gtbox;
        Image_size = [1,1,bbox.size(1), bbox.size(2)];
    else 
%         imdb.bboxA.gtbox{i} = gtbox;
        Image_size = [1,1,bbox.size(3), bbox.size(2)];  
    end
%     imshow(im); hold on;
%     for k=1:size(gtbox)
%         rectangle ('Position', [gtbox(k,1),gtbox(k,2),...
%             gtbox(k,3)-gtbox(k,1), gtbox(k,4)-gtbox(k,2)]);
%     end
    save (char(strcat(bbPathsave, dirList(ii).name, '\',...
        name, '.mat')), 'gtbox');
    save (char(strcat(Image_Sizepathsave, dirList(ii).name, '\',...
        name, '.mat')), 'Image_size');
    clear bbox;
    end
end
% for i= 1: numel(imdb.imagesA.name)
%     gtbbA = imdb.bboxA.gtbox{i};
%     rdA = randperm(size(gtbbA,1),1); 
%     imdb.bboxA.gt_single{i} =  gtbbA(rdA,:);
% end
%% image B
for i= 1: numel(imdb.imagesB.name)
    [~, name, ~] = fileparts(imdb.imagesB.name{i});
    
    bbox = load(char(strcat(path_gt, classes(imdb.bboxB.label{i}), '\',...
        name, '.mat')));
    bbox_all = bbox.gtbox;
    gtbox = [bbox_all(:,2),bbox_all(:,4),bbox_all(:,1), bbox_all(:,3)];
    if bbox.size(1)~=3
        gtbox = [bbox_all(:,1),bbox_all(:,2),bbox_all(:,3), bbox_all(:,4)];
        imdb.bboxB.gtbox{i} = gtbox;
        imdb.bboxB.Imagesize{i} = [1,1,bbox.size(1), bbox.size(2)];
    else 
        imdb.bboxB.gtbox{i} = gtbox;
        imdb.bboxA.Imagesize{i} = [1,1,bbox.size(3), bbox.size(2)];  
    end
    imshow(imread(imdb.imagesB.name{i})); hold on;
   
    for k=1:size(gtbox)
    rectangle ('Position', [gtbox(k,1),gtbox(k,2),...
        gtbox(k,3)-gtbox(k,1), gtbox(k,4)-gtbox(k,2)]);
    end
    clear bbox;
end
save('imdb_2012_nonrepeatative_correct.mat','imdb');