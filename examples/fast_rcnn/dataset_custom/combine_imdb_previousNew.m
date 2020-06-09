function imdb = combine_imdb_previousNew(previous_imdb, imdb,...
    batch_all, previouslossBB, previouslosssim)

positive_index = find(cell2mat(previous_imdb.bboxA.label)==...
    cell2mat(previous_imdb.bboxB.label));

positive_lossBB = previouslossBB(positive_index);
norm_positive_lossBB = positive_lossBB/ sum(positive_lossBB);
positive_losssim = previouslosssim(positive_index);
norm_positive_losssim = positive_losssim/ sum(positive_losssim);
positive_batch_index = batch_all(positive_index);

[~, sort_indexBB] = sort(norm_positive_lossBB,2, 'descend');
positive_batchBB = positive_batch_index(sort_indexBB(1: 3665));
[~, sort_indexsim] = sort(norm_positive_losssim,2, 'descend');
positive_batchsim = positive_batch_index(sort_indexsim(1: 3653));
%% positive BB imdb_New
imdb_new.imagesA.name = previous_imdb.imagesA.name(positive_batchBB,1);
imdb_new.bboxA.gtbox =previous_imdb.bboxA.gtbox(positive_batchBB,1);
imdb_new.bboxA.Imagesize =previous_imdb.bboxA.Imagesize(positive_batchBB,1);
imdb_new.bboxA.label =previous_imdb.bboxA.label(positive_batchBB,1);
imdb_new.bboxA.proposal =previous_imdb.bboxA.proposal(positive_batchBB,1);
imdb_new.bboxA.objlist =previous_imdb.bboxA.objlist(positive_batchBB,1);
imdb_new.bboxA.gt_single =previous_imdb.bboxA.gt_single(positive_batchBB,1);

imdb_new.imagesB.name = previous_imdb.imagesB.name(positive_batchBB,1);
imdb_new.bboxB.gtbox =previous_imdb.bboxB.gtbox(positive_batchBB,1);
imdb_new.bboxB.Imagesize =previous_imdb.bboxB.Imagesize(positive_batchBB,1);
imdb_new.bboxB.label =previous_imdb.bboxB.label(positive_batchBB,1);
imdb_new.bboxB.proposal =previous_imdb.bboxB.proposal(positive_batchBB,1);
imdb_new.bboxB.objlist =previous_imdb.bboxB.objlist(positive_batchBB,1);
imdb_new.bboxB.target =previous_imdb.bboxB.target(positive_batchBB,1);
imdb_new.bboxB.target_gt =previous_imdb.bboxB.target_gt(positive_batchBB,1);
imdb_new.bboxB.targetpos =previous_imdb.bboxB.targetpos(positive_batchBB,1);
imdb_new.bboxB.ptarget =previous_imdb.bboxB.ptarget(positive_batchBB,1);
imdb_combine1 = imdb_new;
clear imdb_new positive_batchBB;
positive_batchBB =positive_batchsim;
%% positive sim imdb_New
imdb_new.imagesA.name = previous_imdb.imagesA.name(positive_batchBB,1);
imdb_new.bboxA.gtbox =previous_imdb.bboxA.gtbox(positive_batchBB,1);
imdb_new.bboxA.Imagesize =previous_imdb.bboxA.Imagesize(positive_batchBB,1);
imdb_new.bboxA.label =previous_imdb.bboxA.label(positive_batchBB,1);
imdb_new.bboxA.proposal =previous_imdb.bboxA.proposal(positive_batchBB,1);
imdb_new.bboxA.objlist =previous_imdb.bboxA.objlist(positive_batchBB,1);
imdb_new.bboxA.gt_single =previous_imdb.bboxA.gt_single(positive_batchBB,1);

imdb_new.imagesB.name = previous_imdb.imagesB.name(positive_batchBB,1);
imdb_new.bboxB.gtbox =previous_imdb.bboxB.gtbox(positive_batchBB,1);
imdb_new.bboxB.Imagesize =previous_imdb.bboxB.Imagesize(positive_batchBB,1);
imdb_new.bboxB.label =previous_imdb.bboxB.label(positive_batchBB,1);
imdb_new.bboxB.proposal =previous_imdb.bboxB.proposal(positive_batchBB,1);
imdb_new.bboxB.objlist =previous_imdb.bboxB.objlist(positive_batchBB,1);
imdb_new.bboxB.target =previous_imdb.bboxB.target(positive_batchBB,1);
imdb_new.bboxB.target_gt =previous_imdb.bboxB.target_gt(positive_batchBB,1);
imdb_new.bboxB.targetpos =previous_imdb.bboxB.targetpos(positive_batchBB,1);
imdb_new.bboxB.ptarget =previous_imdb.bboxB.ptarget(positive_batchBB,1);
imdb_combine2= imdb_new;
%% combine all three
imdb.imagesA.name = [imdb.imagesA.name; imdb_combine1.imagesA.name;imdb_combine2.imagesA.name ];
%imdb.imagesA.set = [imdb.imagesA.set ; imdb_combine1.imagesA.set; imdb_combine2.imagesA.set ];
imdb.bboxA.gtbox = [imdb.bboxA.gtbox ; imdb_combine1.bboxA.gtbox;imdb_combine2.bboxA.gtbox ];
imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize ; imdb_combine1.bboxA.Imagesize; imdb_combine2.bboxA.Imagesize ];
imdb.bboxA.label = [imdb.bboxA.label ; imdb_combine1.bboxA.label;imdb_combine2.bboxA.label ];
imdb.bboxA.objlist = [imdb.bboxA.objlist; imdb_combine1.bboxA.objlist; imdb_combine2.bboxA.objlist];
imdb.bboxA.proposal = [imdb.bboxA.proposal; imdb_combine1.bboxA.proposal; imdb_combine2.bboxA.proposal];
imdb.bboxA.gt_single = [imdb.bboxA.gt_single; imdb_combine1.bboxA.gt_single; imdb_combine2.bboxA.gt_single];

imdb.imagesB.name = [imdb.imagesB.name; imdb_combine1.imagesB.name;imdb_combine2.imagesB.name ];
imdb.bboxB.gtbox =[imdb.bboxB.gtbox ; imdb_combine1.bboxB.gtbox;imdb_combine2.bboxB.gtbox ];
imdb.bboxB.Imagesize =[imdb.bboxB.Imagesize ; imdb_combine1.bboxB.Imagesize; imdb_combine2.bboxB.Imagesize ];
imdb.bboxB.label = [imdb.bboxB.label ; imdb_combine1.bboxB.label;imdb_combine2.bboxB.label ];
imdb.bboxB.proposal =[imdb.bboxB.proposal; imdb_combine1.bboxB.proposal; imdb_combine2.bboxB.proposal];
imdb.bboxB.objlist =[imdb.bboxB.objlist; imdb_combine1.bboxB.objlist; imdb_combine2.bboxB.objlist];
imdb.bboxB.target =[imdb.bboxB.target; imdb_combine1.bboxB.target; imdb_combine2.bboxB.target];
imdb.bboxB.target_gt =[imdb.bboxB.target_gt; imdb_combine1.bboxB.target_gt; imdb_combine2.bboxB.target_gt];
imdb.bboxB.targetpos =[imdb.bboxB.targetpos; imdb_combine1.bboxB.targetpos; imdb_combine2.bboxB.targetpos];
imdb.bboxB.ptarget =[imdb.bboxB.ptarget; imdb_combine1.bboxB.ptarget; imdb_combine2.bboxB.ptarget];
%%

end