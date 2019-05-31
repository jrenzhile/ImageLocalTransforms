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

classdef LocalTransfer_diagonalModel < LocalTransfer
  
  properties
    
    
  end
  
  methods
    
    function obj=LocalTransfer_diagonalModel(imgInput, imgMatch, imgTarget)
      
      obj = obj@LocalTransfer(imgInput, imgMatch, imgTarget);
      
    end


    
    
    
  end

  
end

