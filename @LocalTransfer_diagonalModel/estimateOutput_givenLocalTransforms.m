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

function estimateOutput_givenLocalTransforms(obj, Ak_perPatch_33P)

  P = size(obj.linearIndicesInWindow_NP,2);  % number of patches
  R = size(obj.imgInput_3R,2);  % total number of pixels
  
  % Gather matrix vk(I) for each patch
  I_3NP = reshape( obj.imgInput_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
  
  % Each patch results in (soft) constraints on several pixels
  outputConstraints_3NP = mtimesx(Ak_perPatch_33P,I_3NP);
  
  % Initialize arrays that contain the diagonal of the left-side matrix,
  % and the right-side.
  % TODO: turn this into an accumarray
  diagM_R = zeros(1, R);
  u_3R = zeros(3, R);
  % ignore patches where local transform is NaN
  patchesNotNaN = find( sum(isnan( reshape(Ak_perPatch_33P,[],P) ),1) == 0);
  for k=patchesNotNaN
    linearIndicesInWindow = obj.linearIndicesInWindow_NP(:,k);
    diagM_R(linearIndicesInWindow) = diagM_R(linearIndicesInWindow)+1;
    u_3R(:,linearIndicesInWindow) = u_3R(:,linearIndicesInWindow) ...
      + outputConstraints_3NP(:,:,k);
  end
  
  obj.imgOutput_3R = bsxfun(@rdivide, u_3R, diagM_R);

end

