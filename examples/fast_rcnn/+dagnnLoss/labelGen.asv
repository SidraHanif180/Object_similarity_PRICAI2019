classdef labelGen  < dagnn.Layer
    
    methods
        function outputs = forward(obj, inputs,params)
            proposal1 = cell2mat(gather(inputs{2}));
            deltas = squeeze(gather(inputs{1}));
            gtAll = inputs{3};
            %         gtAll =  gtAll{1,1};
            %img_size = inputs{3};
            %%
            pred_boxes = round(bbox_transform_inv(proposal1', deltas'));
            for b=1:size(pred_boxes,1)
                if pred_boxes(b,1) < 1,  pred_boxes(b,1) = 1; end
                if pred_boxes(b,2) < 1, pred_boxes(b,2) = 1; end
                if pred_boxes(b,3) > proposal1(3,b), pred_boxes(b,3) = proposal1(3,b); end
                if pred_boxes(b,4) > proposal1(4,b), pred_boxes(b,4) = proposal1(4,b); end
                %for b=1:size(pred_boxes,1)
                
            end
            %         for b=1:size(pred_boxes,1)
            %             pred_boxes1(b,:) = [b, pred_boxes(b,:)];
            %         end
            %%
            for k=1: numel(gtAll)
                gtAll_1  = gtAll{1,k}';
                for k1 = 1: size(gtAll_1,1)                    
                    overlaps(k1) = bbox_overlap_gt_prop(gtAll_1(k1,:),...
                        pred_boxes(k,:));
                end
                if max(overlaps) >= 0.5
                    maxoverlap(k) = 1;
                else
                    maxoverlap(k) = 2;
                end
                clear overlaps;
            end
            outputs{1} = maxoverlap; %gpuArray(
            
        end
        
        
        function [derInputs, derParams] = backward(obj, inputs,params, derOutputs)
            derInputs = {[], [],[]} ;
            derParams = {};
        end
        
        
    end
end
