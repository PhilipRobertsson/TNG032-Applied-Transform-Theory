load waves.mat;
distance_map = zeros(16:16);

%Create a distance map for a 16 x 16 matrix towards the point (9,9).
for n = 1:16
   for m = 1:16
       distance_map(n,m) = manhat(n,m,9,9);
   end
end

% Draw the matrix as an image.
figure(1);imagesc(distance_map); axis image; colormap gray;
%axis image;
%colormap gray;

% Create a mask where a distance greater or equal to 5 will be set to zero,
% while lower distances will be set to one.
%figure(2);imagesc(mask);
%axis image;
%colormap gray;

% Waves 1.4
ftwaves = fft2(waves);
shifty = fftshift(ftwaves);

shortwaves = waves(1:16:256, 1:16:256);
figure(4); plot(shortwaves(:,:));

ftshortwaves = fft2(shortwaves);
figure(5); plot(abs(ftshortwaves(:,:)));

ftshiftshortwaves = fftshift(ftshortwaves);
figure(6); plot(abs(ftshiftshortwaves(:,:)));

figure(7); plot(ifft2(fftshift(fftshift(fft2(shortwaves(:,:))))));

figure(8); imagesc(shortwaves); axis image; colormap gray;

for k = 0:16
    maskK = (distance_map <= k);
    ftshortwaves0 = ftshiftshortwaves.*maskK;
    rec0 = ifft2(fftshift(ftshortwaves0));
    figure(9);
        subplot(2,2,1); imagesc(shortwaves); axis image; colormap gray;
        subplot(2,2, 2); imagesc(real(rec0)); axis image; colormap gray;
        subplot(2,2,3); imagesc(abs(shortwaves - real(rec0))); axis image; colormap gray;
    pause
end

% 1.5
ORIGIM = imread("cameraman.tif");
ORIGIM = double(ORIGIM);
SFFTIMAGE = complex(zeros(size(ORIGIM)));
mask = (distance_map <= 16);

for k  = 1:16:size(ORIGIM,1)-15
 for m = 1:16:size(ORIGIM,2)-15
  SFFTIMAGE(k:k+15,m:m+15)=fftshift(fft2(ORIGIM(k:k+15,m:m+15)));
 end
end

for mthres = 1:max(mask(:))+1
    for k  = 1:16:size(ORIGIM,1)-15
      for m = 1:16:size(ORIGIM,2)-15
    %   select the correct subimage from SFFTIMAGE
       currentSubImg = SFFTIMAGE(k:k+15,m:m+15);
   %   mask, shift and inverse transform. Store result in  RECIMAGE
       currentSubImg = currentSubImg.*mask;
       RECIM = ifft2(fftshift(currentSubImg));
       RECIMAGE(k:k+15,m:m+15) = abs(RECIM);
      end
    end
    figure(10); imagesc(ORIGIM); axis image; colormap gray;

    figure(11); imagesc(RECIMAGE); axis image; colormap gray;

    drawnow
end