clear;
defocus_length=zeros(1,261);
size0=0.1;
for k=1:261
    defocus_length(k)=-1300+10*(k-1);
end
phase_correlation=zeros(1,261);
for i=1:261
    t1=clock;
    s1=sprintf("F:\\Final year project\\Test images\\PreFACE raw data stacks\\Transmitted_4x_BF_RF2\\_AfBmpA_%d_%dum.png",i+149, defocus_length(i));
    s2=sprintf("F:\\Final year project\\Test images\\PreFACE raw data stacks\\Transmitted_4x_BF_RF2\\_AfBmpB_%d_%dum.png",i+149, defocus_length(i));
    image1 = imread(s1);
    image2 = imread(s2);
    [r1,image1,b1] = imsplit(image1);
    [r2,image2,b2] = imsplit(image2);
    %Adding white noise
    image1 = imnoise(image1,'gaussian',0,0.01) ;
    image2 = imnoise(image2,'gaussian',0,0.01) ;
    %bining pixels
    image1 = imresize(image1,size0, 'bicubic');
    image2 = imresize(image2,size0, 'bicubic');
    %Phase correlation filter
    filter1=hamming(size(image1,1),'symmetric'); % setup window in one direction 
    filter2=hamming(size(image1,2),'symmetric'); % setup window in second direction
    filtimg1=(filter1*filter2'); % make 2D windowing function that is sized to match image
    %surf(filtimg1), shading flat;
    image1=double(image1).*filtimg1; % apply windowing function to image
    image2=double(image2).*filtimg1;
    %draw the FFT result
    FFT1 = fft2(image1); % 2d FFT
    F1 = fftshift(FFT1); % Center FFT
    F1 = abs(F1); % Get the magnitude
    F1 = log(F1+1); % Use log, for perceptual scaling, and +1 since log(0) is undefined
    F1 = mat2gray(F1); % Use mat2gray to scale the image between 0 and 1
    %subplot(1,4,3);imshow(F1); % Display the result
    %draw the FFT result for image2
    F2 = fftshift(fft2(image2)); % Center FFT
    F2 = abs(F2); % Get the magnitude
    F2 = log(F2+1); % Use log, for perceptual scaling, and +1 since log(0) is undefined
    F2 = mat2gray(F2); % Use mat2gray to scale the image between 0 and 1
    %subplot(1,4,4);imshow(F2); % Display the result
    %phase correlation main calculation
    FFT2 = conj(fft2(image2)); 
    FFTR = FFT1.*FFT2; 
    magFFTR = abs(FFTR); 
    FFTRN = (FFTR./magFFTR);
    result = ifft2(double(FFTRN));
    [y x]=find(result==max(max(result)));
    x=x(1,1); y=y(1,1);
    %offset
   if x>640*size0
        x=(1280*size0)-x;
    end
    if y>512*size0
        y=(1024*size0)-y;
    end
    length =sqrt(x*x+y*y)*(1/size0);
    phase_correlation(i)=length;
    t2=clock;
    time = etime(t2,t1);
end
figure;plot(defocus_length, phase_correlation);