function imdb = attach_proposals_onefixed(imdb)
imdb.bboxB.target = cell(numel(imdb.imagesB.name),1);
imdb.bboxB.target_gt = cell(numel(imdb.imagesB.name),1);
imdb.bboxA.gt_single = cell(numel(imdb.imagesA.name),1);
%%

for i= 1: numel(imdb.imagesA.name)
    gtbbA = imdb.bboxA.gtbox{i};
    rdA = randperm(size(gtbbA,1),1); 
    imdb.bboxA.gt_single{i} =  gtbbA(rdA,:);
end

%%
for i= 1: numel(imdb.imagesA.name)
    pbox = imdb.bboxB.proposal{i};
    gtbb = imdb.bboxB.gtbox{i};
    rd = randperm(size(gtbb,1),1); 
    gtbox_single =  gtbb(rd,:);
    ind = min_box(single(pbox),single(gtbox_single));
    %[~, idx] = max(iou);    
    %[~, idx] = sort(iou, 'descend');
    target1 = pbox(ind,:);
    %rd = randperm(size(proposals_set,1),1);    
    %target1 = proposals_set(rd,:);
    imdb.bboxB.target{i} = target1;
%     iou_gt = bbox_overlap_proposal(target1,single(gtbb));
%     %iou_gt = bbox_overlap_gt(single(gtbb), target1);
%     [~, idx_gt] = sort(iou_gt, 'descend');
%     gtbox_single =  gtbb(idx_gt(1),:);
    imdb.bboxB.target_gt{i} = gtbox_single;
%     figure; imshow(uint8(imread(imdb.imagesB.name{i})));
%     for j=1:size(gtbox_single,1)
%     hold on;
%     rectangle('Position',[gtbox_single(j,1), gtbox_single(j,2),...
%         gtbox_single(j,3)- gtbox_single(j,1),...
%         gtbox_single(j,4)- gtbox_single(j,2)],...
%         'EdgeColor','b','LineWidth',3 )
%     end
%     for j=1:size(target1,1)
%     
%     hold on;
%     rectangle('Position',[target1(j,1), target1(j,2),...
%         target1(j,3)- target1(j,1), target1(j,4)- target1(j,2)],...
%         'EdgeColor','g','LineWidth',3 )
%     end
%      hold on;
%     rectangle('Position',[target2(j,1), target2(j,2),...
%         target2(j,3)- target2(j,1), target2(j,4)- target2(j,2)],...
%         'EdgeColor','r','LineWidth',3 )
   %  end
    clear pbox iou target gtbb;
end
%% add regression proposal
imdb.bboxB.ptarget = cell(numel(imdb.imagesB.name),1);
for i=1:numel(imdb.imagesB.name)    
  ex_rois = imdb.bboxB.target{i};
  gt_rois = imdb.bboxB.target_gt{i};
  ptargets = bbox_transform(ex_rois, gt_rois);
  imdb.bboxB.ptarget{i} = ptargets;
  clear ex_rois gt_rois ptarget;
end
end