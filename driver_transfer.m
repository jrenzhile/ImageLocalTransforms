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

%% Set method parameters

% Downsample the image for faster results.
scaleFactor = 0.5;
% scaleFactor = 1;

% Select the transformation model to use.
% The diagonal transforms are not yet implemented in the closed-form solver.
useModel = 'affine';
% useModel = 'linear';
% useModel = 'diagonal';

% Choose whether to use closed-form or iterative solver.
% Note that the closed-form solver can require A LOT of RAM, especially for
% large images (try with a smaller scale factor).
% If useClosedForm=0, the iterative solver will be used
% (and nbIterations needs to be set, default = 3)
useClosedForm = 1;    
nbIterations = 3;                      
                      

%% Load example input data and create synthetic match/target images

imgA = double(imresize(imread('imageA.jpg'),scaleFactor))/255;
imgB = double(imresize(imread('imageB.jpg'),scaleFactor))/255;

imgA = max(0, min(1, imgA));
imgB = max(0, min(1, imgB));

imgInput = imgA;
imgMatch = imgA;

imgTarget = imgB;

% Our target image corresponds to the input, scaled in each color channel,
% with added intensity. We applied an affine transform in the left half,
% and a linear transform in the right half of the image.
imgTarget = bsxfun(@times,imgA,reshape([0.9 0.8 0.7],[1 1 3]));
imgTarget(:,1:size(imgTarget,2)/2,:) = -0.3+bsxfun(@times, ...
  imgTarget(:,1:size(imgTarget,2)/2,:),reshape([1.5 1.3 1],[1 1 3]));




%% Apply the color transfer

tic
switch (useModel)
  case 'affine'
    localTransfer = LocalTransfer_affineModel(imgInput, imgMatch, imgTarget);
  case 'linear'
    localTransfer = LocalTransfer_linearModel(imgInput, imgMatch, imgTarget);
  case 'diagonal'
    localTransfer = LocalTransfer_diagonalModel(imgInput, imgMatch, imgTarget);
end

% Gather patches
patchWidth = 5;   % larger patches require drastically more RAM
localTransfer.gatherSquarePatches(patchWidth);

% Apply transfer
if useClosedForm
  [ imgOutput, localTransform_array3CR, imgMask_HW ] ...
    = localTransfer.transfer_closedForm();
else
  [ imgOutput, localTransform_array3CR, imgMask_HW ] ...
    = localTransfer.transfer_iterative(nbIterations);
end
toc


% Compute scaled error image
imgDiff = 10 * abs(imgTarget - imgOutput);
% figure; imshow(imgOutput);
% figure; imshow(imgDiff);
% figure; imshow(imgMask_HW);

close all;
figure('Name','Input and results');
h = subplot(2,3,1); imshow(imgMatch); title(h, 'Match image');
h = subplot(2,3,4); imshow(imgTarget); title(h, 'Target image');
h = subplot(2,3,2); imshow(imgInput); title(h, 'Input image');
h = subplot(2,3,5); imshow(imgOutput); title(h, 'Output image with local transforms');
h = subplot(2,3,6); imshow(imgDiff); title(h, 'Error');


