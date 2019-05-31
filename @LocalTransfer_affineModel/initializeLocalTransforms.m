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
% match and target images, and global transform.
function Ak_perPatch_34P = initializeLocalTransforms(obj, ...
  G_34, epsilon, gamma)

  P = size(obj.linearIndicesInWindow_NP, 2);

  % Gather matrices vk_bar(M), vk(T), for each patch
  Mbar_4NP = reshape( obj.imgMatch_4R(:,obj.linearIndicesInWindow_NP(:)), ...
    [4, size(obj.linearIndicesInWindow_NP)] );
  T_3NP = reshape( obj.imgTarget_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );

  % We obtain Ak at each patch by vectorizing:
  % Ak_34 = (epsilon * (T*Mbar') + gamma*G) * ...
  %   inv(epsilon * (Mbar*Mbar') + gamma*eye(4));
  Mbar_Mbar_t_44P = mtimesx(Mbar_4NP,Mbar_4NP,'T');
  T_Mbar_t_34P = mtimesx(T_3NP,Mbar_4NP,'T');
  leftSide_34P = bsxfun(@plus, epsilon * T_Mbar_t_34P, gamma*G_34);
  invRightSide_44P = bsxfun(@plus, epsilon * Mbar_Mbar_t_44P, gamma*eye(4));
  
  % Inverse the right side for each patch
  rightSide_44P = zeros(size(invRightSide_44P));
  for k=1:P
    rightSide_44P(:,:,k) = inv(invRightSide_44P(:,:,k));
  end
  
  Ak_perPatch_34P = mtimesx(leftSide_34P, rightSide_44P);
  
end