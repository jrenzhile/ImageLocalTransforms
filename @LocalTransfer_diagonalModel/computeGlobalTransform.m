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

% Compute linear transform. From equation 8 on the entire image,
% and without first and third terms:
% G = (T M') * inv(M M')
function [G_33, imgTransformed_3R] = computeGlobalTransform(obj)

  nonNaNPixels = unique(obj.linearIndicesInWindow_NP(:));

  M_3R = obj.imgMatch_3R(:,nonNaNPixels);
  T_3R = obj.imgTarget_3R(:,nonNaNPixels);
  
  % For channel k, the diagonal coefficient c_k is:
  % c_k = (Tk Mk^t) ./ (Mk Mk^t)
  numerator = dot(T_3R,M_3R,2);
  denominator = dot(M_3R,M_3R,2);
  G_33 = diag(numerator ./ denominator);
  
  if (nargout > 1)
    imgTransformed_3R = G_33 * obj.imgInput_3R;
  end
  
end    