imdb = load('imdb_2012_norepeatetive.mat');
imdb = imdb.imdb;
%%
path_gt = 'C:\Users\Sidra\Desktop\VOC and COCO\VOC2012\VOC2012_sorted\val\BBox\';
classes = {'aeroplane', 'bicycle', 'bird', ...
    'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
    'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
    'sofa', 'train', 'tvmonitor'};
for i= 20: numel(imdb.imagesA.name)
    [~, name, ~] = fileparts(imdb.imagesA.name{i});
    
    bbox = load(char(strcat(path_gt, classes(imdb.bboxA.label{i}), '\',...
        name, '.mat')));
    bbox_all = bbox.gtbox;
    box = [bbox_all(:,2),bbox_all(:,4),bbox_all(:,1), bbox_all(:,3)];
    if bbox.size(1)~=3
        box = [bbox_all(:,1),bbox_all(:,2),bbox_all(:,3), bbox_all(:,4)];
        imdb.bboxA.gtbox{i} = box;
        imdb.bboxA.Imagesize{i} = [1,1,bbox.size(1), bbox.size(2)];
    else 
        imdb.bboxA.gtbox{i} = box;
        imdb.bboxA.Imagesize{i} = [1,1,bbox.size(3), bbox.size(2)];  
    end
    imshow(imread(imdb.imagesA.name{i})); hold on;
   
    for k=1:size(box)
    rectangle ('Position', [box(k,1),box(k,2),...
        box(k,3)-box(k,1), box(k,4)-box(k,2)]);
    end
    clear bbox;
end
for i= 1: numel(imdb.imagesA.name)
    gtbbA = imdb.bboxA.gtbox{i};
    rdA = randperm(size(gtbbA,1),1); 
    imdb.bboxA.gt_single{i} =  gtbbA(rdA,:);
end
%% image B
for i= 1: numel(imdb.imagesB.name)
    [~, name, ~] = fileparts(imdb.imagesB.name{i});
    
    bbox = load(char(strcat(path_gt, classes(imdb.bboxB.label{i}), '\',...
        name, '.mat')));
    bbox_all = bbox.gtbox;
    box = [bbox_all(:,2),bbox_all(:,4),bbox_all(:,1), bbox_all(:,3)];
    if bbox.size(1)~=3
        box = [bbox_all(:,1),bbox_all(:,2),bbox_all(:,3), bbox_all(:,4)];
        imdb.bboxB.gtbox{i} = box;
        imdb.bboxB.Imagesize{i} = [1,1,bbox.size(1), bbox.size(2)];
    else 
        imdb.bboxB.gtbox{i} = box;
        imdb.bboxA.Imagesize{i} = [1,1,bbox.size(3), bbox.size(2)];  
    end
    imshow(imread(imdb.imagesB.name{i})); hold on;
   
    for k=1:size(box)
    rectangle ('Position', [box(k,1),box(k,2),...
        box(k,3)-box(k,1), box(k,4)-box(k,2)]);
    end
    clear bbox;
end
save('imdb_2012_nonrepeatative_correct.mat','imdb');