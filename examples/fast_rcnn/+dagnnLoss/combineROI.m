classdef combineROI < dagnn.Layer
  
  methods
    function outputs = forward(obj, inputs,params)
        roisB = gather(inputs{2});
        deltas = squeeze(gather(inputs{1}));
        roisB = roisB(2:end);
        %img_size = inputs{3};
        pred_boxes = round(bbox_transform_inv(roisB', deltas'));
        if pred_boxes(1) < 1,  pred_boxes(1) = 1; end
        if pred_boxes(2) < 1, pred_boxes(2) = 1; end
        if pred_boxes(3) > roisB(3), pred_boxes(3) = roisB(3); end
        if pred_boxes(4) > roisB(4), pred_boxes(4) = roisB(4); end
        for b=1:size(pred_boxes,1)
            pred_boxes1(b,:) = [b, pred_boxes(b,:)];
        end
        outputs{1} = gpuArray(pred_boxes1);
    end
   

    function [derInputs, derParams] = backward(obj, inputs,params, derOutputs)
          derInputs = {[], []} ;
          derParams = {};
    end

   
  end
end
