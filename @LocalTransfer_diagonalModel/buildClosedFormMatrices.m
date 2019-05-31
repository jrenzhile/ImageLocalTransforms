%
% This code is part of the LocalTransforms_vectorized solution
% written by Pierre-Yves LAFFONT (www.py-laffont.info)
% for the paper:
%
%    Transient Attributes for High-Level Understanding 
%             and Editing of Outdoor Scenes
%     P.Y. Laffont, Z. Ren, X. Tao, C. Qian, J. Hays
%      ACM Transactions on Graphics (SIGGRAPH 2014)
%
% This code has been written for research purposes
% and should not be shared without prior authorization
% from the author.
%

% Build matrices following Yichang's paper. All quantities are defined
% after equation 8 in their paper:
%   M_sparseRR is sparse of size RxR, 
%   u_3R is defined below equation 8
%   invBk_perPatch_CCP corresponds to the CxC matrix Bk^(-1) for each patch
%                      (C=3 for the linear model, C=4 for the affine)
function [M_sparseRR, u_3R, invBk_perPatch_33P] ...
    = buildClosedFormMatrices(obj, G_33, epsilon, gamma)
 
  error('Closed-form solution for diagonal transform is not yet implemented. Use iterative version instead.');
  
end