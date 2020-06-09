i=1;
pbox = imdb.bboxA.proposal{i};
gtbb = imdb.bboxA.gtbox{i};
imshow(uint8(imread(imdb.imagesA.name{i})));
hold on;
rectangle('Position',[gtbb(1), gtbb(2),...
gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
'EdgeColor','b','LineWidth',3 )
%%
  figure; imshow(uint8(imread(imdb.imagesB.name{i})));
    for l=1:size(targetpos,1)
        hold on
    gtbb = targetpos(l,:); rectangle('Position',[gtbb(1), gtbb(2),...
gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
'EdgeColor','g','LineWidth',3 );
    end
    for l=1:size(targetneg,1)
        hold on
    gtbb = targetneg(l,:); rectangle('Position',[gtbb(1), gtbb(2),...
gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
'EdgeColor','r','LineWidth',3 );
    end
    for l=1:size(gtbb_all,1)
        hold on
    gtbb = gtbb_all(l,:); rectangle('Position',[gtbb(1), gtbb(2),...
gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
'EdgeColor','b','LineWidth',3 );
    end