mode ='Train';
total_folders = dir (fullfile('G:', 'Pascal_BBox3',mode,...
    'Image_Size'));
total_folders(1,:)=[]; total_folders(1,:)=[];
%%
for i = 1: length (total_folders)
    
    %     gtBBox = load(fullfile(pwd,mode,total_folders(i).name, 'gtBBox.mat'));
    %     gtBBox = gtBBox.gtBBox;
    total_files = dir (fullfile('G:', 'Pascal_BBox3',mode,...
        'Image_Size',total_folders(i).name,'\*.mat'));
    mkdir(fullfile('G:\Pascal_BBox3',mode,'Proposals', total_folders(i).name ));
    for  j= 1:length(total_files)
        Image_size = load(fullfile('G:', 'Pascal_BBox3',mode,...
            'Image_Size',total_folders(i).name,...
            total_files(j).name));
        image_size = Image_size.Imsize;
        %%  Five proposals
        X = image_size(3); Y = image_size(4);
        P1 = round([1,1,X/2,Y/2]);
        P2 = round([X/2,1,X,Y/2]);
        P3 = round([1,Y/2,X/2,Y]);
        P4 = round([X/2,Y/2,X,Y]);
        P5 = round([X/4,Y/4,3*X/4, 3*Y/4]);
        P6 = [1,1,X,Y];
        props = [P1;P2;P3;P4;P5;P6]';
        %%
        display (strcat('Folder processing:', total_folders(i).name,'...' ,...
            'Image Processing:', num2str(j)));
        %%
        save (fullfile('G:\Pascal_BBox3',mode,'Proposals',...
            total_folders(i).name,total_files(j).name) ,...
            'props');
        clear Image_size image_size props ;
    end
    %         clear Area_bbox W H Max_BBox ind BBox BBox_8_8 P1 P2 P3 P3 Imsize_bbox_ROI...
    %             Imsize_bbox_gt BBox_center;
    %         clear xo yo w1 h1 Image_Box;
    clear total_files;
end
