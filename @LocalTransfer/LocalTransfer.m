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

classdef LocalTransfer < handle
  
  properties
    
    imgSize
    
    imgInput_3R
    imgMatch_3R
    imgTarget_3R
    imgOutput_3R
    
    linearIndicesInWindow_NP
    sparseLinearIndices_pattern_row
    
    
  end
  
  methods
    
    function obj=LocalTransfer(imgInput, imgMatch, imgTarget)
      
      assert(~isempty(imgInput));
      obj.imgSize = size(imgInput);
      
      % Vectorize all images
      obj.imgInput_3R = PYToolsSubset.VectorizeMatrix(imgInput)';
      obj.imgMatch_3R = PYToolsSubset.VectorizeMatrix(imgMatch)';
      obj.imgTarget_3R = PYToolsSubset.VectorizeMatrix(imgTarget)';
      
    end
    
  end
  
  methods (Static)
    
    imgOutput = ApplyPrecomputedTransform(imgInput, localTransform_array3CR, patchWidth)
    
  end
  
  
  methods (Abstract)

    computeGlobalTransform(obj)
    initializeLocalTransforms(obj)
    estimateLocalTransforms_givenOutput(obj)
    buildClosedFormMatrices(obj)
    estimateInvBk_perPatch(obj)
    estimateOutput_givenLocalTransforms(obj)
    

  end

  
end

