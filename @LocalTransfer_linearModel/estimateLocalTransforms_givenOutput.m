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

% Estimate local linear transforms Ak_33 that best match the
% estimated output image.
function Ak_perPatch_33P = estimateLocalTransforms_givenOutput(obj, ...
  invBk_perPatch_33P, G_33, epsilon, gamma)

  P = size(obj.linearIndicesInWindow_NP, 2);  % number of patches
  
  % Gather matrices vk(I), vk(M), vk(T), vk(O), for each patch
  I_3NP = reshape( obj.imgInput_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  M_3NP = reshape( obj.imgMatch_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  T_3NP = reshape( obj.imgTarget_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  O_3NP = reshape( obj.imgOutput_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  
  % Compute inverse matrix Bk at each patch
  Bk_33P = NaN(size(invBk_perPatch_33P));
  for k=1:P
    Bk_33P(:,:,k) = inv(invBk_perPatch_33P(:,:,k));
  end
  
  % We obtain Ak at each patch by vectorizing:
  % Ak_33 = (O*I' + epsilon*T*M' + gamma*G) * Bk;
  O_I_t_33P = mtimesx(O_3NP,I_3NP,'T');
  T_M_t_33P = mtimesx(T_3NP,M_3NP,'T');
  leftSide_33P = bsxfun(@plus, gamma*G_33, ...
    O_I_t_33P + epsilon*T_M_t_33P );
  Ak_perPatch_33P = mtimesx(leftSide_33P, Bk_33P);

end
