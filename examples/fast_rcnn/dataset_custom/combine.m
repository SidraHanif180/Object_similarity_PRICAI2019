function imdb = combine(imdb_combine1,imdb_combine2)
imdb.imagesA.name = [imdb_combine1.imagesA.name;imdb_combine2.imagesA.name ];
imdb.imagesA.set = [imdb_combine1.imagesA.set; imdb_combine2.imagesA.set ];
imdb.bboxA.gtbox = [imdb_combine1.bboxA.gtbox;imdb_combine2.bboxA.gtbox ];
imdb.bboxA.Imagesize = [imdb_combine1.bboxA.Imagesize; imdb_combine2.bboxA.Imagesize ];
imdb.bboxA.label = [imdb_combine1.bboxA.label;imdb_combine2.bboxA.label ];
imdb.bboxA.objlist = [imdb_combine1.bboxA.objlist; imdb_combine2.bboxA.objlist];
% imdb.bboxA.proposal = [imdb_combine1.bboxA.proposal; imdb_combine2.bboxA.proposal];

imdb.imagesB.name = [imdb_combine1.imagesB.name;imdb_combine2.imagesB.name ];
imdb.imagesB.set = [imdb_combine1.imagesB.set; imdb_combine2.imagesB.set ];
imdb.bboxB.gtbox =[imdb_combine1.bboxB.gtbox;imdb_combine2.bboxB.gtbox];
imdb.bboxB.Imagesize =[imdb_combine1.bboxB.Imagesize; imdb_combine2.bboxB.Imagesize ];
imdb.bboxB.label = [imdb_combine1.bboxB.label;imdb_combine2.bboxB.label ];
% imdb.bboxB.proposal =[imdb_combine1.bboxB.proposal; imdb_combine2.bboxB.proposal];
imdb.bboxB.objlist =[imdb_combine1.bboxB.objlist; imdb_combine2.bboxB.objlist];

% imdb.classes.name = {'aeroplane', 'bicycle', 'bird', ...
%     'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
%     'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
%     'sofa', 'train', 'tvmonitor'};