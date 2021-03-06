function [ y1, y2 ] = vl_nncontrlosssim( x1, x2, c,l, dzdy, varargin )
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
%%
if nargin > 4 && ischar(dzdy), varargin = [dzdy, varargin]; end;
opts.margin = 3;
opts = vl_argparse(opts, varargin);
opts.margin = 2;
sx1 = size(x1); sx2 = size(x2); nel = size(x1, 4);
assert(numel(sx1) == numel(sx2), 'Invalid dimensionality');
assert(all(sx1 == sx2), 'Invalid input sizes.');
assert(numel(c) == nel, 'Invalid number of labels.');

x1 = reshape(x1, [], nel);
x2 = reshape(x2, [], nel);
if numel(opts.margin) > 1
  assert(numel(opts.margin) == nel, 'Invalid margin.');
  opts.margin = reshape(opts.margin, [], nel);
end
c = reshape(c, [], nel);
l = reshape(l, [], nel);
diff = (x1 - x2);
dist2 = sum(diff.^2, 1);
dist = sqrt(dist2);
mdist = opts.margin - dist;

if nargin < 5 || isempty(dzdy) || ischar(dzdy)
  dist2(l == 0) = max(mdist(l == 0), 0).^2;
  dist2(l==1 & c==2) = 0;% | (l==1 & c == 2))
  y1 = sum(dist2);
  else
   one = ones(1, 'like', x1);
   mdist = squeeze(mdist);
   y1 =  diff * (dzdy*2);
   nf = mdist ./ (dist + 1e-4*one);
   neg_sel = mdist >  0 & l == 0;
   ign_sel = l==1 & c == 2;
%     y1(:, ign_sel) = 0;
% if neg_sel~=0
   y1(:,neg_sel) = bsxfun(@times, -y1(:,neg_sel), nf(neg_sel));
%  end
%  if ign_sel~=0
   y1(:,ign_sel) = 0;
% end
%bsxfun(@times, -y1(:,neg_sel), nf(:,neg_sel));
%   y1(:, mdist <= 0 & c == 0) = 0;
%   y2 = -y1;
  y1(:, mdist <= 0 & l == 0) = 0;
  y2 = -y1;
  y1 = reshape(y1, sx1);
  y2 = reshape(y2, sx2);
end

end