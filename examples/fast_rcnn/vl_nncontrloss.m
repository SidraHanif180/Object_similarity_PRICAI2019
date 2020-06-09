function [ y1 ] = vl_nncontrloss( x, c, dzdy, varargin )
%VL_NNCONTRLOSS Compute contrastive loss
%   Y = VL_NNCONTRLOSS(X1, X2, C) computes the contrastive loss incurred by
%   the similar and disimilar pairs in X1 and X2 labelled by C.
%
%   The variables X1 nd X2 are of size H x W x D x N. The distance between
%   two pairs is computed between vectorised chunks of size HWD x N,
%   keeping the spatial and channel arrangement.
%
%   C has dimension 1 x 1 x 1 x N and specifies disimilar pairs when
%   equal 0 and similar pairs otherwise.
%
%   The loss between two vectors XA and XB with L2 distance
%   D = norm(XA - XB) and label L is computed as:
%   L(D, L) = sum(L * D^2 + (1-L) * max(M - D, 0)^2) as defined in [1].
%
%   [DZDX1, DZDX2] = VL_NNCONTRLOSS(X1, X2, C, DZDY) computes the
%   derivative of the block projected onto the output derivative DZDY.
%   DZDX1, DZDX2 and DZDY have the same dimensions as X1, X2 and Y
%   respectively.
%
%   See also: VL_NNLOSS().
%
%   [1] Hadsell, Raia, Sumit Chopra, and Yann LeCun. "Dimensionality
%   reduction by learning an invariant mapping." CVPR 2006

% Copyright (C) 2014-15 Karel Lenc.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

if nargin > 2 && ischar(dzdy), varargin = [dzdy, varargin]; end;
opts.margin = 1;
opts = vl_argparse(opts, varargin);
opts.margin = 1;
sx1 = size(x);
sx2 = size(c);
nel = size(x, 4);
assert(numel(sx1) == numel(sx2), 'Invalid dimensionality');
assert(all(sx1 == sx2), 'Invalid input sizes.');
%assert(numel(c) == nel, 'Invalid number of labels.');

x = reshape(x, [], nel);
% c = reshape(c, [], nel);
if numel(opts.margin) > 1
    assert(numel(opts.margin) == nel, 'Invalid margin.');
    opts.margin = reshape(opts.margin, [], nel);
end
c = reshape(c, [], nel);

for m = 1: numel(x) 
    if numel(x{m,1})~= numel(c(m,1)), 
        label{m,:}= (gather([c(m,1); zeros(numel(x{m,1})-numel(c(m,1)),1)]))'; 
    else
        label{m,:} = (gather(c(m,1)))';
    end
end

 
for m = 1: numel(x)
    diff = (1 - x{m,1})'; %distance
    dist2 = diff.^2;
    dist = sqrt(dist2);
    mdist = opts.margin - dist;
    
    if nargin < 3 || isempty(dzdy) || ischar(dzdy)
        if m==1, y2 = 0; end
        dist2(label{m,1} == 0) = max(mdist(label{m,1} == 0), 0).^2;
        
        y2 = y2 + sum(dist2);
        clear diff dist2 dist mdist;
    else
       
       one = ones(1, 'like', x{m,1});
        mdist = squeeze(mdist);
        y = -diff * (dzdy * 2);
        nf = mdist ./ (dist + 1e-4*one);
        neg_sel = mdist >  0 & label{m,1} == 0;
        y(:, neg_sel) = bsxfun(@times, -y(:, neg_sel), nf(neg_sel));
        y(:, mdist <= 0 & label{m,1} == 0) = 0;
        % ignore select
        ign_sel = label{m,1} == 2;
        y(:, ign_sel) = 0;
        %
        %y2 = -y1;
        y2{m} = y; %reshape(y, sx1);
        %y2 = reshape(y2, sx2);
    end
end
y1 = y2;
end
