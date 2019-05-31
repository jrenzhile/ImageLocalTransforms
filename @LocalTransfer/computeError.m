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

function [perPixelError_1R, perPatchError_1R] = computeError(obj)

  % IMPORTANT: This method assumes that the input and match images
  % are identical. It computes the error between the transformed input
  % (or transformed match) and the target image.
  
  % Compute the per-pixel squared error
  perPixelError_1R = sum( (obj.imgTarget_3R - obj.imgOutput_3R).^2, 1);
  
  perPixelError_1R = sqrt(perPixelError_1R);
  
  % Sum the error over all pixels of every patch; store the error at the
  % center pixel.
  N = size(obj.linearIndicesInWindow_NP,1);
  P = size(obj.linearIndicesInWindow_NP,2);
  centerPixel_linearIndex_1P = obj.linearIndicesInWindow_NP(ceil(N/2),:);
  perPixelError_NP = reshape(perPixelError_1R(obj.linearIndicesInWindow_NP), [N P]);
  perPatchError_1R = NaN(size(perPixelError_1R));
  perPatchError_1R(centerPixel_linearIndex_1P) = sum(perPixelError_NP, 1);

end

