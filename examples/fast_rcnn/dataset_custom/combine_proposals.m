data_dir= 'C:\G_drive_data\Pascal_BBox3\Train';
T_1 = fullfile(data_dir, 'saliency_mat_train_1');
T_2 = fullfile(data_dir, 'saliency_mat_train_2');
T_3 = fullfile(data_dir, 'saliency_mat_train_3');
Image_size = fullfile(data_dir, 'Image_Size');
Image_path = fullfile(data_dir, 'Images');
Proposal_path = fullfile(data_dir, 'Salient_proposal');
proposal_image_path = fullfile(data_dir, 'image_proposal');
%%
Image_folder = dir (Image_path); Image_folder(1:2)=[];
for i= 1:numel(Image_folder)
    subfolder = dir(fullfile(Image_path, Image_folder(i).name,'*.jpg'));
    mkdir(fullfile(Proposal_path, Image_folder(i).name));
    mkdir(fullfile(proposal_image_path, Image_folder(i).name));
    for j=1:numel(subfolder)
    [~, name, ~] = fileparts(subfolder(j).name);     
    t1 = load(fullfile(T_1,Image_folder(i).name, strcat(name, '.mat')));
    if iscell(t1.B_reduced), t1 = cell2mat(t1.B_reduced); 
    else, t1 = t1.B_reduced; end
    t2 = load(fullfile(T_2,Image_folder(i).name, strcat(name, '.mat')));
     if iscell(t2.B_reduced), t2 = cell2mat(t2.B_reduced); 
    else, t2 = t2.B_reduced; end
    t3 = load(fullfile(T_3,Image_folder(i).name, strcat(name, '.mat')));
     if iscell(t3.B_reduced), t3 = cell2mat(t3.B_reduced); 
    else, t3 = t3.B_reduced; end
    %
    I_s = load(fullfile(Image_size,Image_folder(i).name, strcat(name, '.mat')));
    I_s = I_s.Imsize';
    %
    P = vertcat(t1,t2,t3);
    if isempty(P)
        B1= I_s;
    else
    B1= bbox_remove_duplicates_overlap(P, 30, inf);
    B1 = vertcat(I_s,B1);
    end
    save (fullfile(Proposal_path, Image_folder(i).name,...
        strcat(name, '.mat')),'B1');
    figure; 
    image = fullfile(Image_path, Image_folder(i).name,strcat(name,'.jpg'));
    imshow(image);
    for k = 1 :size(B1,1)
    hold on;
    
        rectangle('Position', [B1(k,1),B1(k,2), B1(k,3)- B1(k,1),...
            B1(k,4)- B1(k,2)], 'EdgeColor', 'r','LineWidth',2);
    end
    saveas(gcf,fullfile(proposal_image_path, Image_folder(i).name,...
        strcat(name, '.png')));
    clear t1 t2 t3 B1 P I_s;
    close all;
    end
end
