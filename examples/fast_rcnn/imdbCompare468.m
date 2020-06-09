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
    imgsAll{ii} = cell(floor(numel(imgList)), 1);
    
    valueList = dir(fullfile(bbPath, bboxList(ii).name, '*.mat'));
    bboxAll{ii} = cell(floor(numel(valueList)), 1);
    
    sizevalueList = dir(fullfile(Image_Sizepath, sizeList(ii).name, '*.mat'));
    sizeAll{ii} = cell(floor(numel(sizevalueList)), 1);
    
    propsList = dir(fullfile(proposal_path, props_dir(ii).name, '*.mat'));
    propsAll{ii} = cell(floor(numel(propsList)), 1);
    
    objList = dir(fullfile(proposal_path, obj_list(ii).name, '*.mat'));
    objAll{ii} = cell(floor(numel(objList)), 1);
    
    for jj = 1 : floor(numel(imgList))
        %j = randperm(numel(imgList),1);
        imgsAll{ii}{jj} = fullfile(szImagePath, dirList(ii).name, imgList(jj).name);
        
        inter_bbox =  load(fullfile(bbPath, bboxList(ii).name, valueList(jj).name));
        bboxAll{ii}{jj} = inter_bbox.BBox';
        
        sizeImageInter = load(fullfile(Image_Sizepath, sizeList(ii).name,...
            sizevalueList(jj).name));
        sizeAll{ii}{jj}= sizeImageInter.Imsize';
        
        propsInter = load(fullfile(proposal_path, props_dir(ii).name,...
            propsList(jj).name));
        propsAll{ii}{jj}= propsInter.props';
        
        [~, name_file,~] = fileparts(imgsAll{ii}{jj});
        objInter = load(fullfile(object_list,obj_list(ii).name,...
            strcat(name_file,'.mat')));
        objAll{ii}{jj,1}= objInter.label';
        
        label_B{ii}{jj,1} = ii;
    end
end

imgsAll_reserved =  imgsAll;

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
%%
NP =5;
path_pascal3 = 'G:\Pascal_BBox3\Train\Images\';
szImagePath = 'G:\Sidra\matconvnet_1\data\VOC2007_6x2\';
dirList1 = dir(szImagePath);
dirList1 (1:2) = [];
imgsAll = cell(numel(dirList1), 1);
for ii = 1 : numel(dirList1)
    
    [name_folder,~] = strsplit(dirList1(ii).name,'_');
    imgList = dir(fullfile(szImagePath, dirList1(ii).name, '*.jpg'));
    imgsAll1{ii} = cell(floor(numel(imgList)), 1);
    bboxAll1{ii} = cell(floor(numel(imgList)), 1);
    sizeAll1{ii} = cell(floor(numel(imgList)), 1);
    propsAll1{ii} = cell(floor(numel(imgList)), 1);
    objAll1{ii} = cell(floor(numel(imgList)), 1);
    label_B1{ii} = cell(floor(numel(imgList)), 1);
    num_dir{ii} = cell(floor(numel(imgList)), 1);
    for jj = 1 : floor(numel(imgList))
        Number_Images(ii) = floor(numel(imgList));
        name_comb = fullfile(path_pascal3,name_folder(1),imgList(jj).name);
        IndexC = strfind(imdb1.imagesA.name,name_comb{1,1});
        Index = find(not(cellfun('isempty', IndexC)));
        if isempty(Index);
            a=1;
        end
        imgsAll1{ii}{jj} = imdb1.imagesA.name{Index(1)};
        bboxAll1{ii}{jj} = imdb1.bboxA.gtbox{Index(1)};
        sizeAll1{ii}{jj}=  imdb1.bboxA.Imagesize{Index(1)};
        propsAll1{ii}{jj}= imdb1.bboxA.proposal{Index(1)};
        objAll1{ii}{jj,1}= imdb1.bboxA.objlist{Index(1)};
        label_B1{ii}{jj,1} = imdb1.bboxA.label{Index(1)};
        num_dir{ii}{jj,1} = ii;
        clear name_comb IndexC Index;
    end
end
imdb.imagesB.name = {};
imdb.bboxB.gtbox = {};
imdb.bboxB.Imagesize = {};
imdb.bboxB.label ={};
imdb.bboxB.proposal ={};
imdb.bboxB.objlist ={};
imdb.bboxB.numdir ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesB.name = [imdb.imagesB.name; imgsAll1{ii}];
    imdb.bboxB.gtbox = [imdb.bboxB.gtbox; bboxAll1{ii}];
    imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize; sizeAll1{ii}];
    imdb.bboxB.proposal = [imdb.bboxB.proposal; propsAll1{ii}];
    imdb.bboxB.objlist = [imdb.bboxB.objlist;objAll1{ii}];
    imdb.bboxB.label = [imdb.bboxB.label;label_B1{ii}];
    imdb.bboxB.numdir = [imdb.bboxB.numdir;num_dir{ii}];
end
%%
imdb.imagesA.name = {};
imdb.bboxA.gtbox = {};
imdb.bboxA.Imagesize = {};
imdb.bboxA.label ={};
imdb.bboxA.proposal ={};
imdb.bboxA.objlist ={};

for ii = 1 : numel(imgsAll)
    imdb.imagesA.name = [imdb.imagesA.name; imgsAll1{ii}];
    imdb.bboxA.gtbox = [imdb.bboxA.gtbox; bboxAll1{ii}];
    imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize; sizeAll1{ii}];
    imdb.bboxA.proposal = [imdb.bboxA.proposal; propsAll1{ii}];
    imdb.bboxA.objlist = [imdb.bboxA.objlist;objAll1{ii}];
    imdb.bboxA.label = [imdb.bboxA.label;label_B1{ii}];
end
save('imdbCompare468.mat','imdb');