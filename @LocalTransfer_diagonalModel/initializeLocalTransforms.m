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

% Estimate local diagonal transforms Ak_33 that best match the
% match and target images, and global transform.
function Ak_perPatch_33P = initializeLocalTransforms(obj, ...
  G_33, epsilon, gamma)

  P = size(obj.linearIndicesInWindow_NP, 2);

  % Gather matrices vk(M), vk(T), for each patch
  M_3NP = reshape( obj.imgMatch_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  T_3NP = reshape( obj.imgTarget_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );

  % We obtain Ak at each patch by vectorizing:
  % Ak_33 = diag(epsilon * (T*M') + gamma*G) * ...
  %   inv(diag(epsilon * (M*M') + gamma*eye(3)));
  M_M_t_33P = mtimesx(M_3NP,M_3NP,'T');
  T_M_t_33P = mtimesx(T_3NP,M_3NP,'T');
  leftSide_33P = bsxfun(@plus, epsilon * T_M_t_33P, gamma*G_33);
  rightSide_33P = bsxfun(@plus, epsilon * M_M_t_33P, gamma*eye(3));
  
  
  Ak_perPatch_33P = leftSide_33P ./ rightSide_33P;
  
  % Only keep diagonal values
  for i=1:3
    for j=1:3
      if (i ~= j)
        Ak_perPatch_33P(i,j,:) = 0;
      end
    end
  end  
  
  
end