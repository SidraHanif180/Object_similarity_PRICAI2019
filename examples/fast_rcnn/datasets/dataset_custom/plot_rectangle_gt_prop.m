i=1;
pbox = imdb.bboxA.proposal{i};
gtbb = imdb.bboxA.gtbox{i};
imshow(uint8(imread(imdb.imagesA.name{i})));
hold on;
rectangle('Position',[gtbb(1), gtbb(2),...
gtbb(3)- gtbb(1), gtbb(4)- gtbb(2)],...
'EdgeColor','b','LineWidth',3 )