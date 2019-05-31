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

function invBk_perPatch_44P = estimateInvBk_perPatch( obj, epsilon, gamma )

  % Gather matrices vk_bar(I), vk_bar(M), vk(T), for each patch
  Ibar_4NP = reshape( obj.imgInput_4R(:,obj.linearIndicesInWindow_NP(:)), ...
    [4, size(obj.linearIndicesInWindow_NP)] );
  Mbar_4NP = reshape( obj.imgMatch_4R(:,obj.linearIndicesInWindow_NP(:)), ...
    [4, size(obj.linearIndicesInWindow_NP)] );
  
  % We obtain (Bk)^-1 at each patch by vectorizing:
  % invBk_44 = Ibar*Ibar' + epsilon*(Mbar*Mbar') + gamma*eye(4);
  Ibar_Ibar_t_44P = mtimesx(Ibar_4NP,Ibar_4NP,'T');
  Mbar_Mbar_t_44P = mtimesx(Mbar_4NP,Mbar_4NP,'T');
  invBk_perPatch_44P = bsxfun(@plus, gamma*eye(4), ...
    Ibar_Ibar_t_44P + epsilon*Mbar_Mbar_t_44P );


end

