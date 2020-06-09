function Y = vl_nnsoftmaxcustom(X,dzdY)

Y = bsxfun(@rdivide, X, sqrt(X.*X')) ;

if nargin <= 1, return ; end

% backward
Y = Y .* bsxfun(@minus, dzdY, sum(dzdY .* Y, 3)) ;
