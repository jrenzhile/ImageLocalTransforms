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

function invBk_perPatch_33P = estimateInvBk_perPatch( obj, epsilon, gamma )

  % Gather matrices vk(I), vk(M), vk(T), for each patch
  I_3NP = reshape( obj.imgInput_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  M_3NP = reshape( obj.imgMatch_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  
  % We obtain (Bk)^-1 at each patch by vectorizing:
  % invBk_33 = diag(dot(I,I,2) + epsilon*dot(M,M,2)) + gamma*eye(3); 
  I_I_t_33P = mtimesx(I_3NP,I_3NP,'T');
  M_M_t_33P = mtimesx(M_3NP,M_3NP,'T');  
  leftSide_33P = I_I_t_33P + epsilon*M_M_t_33P;
  
  % Ignore non-diag values of the left side matrix
  for i=1:3
    for j=1:3
      if (i ~= j)
        leftSide_33P(i,j,:) = 0;
      end
    end
  end
  
  invBk_perPatch_33P = bsxfun(@plus, gamma*eye(3), leftSide_33P );
  
end

