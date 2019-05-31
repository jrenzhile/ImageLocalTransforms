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

function [localTransform_array3CR, imgMask_HW] = ...
  perPixelLocalTransforms( obj, Ak_perPatch_3CP )

  N = size(obj.linearIndicesInWindow_NP,1);  % number of pixels per patch
  R = size(obj.imgInput_3R,2);          % number of pixels in image
  C = size(Ak_perPatch_3CP,2);
  
  % Create C images, where each pixel shows some part of the local
  % transform estimated for the patch centered on this pixel
  localTransform_array3CR = NaN(3,C,R);
  patchCenterLinearIndex_1P = obj.linearIndicesInWindow_NP(ceil(N/2),:);
  localTransform_array3CR(:,:,patchCenterLinearIndex_1P) ...
    = Ak_perPatch_3CP;
  
  if (nargout > 1)
    isTransformNaN_1R = (sum(double(isnan(...
      reshape(localTransform_array3CR,[3*C, R]) )), 1) > 0);
    imgMask_HW = reshape(~isTransformNaN_1R, ...
      [obj.imgSize(1), obj.imgSize(2)] );
  end
  
end

