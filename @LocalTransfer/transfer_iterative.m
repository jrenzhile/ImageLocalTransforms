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

function [ imgOutput, localTransform_array3CR, imgMask_HW, ...
  imgOutput_perIteration, localTransform_array3CR_perIteration ] ...
  = transfer_iterative( obj, nbIterations )

  % Parameters
  epsilon = 1;
  gamma = 0.01;
  
  % Initialize cell arrays that will contain per-iteration results
  savePerIterationResults = (nargout > 3);
  if savePerIterationResults
    imgOutput_perIteration = cell(1,nbIterations);
    localTransform_array3CR_perIteration = cell(1,nbIterations);
  end
  
  % Compute global transform, and globally transformed image
  globalTransform_3C = obj.computeGlobalTransform();
      
  % Precompute Bk^-1 for each patch
  invBk_perPatch_CCP = obj.estimateInvBk_perPatch( epsilon, gamma );
  
  for it=1:nbIterations
    
    if (it == 1)
      % Initialize local transforms
      Ak_perPatch_3CP = obj.initializeLocalTransforms(...
        globalTransform_3C, epsilon, gamma);
    else
      % Re-estimate the local transforms, given the new output
      Ak_perPatch_3CP = obj.estimateLocalTransforms_givenOutput(...
        invBk_perPatch_CCP, globalTransform_3C, epsilon, gamma);
    end
    
    % Apply transform on each patch to estimate the output image
    obj.estimateOutput_givenLocalTransforms(Ak_perPatch_3CP);
    
    if (savePerIterationResults || (it == nbIterations))
    
      % Output transformed image
      imgOutput = reshape(obj.imgOutput_3R', obj.imgSize);

      % Output the per-pixel local transform and corresponding binary mask
      [localTransform_array3CR, imgMask_HW] = ...
        obj.perPixelLocalTransforms( Ak_perPatch_3CP );    

      % Also save the per-iteration results
      if savePerIterationResults
        imgOutput_perIteration{it} = imgOutput;
        localTransform_array3CR_perIteration{it} = localTransform_array3CR;
      end

    end
    
  end

end    

