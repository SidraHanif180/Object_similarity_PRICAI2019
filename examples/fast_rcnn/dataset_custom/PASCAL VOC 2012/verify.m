image_path = 'C:\Users\Sidra\Desktop\VOC and COCO\VOC2012\VOC2012_sorted\val';
class = 'aeroplane';
bbox_total = dir(fullfile(image_path, 'BBox', class,  '*.mat'));
Images_total = dir(fullfile(image_path, 'Images', class, '*.jpg'));
for i=20: numel(Images_total)
    I = imread(fullfile(image_path, 'Images', class,'2011_001800.jpg'));
    %Images_total(i).name));
    bbox = load(fullfile(image_path, 'BBox', class,'2011_001800.mat'));
    %bbox_total(i).name));
    b = bbox.gtbox;
    figure; imshow(I);
    hold on;
    for k =1:size(b,1)
        rectangle('Position', [b(k,1), b(k,2), b(k,3)-b(k,1), b(k,4)-b(k,2)],...
            'EdgeColor','r','LineWidth',3);
    end
end