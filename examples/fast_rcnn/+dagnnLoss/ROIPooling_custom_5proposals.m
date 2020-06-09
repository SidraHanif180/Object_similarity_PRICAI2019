classdef ROIPooling_custom_5proposals < dagnn.Layer
  % DAGNN.ROIPOOLING  Region of interest pooling layer

  % Copyright (C) 2016 Hakan Bilen.
  % All rights reserved.
  %
  % This file is part of the VLFeat library and is made available under
  % the terms of the BSD license (see the COPYING file).

  properties
    method = 'max'
    subdivisions = [7 7]
    transform = 1/16
    flatten = false
  end

  methods
    function outputs = forward(obj, inputs, params)
      numImgs = size(inputs{1},4) ;
      if numImgs == 0, 
          outputs{1} =[];
      else
      outputs{1} = vl_nnroipool(...
        inputs{1}, inputs{2}, ...
        'subdivisions', obj.subdivisions, ...
        'transform', obj.transform, ...
        'method', obj.method) ; 
      end
      if obj.flatten
        outputs{1} = reshape(outputs{1},7,7,[],numImgs) ;
      end
    end

    function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
      numFeat = size(inputs{1},3) ;
      numImgs = size(inputs{1},4) ;
      if numImgs  == 0, 
          derInputs{1} =[];
          derInputs{2} = [];
          derParams = {} ;
     % if 1%obj.flatten
        % unflatten
        
      %end
      else 
      derOutputs{1} = reshape(...
          derOutputs{1},obj.subdivisions(1),obj.subdivisions(2),numFeat,[]) ;
      derInputs{1} = vl_nnroipool(...
        inputs{1}, inputs{2}, derOutputs{1}, ...
        'subdivisions', obj.subdivisions, ...
        'transform', obj.transform, ...
        'method', obj.method) ;
      derInputs{2} = [];
      derParams = {} ; end
    end

    function outputSizes = getOutputSizes(obj, inputSizes)
      if isempty(inputSizes{1})
        n = 0 ;
      else
        n = prod(inputSizes{2})/5 ;
      end
      outputSizes{1} = [obj.subdivisions, inputSizes{1}(3), n] ;
    end

    function obj = ROIPooling(varargin)
      obj.load(varargin) ;
    end
  end
end
