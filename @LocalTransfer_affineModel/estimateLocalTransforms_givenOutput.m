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

% Estimate local affine transforms Ak_34 that best match the
% estimated output image.
function Ak_perPatch_34P = estimateLocalTransforms_givenOutput(obj, ...
  invBk_perPatch_44P, G_34, epsilon, gamma)

  P = size(obj.linearIndicesInWindow_NP, 2);  % number of patches
  
  % Gather matrices vk_bar(I), vk_bar(M), vk(T), vk(O), for each patch
  Ibar_4NP = reshape( obj.imgInput_4R(:,obj.linearIndicesInWindow_NP(:)), ...
    [4, size(obj.linearIndicesInWindow_NP)] );
  Mbar_4NP = reshape( obj.imgMatch_4R(:,obj.linearIndicesInWindow_NP(:)), ...
    [4, size(obj.linearIndicesInWindow_NP)] );
  T_3NP = reshape( obj.imgTarget_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  O_3NP = reshape( obj.imgOutput_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  
  % Compute inverse matrix Bk at each patch
  Bk_44P = NaN(size(invBk_perPatch_44P));
  for k=1:P
    Bk_44P(:,:,k) = inv(invBk_perPatch_44P(:,:,k));
  end
  
  % We obtain Ak at each patch by vectorizing:
  % Ak_34 = (O*Ibar' + epsilon*T*Mbar' + gamma*G) * Bk; 
  O_Ibar_t_34P = mtimesx(O_3NP,Ibar_4NP,'T');
  T_Mbar_t_34P = mtimesx(T_3NP,Mbar_4NP,'T');
  leftSide_34P = bsxfun(@plus, gamma*G_34, ...
    O_Ibar_t_34P + epsilon*T_Mbar_t_34P );
  Ak_perPatch_34P = mtimesx(leftSide_34P, Bk_44P);

end
