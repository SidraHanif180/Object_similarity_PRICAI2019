classdef InputConcat < dagnn.ElementWise
  properties
    dim = 3
  end

  properties (Transient)
    inputSizes = {}
  end

  methods
    function outputs = forward(obj, inputs, params)
    roi_output = inputs{1,1};
    neg_proposals = inputs{1,2}(1,:);
    for i=1:size(inputs{1,1},4)/5
    neg_index = find(neg_proposals==i);
    outputs(:,:,:,i) = roi_output(:,:,:,neg_index);
    end
    end
    function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
%       derInputs = vl_nnconcat(inputs, obj.dim, derOutputs{1}, 'inputSizes', obj.inputSizes) ;
%       derParams = {} ;
    end

  end    
end
