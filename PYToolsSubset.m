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
% from the author
%

classdef PYToolsSubset
    
    properties
    end
    
    methods(Static)
      
        % Reshape H x W x C matrix into HW x C
        function vec = VectorizeMatrix(mat)
           vec = reshape(mat, size(mat,1)*size(mat,2), size(mat,3));
        end
        
        % Reshape HW x C matrix into H x W x C
        function mat = UnvectorizeMatrix(vec, rows, cols)
            mat = reshape(vec, rows, cols, size(vec,2));
        end
        
        % Fast replacement of SUB2IND (Linear index from multiple subscripts)
        % in dimension 2; no check is performed.
        function ind = Sub2ind_fast2(siz, i, j)
            ind = i + (j-1)*siz(1);
        end        
        
        % Fast replacement of SUB2IND (Linear index from multiple subscripts)
        % in dimension 3; no check is performed.
        function ind = Sub2ind_fast3(siz, i, j, k)
            ind = i + (j-1)*siz(1) + (k-1)*siz(1)*siz(2);
        end
        
		
    end
    
end
