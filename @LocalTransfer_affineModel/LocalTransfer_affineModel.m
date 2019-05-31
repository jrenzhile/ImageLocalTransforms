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

classdef LocalTransfer_affineModel < LocalTransfer
  
  properties
    
    imgInput_4R
    imgMatch_4R
    imgTarget_4R
    
  end
  
  methods
    
    function obj=LocalTransfer_affineModel(imgInput, imgMatch, imgTarget)
      
      obj = obj@LocalTransfer(imgInput, imgMatch, imgTarget);
      
      R = obj.imgSize(1)*obj.imgSize(2);
      obj.imgInput_4R = vertcat(obj.imgInput_3R, ones(1,R));
      obj.imgMatch_4R = vertcat(obj.imgMatch_3R, ones(1,R));
      obj.imgTarget_4R = vertcat(obj.imgTarget_3R, ones(1,R));
      
    end
    
    
  end

  
end

