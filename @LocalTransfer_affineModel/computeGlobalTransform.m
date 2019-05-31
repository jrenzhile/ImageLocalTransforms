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

% Compute affine transform. From equation 8 on the entire image,
% and without first and third terms:
% G = (T M_bar') * inv(M_bar M_bar')
function [G_34, imgTransformed_3R] = computeGlobalTransform(obj)

  R = size(obj.imgMatch_3R,2);

  nonNaNPixels = unique(obj.linearIndicesInWindow_NP(:));
  M_4R = obj.imgMatch_4R(:,nonNaNPixels);
  T_3R = obj.imgTarget_3R(:,nonNaNPixels);
  
  G_34 = (T_3R * M_4R') / (M_4R * M_4R');
  
  if (nargout > 1)
    imgTransformed_3R = G_34 * vertcat(obj.imgInput_3R, ones(1,R));
  end

end