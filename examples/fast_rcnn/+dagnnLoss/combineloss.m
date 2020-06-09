classdef combineloss < dagnn.Loss
% combine loss

  methods
    function outputs = forward(obj, inputs, params)
      outputs{1} = (inputs{1}) + (inputs{2});

      % Accumulate loss statistics.
      if obj.ignoreAverage, return; end;
      n = obj.numAveraged ;
      m = n + size(inputs{1},4) + 1e-25 ;
      obj.average = (n * obj.average + gather(outputs{1})) / m ;
%       m = n + gather(sum(inputs{3}(:))) + 1e-9 ;
%       obj.average = (n * obj.average + gather(outputs{1})) / m ;
      obj.numAveraged = m ;
    end
   

    function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
    % Function derivative:
    %
    %          { sigma^2 * x,             if |x| < 1 / sigma^2,
    %  f'(x) = {
    %          { sign(x),                 otherwise.
      derInputs{1} =1;
      derInputs{2} = 1;
      derParams = {} ;
    end

    function obj = LossSmoothL1(varargin)
      obj.load(varargin) ;
      %obj.loss = 'smoothl1';
    end
  end
end
