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

function imgOutput = ApplyPrecomputedTransform(...
  imgInput, localTransform_array3CR, patchWidth)

  if (patchWidth == 1)
    
    imgOutput = fastApplyTransforms(imgInput, localTransform_array3CR);
    
  else
    
    localTransferRec = LocalTransfer_affineModel(imgInput, [], []);
    localTransferRec.gatherSquarePatches(patchWidth);

    % If cached transform is diagonal or linear, extend it to affine
    if (size(localTransform_array3CR,2) < 4)
      localTransform_array3CR(:,4,:) = 0;
    end

    % Get the linear indices of the patch centers
    patchCenters_linearIndex_1P = ...
      localTransferRec.linearIndicesInWindow_NP(ceil((patchWidth^2)/2),:);

    % Find the per-patch transform using the patch centers    
    Ak_perPatch_34P = localTransform_array3CR(:,:,patchCenters_linearIndex_1P);
  %   assert(numel(find(isnan(Ak_perPatch_34P))) == 0);

  %   % Find the per-patch transform using the mask
  %   Ak_perPatch_34P = localTransform_array3CR(:,:,imgMask_HW > 0);

    % Apply the transforms on the input image
    localTransferRec.estimateOutput_givenLocalTransforms(Ak_perPatch_34P);

    imgOutput = reshape(localTransferRec.imgOutput_3R', localTransferRec.imgSize);  

  end

end


function imgOutput = fastApplyTransforms(...
  imgInput, localTransform_array3CR)

  C = size(localTransform_array3CR, 2);
  R = size(localTransform_array3CR, 3);
  assert((size(imgInput,1)*size(imgInput,2)) == R);

  imgInput_31R = reshape(reshape(imgInput, R, 3)', 3, 1, R);
  if (C == 4)
    imgInput_C1R = vertcat(imgInput_31R, ones(1,1,R));
  else
    imgInput_C1R = imgInput_31R;
  end
  clear imgInput_31R;
  
  imgOutput_31R = mtimesx(localTransform_array3CR,imgInput_C1R);
  imgOutput = reshape(reshape(imgOutput_31R, 3, R)', ...
    size(imgInput,1), size(imgInput,2), 3);
  
end


