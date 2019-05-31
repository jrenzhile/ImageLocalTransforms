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
function [M_sparseRR, u_3R, invBk_perPatch_44P] ...
    = buildClosedFormMatrices(obj, G_34, epsilon, gamma)
 
  N = size(obj.linearIndicesInWindow_NP,1);  % number of pixels per patch
  P = size(obj.linearIndicesInWindow_NP,2);  % number of patches
  R = size(obj.imgInput_3R,2);  % total number of pixels
  
  % Gather matrices vk_bar(I), vk_bar(M), vk(T), for each patch
  Ibar_4NP = reshape( obj.imgInput_4R(:,obj.linearIndicesInWindow_NP(:)), ...
    [4, size(obj.linearIndicesInWindow_NP)] );
  Mbar_4NP = reshape( obj.imgMatch_4R(:,obj.linearIndicesInWindow_NP(:)), ...
    [4, size(obj.linearIndicesInWindow_NP)] );
  T_3NP = reshape( obj.imgTarget_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  
  % Compute inverse matrix Bk at each patch
  invBk_perPatch_44P = obj.estimateInvBk_perPatch( epsilon, gamma );
  Bk_44P = NaN(size(invBk_perPatch_44P));
  for k=1:P
    Bk_44P(:,:,k) = inv(invBk_perPatch_44P(:,:,k));
  end
  
  % We obtain the matrix values for each patch by:
  % sparseMatrix_vals_NN = eye(N) - Ibar' * Bk * Ibar;
  Bk_Ibar_4NP = mtimesx(Bk_44P,Ibar_4NP);
  Ibar_t_Bk_Ibar_NNP = mtimesx(Ibar_4NP,'T',Bk_Ibar_4NP);
  sparseMatrix_vals_NNP = bsxfun(@minus, eye(N), Ibar_t_Bk_Ibar_NNP);
  
  % We obtain the right-side vector elements for each patch by:
  % rightSide_vals_3N = (epsilon * T*Mbar' + gamma*G) * Bk * Ibar; 
  T_Mbar_t_34P = mtimesx(T_3NP,Mbar_4NP,'T');
  rightSide_vals_3NP = mtimesx( ...
    bsxfun(@plus, epsilon * T_Mbar_t_34P, gamma*G_34), ...
    Bk_Ibar_4NP);
  
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