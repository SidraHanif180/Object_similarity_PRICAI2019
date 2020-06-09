function imdb = attach_proposals_2012(imdb)
imdb.bboxB.target = cell(numel(imdb.imagesB.name),1);
imdb.bboxB.target_gt = cell(numel(imdb.imagesB.name),1);
imdb.bboxA.gt_single = cell(numel(imdb.imagesA.name),1);
%%
for i= 1: numel(imdb.imagesA.name)
    gtbbA = imdb.bboxA.gtbox{i}';
    rdA = randperm(size(gtbbA,1),1); 
    imdb.bboxA.gt_single{i} =  gtbbA(rdA,:);
end
%%
for i= 1: numel(imdb.imagesB.name)
    %pbox_all = imdb.bboxB.proposal{i};
    gtbb_all = imdb.bboxB.gtbox{i}';
    gt_ind = randperm(size(gtbb_all,1),1);
    gtbb_allsin = gtbb_all(gt_ind,:);
    gtbox_single = gtbb_allsin;
%     for m=1: size(gtbb_allsin,1)
%     ind(m) = min_box(single(pbox_all),single(gtbb_allsin(m,:)));
%     end
%      
%     if isempty(intersect(imdb.bboxA.objlist{i},imdb.bboxB.objlist{i})),
%         ind(m)=randperm(6,1);
%     end
    targetpos = imdb.bboxB.Imagesize{i}; 
%     reserve_ind = ind;
%     %[~, idx] = max(iou);    
%     %[~, idx] = sort(iou, 'descend');
%     for n = 1: length(unique(ind))
%         ind_hand = reserve_ind(1);
%         ind2 = find(ind==ind_hand);
%         ind3 = randperm(length(ind2),1); 
%         targetpos(n,:) = pbox_all(ind(ind2(ind3)),:);
%         %gtbox_single (n,:)= gtbb_all(ind2(ind3),:);
%         gtbox_single (n,:) = gtbb_allsin;
%         delete_ind = find(reserve_ind == ind(ind2(ind3)));
%         reserve_ind(delete_ind)=[];
%         clear ind2 ind3 index_all delete_ind;
%     end
%     % negative proposals (find proposals which has no GT)
%     noGT = noGT_proposal(single(gtbb_all), single(pbox_all));
%     noGT(noGT <=.1) = 0;
%     d=1;targetneg=[];
%     if any(noGT ==0)
% %     for m=1: size(pbox_all,1)
%     noGT_ind = find(noGT==0);
%     m= randperm(length(noGT_ind),1);
%         %if all(noGT(:,m) ==0), 
%     targetneg(d,:) = pbox_all(noGT_ind(m),:);% d=d+1; end 
%     end    
    %if 
    imdb.bboxB.targetpos{i,1} = targetpos;
    %imdb.bboxB.targetneg{i,1} = targetneg;
    imdb.bboxB.target_gt{i,1} = gtbox_single;
    %%
%     figure; imshow(uint8(imread(imdb.imagesB.name{i})));
%     for l=1:size(targetpos,1)
%         hold on
%     gtbb = targetpos(l,:); rectangle('Position',[gtbb(1), gtbb(2),...
% gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
% 'EdgeColor','g','LineWidth',3 );
%     end
%     for l=1:size(targetneg,1)
%         hold on
%     gtbb = targetneg(l,:); rectangle('Position',[gtbb(1), gtbb(2),...
% gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
% 'EdgeColor','r','LineWidth',3 );
%     end
%     for l=1:size(gtbb_all,1)
%         hold on
%     gtbb = gtbb_all(l,:); rectangle('Position',[gtbb(1), gtbb(2),...
% gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
% 'EdgeColor','b','LineWidth',3 );
%     end
%
     clear targetpos gtbb_all;
     clear gtbox_single gtbb_allsin;
end
%% add regression proposal
imdb.bboxB.ptarget = cell(numel(imdb.imagesB.name),1);
for i= 1: numel(imdb.imagesB.name)    
  ex_rois = imdb.bboxB.targetpos{i};
  gt_rois = imdb.bboxB.target_gt{i};
  if isempty(intersect(imdb.bboxA.objlist{i},imdb.bboxB.objlist{i})),
        gt_rois = ex_rois;% ind(m)=randperm(6,1);
  end
  ptargets = bbox_transform(single(ex_rois), single(gt_rois));
  imdb.bboxB.ptarget{i} = ptargets;
  clear ex_rois gt_rois ptarget;
end
end