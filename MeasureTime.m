clear;
size0=1;
time = zeros(1,100);
length = zeros(1,100);
sizes = zeros(1,100);
for i=1:100
    sizes(i)=size0-(i-1)*0.01;
end
for n=1:100
    image1 = imread("F:\Final year project\Test images\PreFACE raw data stacks\episcopic_20x_RFtarget\_AfBmpA_42_-16um.png");
    image2 = imread("F:\Final year project\Test images\PreFACE raw data stacks\episcopic_20x_RFtarget\_AfBmpB_42_-16um.png");
    tic;
    [r1,image1,b1] = imsplit(image1);
    [r2,image2,b2] = imsplit(image2);
    %image enhancement
    image1 = imresize(image1,size0, 'nearest');
    image2 = imresize(image2,size0, 'nearest');
    %Adding white noise, prewhitening
    image1 = imnoise(image1,'gaussian',0,0.01) ;
    image2 = imnoise(image2,'gaussian',0,0.01) ;%subplot(1,2,1);imshow(image1);subplot(1,2,2);imshow(image2);
    %Phase correlation filter
    filter1=hamming(size(image1,1),'symmetric'); % setup window in one direction 
    filter2=hamming(size(image1,2),'symmetric'); % setup window in second direction
    filtimg1=(filter1*filter2'); % make 2D windowing function that is sized to match image
    %figure, surf(filtimg1), shading flat;
    image1=double(image1).*filtimg1; % apply windowing function to image
    image2=double(image2).*filtimg1;
    %draw the FFT result
    FFT1 = fft2(image1); % 2d FFT
    FFT2 = conj(fft2(image2)); 
    FFTR = FFT1.*FFT2; 
    magFFTR = abs(FFTR); 
    FFTRN = (FFTR./magFFTR);
    result = ifft2(double(FFTRN))*100;
    result = medfilt2(result, [3,3]);
    [y x]=find(result==max(max(result)));
    x=x(1,1); y=y(1,1);
    % offset
   if x>640*size0
        x=(1280*size0)-x;
    end
    if y>512*size0
        y=(1024*size0)-y;
    end
    length(n) =sqrt(x*x+y*y)*(1/size0);
    time(n)= toc;
    size0=size0-0.01;
end
subplot(1,2,1);plot(sizes, time);subplot(1,2,2);plot(sizes, length);
