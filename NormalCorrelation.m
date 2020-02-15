clear;
time = zeros(1,100);
length = zeros(1,100);
size0 = 1;
for n=1:100
    image1 = imread("F:\Final year project\Test images\PreFACE raw data stacks\episcopic_20x_RFtarget\_AfBmpA_42_-16um.png");
    image2 = imread("F:\Final year project\Test images\PreFACE raw data stacks\episcopic_20x_RFtarget\_AfBmpB_42_-16um.png");
    tic;
    [r1,image1,b1] = imsplit(image1);
    [r2,image2,b2] = imsplit(image2);
    image1 = imresize(image1,size0, 'nearest');
    image2 = imresize(image2,size0, 'nearest');
    image1 = imnoise(image1,'gaussian',0,0.01) ;
    image2 = imnoise(image2,'gaussian',0,0.01) ;
    %Phase correlation filter
    corr = normxcorr2(image1, image2);
    %figure, surf(corr), shading flat
    [y x]=find(corr==max(max(corr)));
    %Account for the padding that normxcorr2 adds.
   if x>640*size0
        x=(1280*size0)-x;
    end
    if y>512*size0
        y=(1024*size0)-y;
    end
    length(n) =sqrt(x*x+y*y)*(1/size0);
    time(n)=toc;
    size0=size0-0.01;
end
subplot(1,2,1);plot(time);subplot(1,2,2);plot( length);