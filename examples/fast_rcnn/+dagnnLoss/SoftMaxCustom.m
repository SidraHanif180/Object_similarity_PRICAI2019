classdef SoftMaxCustom < dagnnLoss.ElementWise
  methods
    function outputs = forward(self, inputs, params)
      outputs{1} =  vl_nnnormalizelp(inputs{1}) ;
    end

    function [derInputs, derParams] = backward(self, inputs, params, derOutputs)
      derInputs{1} =  vl_nnnormalizelp(inputs{1}, derOutputs{1}) ;
      derParams = {} ;
    end

    function obj = SoftMaxCustom(varargin)
      obj.load(varargin) ;
    end
  end
end
