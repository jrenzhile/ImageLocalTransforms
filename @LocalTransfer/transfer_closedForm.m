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

function [ imgOutput, localTransform_array3CR, imgMask_HW ] ...
  = transfer_closedForm( obj )

%   warning('Warning: Closed-form solution hasn''t been properly debugged for handling NaN values');

  % Parameters
  epsilon = 1;
  gamma = 0.01;
  
  % Compute global transform, and globally transformed image
  globalTransform_3C = obj.computeGlobalTransform();
    
  % Construct system matrix and right side
  [M_sparseRR, u_3R, invBk_perPatch_CCP] ...
    = obj.buildClosedFormMatrices(globalTransform_3C, epsilon, gamma);    
  toc
  
  % Make sure matrix M is symmetric 
  % (sometimes there are some inaccuracies, and M-M'=1e-14 in some cells)
  % by replacing the lower triangle by the transpose of the upper triangle
  M_sparseRR = triu(M_sparseRR) ...   % upper triangle + diagonal
    + triu(M_sparseRR,1)';    % upper triangle, transposed to give lower one
  toc  
  
  % Solve linear system
  obj.imgOutput_3R =  u_3R / M_sparseRR;
  toc
  
  % Output transformed image
  imgOutput = reshape(obj.imgOutput_3R', obj.imgSize);
  toc
  
  % Estimate the best-matching local transforms
  Ak_perPatch_3CP = obj.estimateLocalTransforms_givenOutput(...
    invBk_perPatch_CCP, globalTransform_3C, epsilon, gamma);
  
  % Output the per-pixel local transform and corresponding binary mask
  [localTransform_array3CR, imgMask_HW] = ...
    obj.perPixelLocalTransforms( Ak_perPatch_3CP );
    
end    

