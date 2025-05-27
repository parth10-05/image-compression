clc;
clear;
close();

function imCompressed = compress(imFullOneChannel, SingularValuesToKeep)
    [U, Sigma, V] = svd(imFullOneChannel);
    SingularValues = diag(Sigma);
    imCompressed = U(:, 1:SingularValuesToKeep) * diag(SingularValues(1:SingularValuesToKeep)) * V(:, 1:SingularValuesToKeep)';
endfunction

img = imread("PATH TO IMAGE");

if size(img, "c") == 3 then
    img = rgb2gray(img);
end

imFull = double(img);

imCompressed = compress(imFull, 50);
imCompressedFinal = uint8(imCompressed);

figure;
subplot(1,2,1);
imshow(img);
title("Original Image");

subplot(1,2,2);
imshow(imCompressedFinal);
title("Compressed Image");
