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
 
  N = size(obj.linearIndicesInWindow_NP,1);  % number of pixels per patch
  P = size(obj.linearIndicesInWindow_NP,2);  % number of patches
  R = size(obj.imgInput_3R,2);  % total number of pixels
  
  % Gather matrices vk(I), vk(M), vk(T), for each patch
  I_3NP = reshape( obj.imgInput_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  M_3NP = reshape( obj.imgMatch_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  T_3NP = reshape( obj.imgTarget_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  
  % Compute inverse matrix Bk at each patch
  invBk_perPatch_33P = obj.estimateInvBk_perPatch( epsilon, gamma );
  Bk_33P = NaN(size(invBk_perPatch_33P));
  for k=1:P
    Bk_33P(:,:,k) = inv(invBk_perPatch_33P(:,:,k));
  end
  
  % We obtain the matrix values for each patch by:
  % sparseMatrix_vals_NN = eye(N) - I' * Bk * I;
  Bk_I_3NP = mtimesx(Bk_33P,I_3NP);
  I_t_Bk_I_NNP = mtimesx(I_3NP,'T',Bk_I_3NP);
  sparseMatrix_vals_NNP = bsxfun(@minus, eye(N), I_t_Bk_I_NNP);
  
  % We obtain the right-side vector elements for each patch by:
  % rightSide_vals_3N = (epsilon * T*M' + gamma*G) * Bk * I;
  T_M_t_33P = mtimesx(T_3NP,M_3NP,'T');
  rightSide_vals_3NP = mtimesx( ...
    bsxfun(@plus, epsilon * T_M_t_33P, gamma*G_33), ...
    Bk_I_3NP);
  
  % Store the sparse matrix triplets
  sparseMatrix_rows_NNP = reshape( ...
    obj.linearIndicesInWindow_NP(obj.sparseLinearIndices_pattern_row,:), ...
    [N N P]);
  sparseMatrix_cols_NNP = reshape( ...
    obj.linearIndicesInWindow_NP(obj.sparseLinearIndices_pattern_row',:), ...
    [N N P]);

  % Assemble the final sparse matrix; can use 
  % either sparse() or sparse2() which is slightly faster (from SuiteSparse)
  M_sparseRR = sparse(sparseMatrix_rows_NNP(:), ...
    sparseMatrix_cols_NNP(:), sparseMatrix_vals_NNP(:), R, R);  
  
  % Assemble the right side
  % TODO: replace this with an accumarray
  u_3R = zeros(3, R);
  for k=1:P
    u_3R(:,obj.linearIndicesInWindow_NP(:,k)) ...
      = u_3R(:,obj.linearIndicesInWindow_NP(:,k)) ...
      + rightSide_vals_3NP(:,:,k);
  end  
  
end