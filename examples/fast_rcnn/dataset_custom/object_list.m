path_to_data = 'G:\Pascal_BBox3\Test';
path_to_objects = fullfile(path_to_data, 'object_list');
szImagePath = fullfile(path_to_data, 'Images');
dirList = dir(szImagePath);
dirList (1:2) = [];
imgsAll = cell(numel(dirList), 1);
for ii = 1 : numel(dirList)
    imgList = dir(fullfile(szImagePath, dirList(ii).name, '*.jpg'));
    imgsAll{ii} = cell(floor(numel(imgList)), 1);
    mkdir (fullfile(path_to_objects, dirList(ii).name));
    for jj = 1 : floor(numel(imgList))
       names = imgList(jj).name; label =[];
       [~,name_save,~] = fileparts(names);
       for kk = 1 : numel(dirList)
           a= dir(fullfile(szImagePath, dirList(kk).name,'*.jpg')); %  or  a=dir('folder')
           b=struct2cell(a);
           status = any(ismember(b(1,:),names));
           if status ==1,label = [label;kk]; end
       end
       save (fullfile(path_to_objects,dirList(ii).name,strcat(name_save,'.mat')) ,...
            'label');
       clear label a b status name name_save;
    end
end