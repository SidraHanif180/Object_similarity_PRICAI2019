classdef ContrastiveLoss < dagnn.Loss
  properties
    margin = 1
    allLosses = []
  end
  
  methods
    function outputs = forward(obj, inputs, params)
      switch numel(inputs)
        case 4
          [outputs{1},~, outputs{3}] = vl_nncontrlosssim(inputs{:}, 'margin', obj.margin);
        case 5
          outputs{1} = vl_nncontrlosssim(inputs{1:3}, 'margin', inputs{4});
        otherwise
          error('Invalid number of inputs.');
      end
%      obj.accumulateAverage(inputs, outputs);
    if obj.ignoreAverage, return; end;
      n = obj.numAveraged ;
      m = n + size(inputs{1},4) + 1e-25 ;
      obj.average = (n * obj.average + gather(outputs{1})) / m ;
%       m = n + gather(sum(inputs{3}(:))) + 1e-9 ;
%       obj.average = (n * obj.average + gather(outputs{1})) / m ;
      obj.numAveraged = m ;
       losses = gather(outputs{3});
       obj.allLosses = [obj.allLosses,losses];
    end
    
    function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
      switch numel(inputs)
        case 4
          [dzdx1, dzdx2] = vl_nncontrlosssim(inputs{:}, derOutputs{1}, 'margin', obj.margin);
        case 5
          [dzdx1, dzdx2] = vl_nncontrlosssim(inputs{1:3}, derOutputs{1}, 'margin', inputs{4});
        otherwise
          error('Invalid number of inputs.');
      end
      derInputs = {dzdx1, dzdx2, [],[]};
      derParams = {} ;
    end
    
    function obj = ContrastiveLoss(varargin)
      obj.load(varargin{:}) ;
      obj.loss = 'cont';
    end
  end
end

