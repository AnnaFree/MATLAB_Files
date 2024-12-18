function midterm(imageFile1, imageFile2, scale, margin)
%local var setup
    backgroundImage = imread(imageFile1);
    foregroundImage = imread(imageFile2);
    scaledImage = imresize(foregroundImage, scale);
    [foregroundHeight, foregroundWidth, ~] = size(scaledImage);
    [backgroundHeight, backgroundWidth, ~] = size(backgroundImage);

  %dimensions
  finalHeight = foregroundHeight + (2 * margin);
  finalWidth = foregroundWidth + (2*margin);

  %new image
  yPlacement = floor((backgroundHeight - finalHeight)/2);
  xPlacement = floor((backgroundWidth - finalWidth)/2);
  %white margin
  backgroundImage(yPlacement:yPlacement + finalHeight -1, xPlacement:xPlacement + finalWidth -1, :) =255;
  backgroundImage(yPlacement:yPlacement - 1, xPlacement:xPlacement + finalWidth - 1, :) = 255;
  backgroundImage(yPlacement + margin:yPlacement + margin + foregroundHeight - 1, xPlacement + margin:xPlacement + margin + foregroundWidth - 1, :) = scaledImage;

  imshow(backgroundImage);
end

