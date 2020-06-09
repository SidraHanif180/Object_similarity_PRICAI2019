function imdb = combine_2007_2012(imdb, imdbt, imdb2, imdb2t)
imdb.imagesA.name = [imdb.imagesA.name; imdbt.imagesA.name];
imdb.imagesA.set = [imdb.imagesA.set ; imdbt.imagesA.set ];
imdb.bboxA.gtbox = [imdb.bboxA.gtbox ; imdbt.bboxA.gtbox ];
imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize ; imdbt.bboxA.Imagesize ];
imdb.bboxA.label = [imdb.bboxA.label ; imdbt.bboxA.label ];
imdb.bboxA.objlist = [imdb.bboxA.objlist; imdbt.bboxA.objlist];
imdb.bboxA.gt_single = [imdb.bboxA.gt_single; imdbt.bboxA.gt_single];
% imdb.bboxA.proposal = [imdb.bboxA.proposal; imdbt.bboxA.proposal];

imdb.imagesB.name = [imdb.imagesB.name; imdbt.imagesB.name];
imdb.imagesB.set = [imdb.imagesB.set ; imdbt.imagesB.set ];
imdb.bboxB.gtbox = [imdb.bboxB.gtbox ; imdbt.bboxB.gtbox ];
imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize ; imdbt.bboxB.Imagesize ];
imdb.bboxB.label = [imdb.bboxB.label ; imdbt.bboxB.label ];
imdb.bboxB.objlist = [imdb.bboxB.objlist; imdbt.bboxB.objlist];

imdb.bboxB.ptarget = [imdb.bboxB.ptarget; imdbt.bboxB.ptarget];
imdb.bboxB.targetpos = [imdb.bboxB.targetpos; imdbt.bboxB.targetpos];
imdb.bboxB.target_gt = [imdb.bboxB.target_gt; imdbt.bboxB.target_gt];
% imdb.bboxB.proposal = [imdb.bboxB.proposal; imdbt.bboxB.proposal];
%%
imdb.imagesA.name = [imdb.imagesA.name;imdb2.imagesA.name; imdb2t.imagesA.name];
imdb.imagesA.set = [imdb.imagesA.set ;imdb2.imagesA.set ; imdb2t.imagesA.set ];
imdb.bboxA.gtbox = [imdb.bboxA.gtbox ;imdb2.bboxA.gtbox ; imdb2t.bboxA.gtbox ];
imdb.bboxA.Imagesize = [imdb.bboxA.Imagesize ;imdb2.bboxA.Imagesize ; imdb2t.bboxA.Imagesize ];
imdb.bboxA.label = [imdb.bboxA.label ; imdb2.bboxA.label ;imdb2t.bboxA.label ];
imdb.bboxA.objlist = [imdb.bboxA.objlist;imdb2.bboxA.objlist; imdb2t.bboxA.objlist];
% imdb.bboxA.proposal = [imdb.bboxA.proposal; imdbt.bboxA.proposal];


imdb.imagesB.name = [imdb.imagesB.name;imdb2.imagesB.name; imdb2t.imagesB.name];
imdb.imagesB.set = [imdb.imagesB.set ;imdb2.imagesB.set ; imdb2t.imagesB.set ];
imdb.bboxB.gtbox = [imdb.bboxB.gtbox ;imdb2.bboxB.gtbox ; imdb2t.bboxB.gtbox ];
imdb.bboxB.Imagesize = [imdb.bboxB.Imagesize ;imdb2.bboxB.Imagesize ; imdb2t.bboxB.Imagesize ];
imdb.bboxB.label = [imdb.bboxB.label ;imdb2.bboxB.label ; imdb2t.bboxB.label ];
imdb.bboxB.objlist = [imdb.bboxB.objlist;imdb2.bboxB.objlist; imdb2t.bboxB.objlist];
%%
imdb.bboxB.ptarget = [imdb.bboxB.ptarget; imdb2.bboxB.ptarget; imdb2t.bboxB.ptarget];
imdb.bboxB.targetpos = [imdb.bboxB.targetpos; imdb2.bboxB.targetpos;imdb2t.bboxB.targetpos];
imdb.bboxB.target_gt = [imdb.bboxB.target_gt; imdb2.bboxB.target_gt; imdb2t.bboxB.target_gt];
imdb.bboxA.gt_single = [imdb.bboxA.gt_single; imdb2.bboxA.gt_single; imdb2t.bboxA.gt_single];