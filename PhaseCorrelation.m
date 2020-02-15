clear;
t1=clock; 
size0=1;%resize cofficient
image1 = imread("F:\Final year project\Test images\PreFACE raw data stacks\episcopic_20x_RFtarget\_AfBmpA_42_-16um.png");
image2 = imread("F:\Final year project\Test images\PreFACE raw data stacks\episcopic_20x_RFtarget\_AfBmpB_42_-16um.png");
%split channel
[r1,image1,b1] = imsplit(image1);
[r2,image2,b2] = imsplit(image2);
%image resize
image1 = imresize(image1,size0, 'bicubic');
image2 = imresize(image2,size0, 'bicubic');
%Adding white noise, prewhitening
image1 = imnoise(image1,'gaussian',0,0.01) ;
image2 = imnoise(image2,'gaussian',0,0.01) ;subplot(1,2,1);imshow(image1);subplot(1,2,2);imshow(image2);
%Phase correlation filter
filter1=hamming(size(image1,1),'symmetric'); % setup window in one direction 
filter2=hamming(size(image1,2),'symmetric'); % setup window in second direction
filtimg1=(filter1*filter2'); % make 2D windowing function that is sized to match image
%figure, surf(filtimg1), shading flat;
image1=double(image1).*filtimg1; % apply windowing function to image
image2=double(image2).*filtimg1;

%draw the FFT result
FFT1 = fft2(image1); % 2d FFT
F1 = fftshift(FFT1); % Center FFT
F1 = abs(F1); % Get the magnitude
F1 = log(F1+1); % Use log, for perceptual scaling, and +1 since log(0) is undefined
F1 = mat2gray(F1); % Use mat2gray to scale the image between 0 and 1
subplot(1,4,3);imshow(F1); % Display the result
%draw the FFT result for image2
F2 = fftshift(fft2(image2)); % Center FFT
F2 = abs(F2); % Get the magnitude
F2 = log(F2+1); % Use log, for perceptual scaling, and +1 since log(0) is undefined
F2 = mat2gray(F2); % Use mat2gray to scale the image between 0 and 1
subplot(1,4,4);imshow(F2); % Display the result

%phase correlation main calculation
FFT2 = conj(fft2(image2));  
FFTR = FFT1.*FFT2; 
magFFTR = abs(FFTR); 
FFTRN = (FFTR./magFFTR);
result = ifft2(double(FFTRN))*150;
%%median filter
result = medfilt2(result, [3,3]);
%result = ordfilt2(result,1,ones(5,5));
%%mean filter
figure, imshow(result);
figure, surf(result) ,shading interp;
caxis([0 0.005])
colorbar;
[y x]=find(result==max(max(result)));
x=x(1,1); y=y(1,1);
% if x-25<=0
%     x1=1;
% elseif x+25>640
%     x1=640-50    
% else
%     x1=x-25;
% end
% if y-25<=0
%     y1=1;
% elseif y+25>512
%     y1=512-50;    
% else
%     y1=y-25;
% end
% figure, surf(result(y1:y1+50, x1:x1+50)) ,shading interp;
% p=result(y1:y1+50, x1:x1+50);
% save('peak.mat', 'p');
%offset
if x>640*size0
        x=(1280*size0)-x;
end
if y>512*size0
    y=(1024*size0)-y;
end
t2 = clock;
time = etime(t2,t1);
