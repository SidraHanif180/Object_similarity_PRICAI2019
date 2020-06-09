classdef ROIProposal < dagnn.Layer
  
  methods
    function outputs = forward(obj, inputs,params)
        roisB = gather(inputs{2});
        deltas = squeeze(gather(inputs{1}));
        image_index = roisB(1,:);
        roisB = roisB(2:end,:);
        %img_size = inputs{3};
        pred_boxes = round(bbox_transform_inv(roisB', deltas'));
        for b=1:size(pred_boxes,1)
        if pred_boxes(b,1) < 1,  pred_boxes(b,1) = 1; end
        if pred_boxes(b,2) < 1, pred_boxes(b,2) = 1; end
        if pred_boxes(b,3) > roisB(3,b), pred_boxes(b,3) = roisB(3,b); end
        if pred_boxes(b,4) > roisB(4,b), pred_boxes(b,4) = roisB(4,b); end
        %for b=1:size(pred_boxes,1)
            
        end
        pred_boxes1 = [image_index', pred_boxes];
        outputs{1} = gpuArray(pred_boxes1');
    end
   

    function [derInputs, derParams] = backward(obj, inputs,params, derOutputs)
          derInputs = {[], []} ;
          derParams = {};
    end

   
  end
end
