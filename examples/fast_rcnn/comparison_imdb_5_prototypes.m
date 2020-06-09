path_pascal3 = 'G:\Pascal_BBox3\Train\Images\';
PrototyePath = 'G:\Sidra\matconvnet_1\examples\fast_rcnn\Prototype_list\';
dirList1 = dir(PrototyePath);
dirList1 (1:2) = [];

for ii = 1 : numel(dirList1)
    
    [name_folder,~] = strsplit(dirList1(ii).name,'_');
    imgList = dir(fullfile(PrototyePath, dirList1(ii).name, '*.jpg'));
    imgsAll1{ii} = cell(floor(numel(imgList)), 1);
    valueList = dir(fullfile(PrototyePath, dirList1(ii).name, '*.mat'));
    bboxAll1{ii} = cell(floor(numel(valueList)), 1);
    num_dir{ii} = cell(floor(numel(imgList)), 1);
    for jj = 1 : floor(numel(imgList))
        imgsAll1{ii}{jj} = fullfile(PrototyePath, dirList1(ii).name, imgList(jj).name);
        inter_bbox =  load(fullfile(PrototyePath, dirList1(ii).name, valueList(jj).name));
        bboxAll1{ii}{jj} = inter_bbox.gt';
        num_dir{ii}{jj,1} = ii;
    end
end
imdb.imagesA.name = {};
imdb.bboxA.gtbox = {};
imdb.bboxA.numdir= {};
for ii = 1 : numel(imgsAll1)
    imdb.imagesA.name = [imdb.imagesA.name; imgsAll1{ii}];
    imdb.bboxA.gtbox = [imdb.bboxA.gtbox; bboxAll1{ii}];
    imdb.bboxA.numdir = [imdb.bboxA.numdir; num_dir{ii}];
end
%%
% imdb.imagesA.name = {};
% imdb.bboxA.gtbox = {};
% imdb.bboxA.Imagesize = {};
% imdb.bboxA.label ={};
% imdb.bboxA.proposal ={};
% imdb.bboxA.objlist ={};
%
% for ii = 1 : numel(imgsAll)
%     imdb.imagesA.name = [imdb.imagesA.name; imgsAll1{ii}];
%     imdb.bboxA.gtbox = [imdb.bboxA.gtbox; bboxAll1{ii}];
%     imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize; sizeAll1{ii}];
%     imdb.bboxA.proposal = [imdb.bboxA.proposal; propsAll1{ii}];
%     imdb.bboxA.objlist = [imdb.bboxA.objlist;objAll1{ii}];
%     imdb.bboxA.label = [imdb.bboxA.label;label_B1{ii}];
% end
save('imdbCompare_1000.mat','imdb');