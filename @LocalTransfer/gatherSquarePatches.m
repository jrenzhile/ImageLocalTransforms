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

% For each square patch of width 2*halfK+1,
% return the linear indices of pixels it contains
function gatherSquarePatches(obj, patchWidth)

  halfK = floor(patchWidth/2);
  imageWidth = obj.imgSize(2);
  imageHeight = obj.imgSize(1);
  
  % Get the coordinate of the center pixel of all patches in the images,
  % except near the borders
  centerPixel_x = repmat([(1+halfK):(imageWidth-halfK)],(imageHeight-2*halfK),1);
  centerPixel_y = repmat([(1+halfK):(imageHeight-halfK)]',1,(imageWidth-2*halfK));
  centerPixel_linearIndices = ...
    PYToolsSubset.Sub2ind_fast2([imageHeight, imageWidth], centerPixel_y, centerPixel_x);
  
  % Get the linear index offsets of all neighbors in a window
  neighbors_offset_col = repmat([-halfK:halfK],[patchWidth 1]);
  neighbors_offset_row = neighbors_offset_col';
  neighbors_offset_linearIndices = neighbors_offset_col * imageHeight + neighbors_offset_row;

  % Get the linear index of each neighbor in each patch
  N = numel(neighbors_offset_linearIndices);
  patchesLinearIndices_NP = bsxfun(@plus, ...
    neighbors_offset_linearIndices(:), centerPixel_linearIndices(:)');

  % Discard patches that contain at least one NaN pixel
  badPatchIndices = findBadPatchIndices(obj.imgInput_3R, patchesLinearIndices_NP);
  if ~isempty(obj.imgMatch_3R)
    badPatchIndices = [ badPatchIndices , ...
      findBadPatchIndices(obj.imgMatch_3R, patchesLinearIndices_NP) ];
  end  
  if ~isempty(obj.imgTarget_3R)
    badPatchIndices = [ badPatchIndices , ...
      findBadPatchIndices(obj.imgTarget_3R, patchesLinearIndices_NP) ];
  end  
  patchesLinearIndices_NP(:,badPatchIndices) = [];
  
  obj.linearIndicesInWindow_NP = patchesLinearIndices_NP;
  obj.sparseLinearIndices_pattern_row = repmat([1:N],[N 1]);  % used for 
               % computing neighborhoods in the adjacency matrices later
end    

function badPatchIndices = findBadPatchIndices(img_3R, patchesLinearIndices_NP)
  
  N = size(patchesLinearIndices_NP,1);
  P = size(patchesLinearIndices_NP,2);

  pixelValues_3NP = reshape( img_3R(:,patchesLinearIndices_NP(:)), [3 N P] );
  
  nbNaNValuesPerPatch_1P = sum(reshape(isnan(pixelValues_3NP), [3*N P]),1);

  badPatchIndices = find(nbNaNValuesPerPatch_1P > 0);
end