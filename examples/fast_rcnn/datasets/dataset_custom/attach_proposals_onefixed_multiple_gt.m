function imdb = attach_proposals_onefixed_multiple_gt(imdb)
imdb.bboxB.target = cell(numel(imdb.imagesB.name),1);
imdb.bboxB.gt_multiple = cell(numel(imdb.imagesB.name),1);
for i=1:numel(imdb.imagesB.name)
    gtbb_allA = imdb.bboxA.gtbox{i};
    rd = randperm(size(gtbb_allA,1),1);
    gtbbA = gtbb_allA(rd,:);
    imdb.bboxA.gt_single{i} = gtbbA;
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pbox = imdb.bboxB.proposal{i};
    gtbb_allB = imdb.bboxB.gtbox{i};
    rd = randperm(size(gtbb_allB,1),1);
    gtbbB = gtbb_allB(rd,:);
    iou = bbox_overlap_proposal(single(pbox),single(gtbbB));
    %[~, idx] = max(iou);
    [~, idx] = sort(iou, 'descend');
    target1 = pbox(idx(1),:);
    imdb.bboxB.target{i,1} = target1;
    %target2 = pbox(idx(2),:);
    iou_gt = bbox_overlap_gt(single(gtbb_allB),single(target1));
    
%     figure; imshow(uint8(imread(imdb.imagesB.name{i})));
% %     for j=1:size(pbox,1)
%      j=1;
%     hold on;
%     rectangle('Position',[target1(j,1), target1(j,2),...
%         target1(j,3)- target1(j,1), target1(j,4)- target1(j,2)],...
%         'EdgeColor','g','LineWidth',3 )
% %              hold on;
% %             rectangle('Position',[target2(j,1), target2(j,2),...
% %                 target2(j,3)- target2(j,1), target2(j,4)- target2(j,2)],...
% %                 'EdgeColor','r','LineWidth',3 )
% %     end
%     for p=1:size(gtbb_allB,1)
%         if iou_gt(p)> 0.8
%             hold on;
%             rectangle('Position',[gtbb_allB(p,1), gtbb_allB(p,2),...
%                 gtbb_allB(p,3)- gtbb_allB(p,1),...
%                 gtbb_allB(p,4)- gtbb_allB(p,2)],...
%                 'EdgeColor','b','LineWidth',3 )
%         end
%     end
    %%
    a=1;
    for p=1:size(gtbb_allB,1)
        
        if iou_gt(p)> 0.8
            imdb.bboxB.gt_multiple{i}{a}=  gtbb_allB(p,:);
            a=a+1;
        end
    end
    clear pbox iou target gtbb iou_gt;
end
%% add regression proposal
imdb.bboxB.ptarget = cell(numel(imdb.imagesB.name),1);
for i=1:numel(imdb.imagesB.name)
     ex_rois = imdb.bboxB.target{i};
    for sub_i =1: numel(imdb.bboxB.gt_multiple{i})       
        gt_rois = imdb.bboxB.gt_multiple{i,1}{sub_i}; 
        ptargets = bbox_transform(ex_rois, gt_rois);
        imdb.bboxB.ptarget{i}{sub_i} = ptargets;
        clear gt_rois ptarget;
    end
    clear ex_rois;
end
end