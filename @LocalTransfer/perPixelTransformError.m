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

function perTransformError_1R = perPixelTransformError( obj, localTransform_array3CR )

  N = size(obj.linearIndicesInWindow_NP,1); % number of pixels per patch
  P = size(obj.linearIndicesInWindow_NP,2);  % number of patches
  R = size(obj.imgInput_3R,2);  % total number of pixels
  C = size(localTransform_array3CR, 2);
  
  % Gather matrix vk(M) and vk(T) for each patch
  if (C == 3)
    M_CNP = reshape( obj.imgMatch_3R(:,obj.linearIndicesInWindow_NP(:)), ...
      [3, size(obj.linearIndicesInWindow_NP)] );
  elseif (C == 4)
    M_CNP = reshape( obj.imgMatch_4R(:,obj.linearIndicesInWindow_NP(:)), ...
      [4, size(obj.linearIndicesInWindow_NP)] );
  end
  T_3NP = reshape( obj.imgTarget_3R(:,obj.linearIndicesInWindow_NP(:)), ...
    [3, size(obj.linearIndicesInWindow_NP)] );
    
  % Get linear index of the center of each pixel
  centerPixel_linearIndex_1P = obj.linearIndicesInWindow_NP(ceil(N/2),:);
  Ak_perPatch_3CP = localTransform_array3CR(:,:,centerPixel_linearIndex_1P);
  
  % Apply the local transforms on each neighborhood
  transformedM_3NP = mtimesx(Ak_perPatch_3CP,M_CNP);
  
  % Sum the error over all pixels of every patch; store the error at the
  % center pixel.
  perTransformError_1P = sum(reshape((T_3NP - transformedM_3NP).^2, [], P), 1);  
  perTransformError_1R = NaN(1, R);
  perTransformError_1R(centerPixel_linearIndex_1P) = perTransformError_1P;  
  
end

