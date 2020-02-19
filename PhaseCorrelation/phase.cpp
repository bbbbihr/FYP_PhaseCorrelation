#include <iostream>
#include "correlation.h"
#include <opencv2/imgcodecs.hpp>
#include <opencv2/opencv.hpp>
#include <time.h>
using namespace cv;
using namespace std;

cv::Mat ShiftTransform(const cv::Mat &source, const cv::Mat &target, bool bUseHanningWindow)
{
    CV_Assert(source.type() == CV_32FC1);
    CV_Assert(target.type() == CV_32FC1);

    Point2d shift;
    if(bUseHanningWindow)
    {
       Mat hann;
       createHanningWindow(hann, source.size(), CV_32F);
       shift= phaseCorrelate(source, target, hann);
    }
    else
    {
        shift= phaseCorrelate(source, target);
    }

    cout << "Detected shift: " << shift << endl;

    Mat H = (Mat_<float>(2, 3) << 1.0, 0.0, shift.x, 0.0, 1.0, shift.y);
    Mat res;
    warpAffine(source, res, H, target.size());

    CV_Assert(res.size() == target.size());
    CV_Assert(res.type() == CV_32FC1);
    return res;
}

Mat img_proc(Mat src, double size0=0.5)
{
  Mat dst;Mat rgb[3];Mat dst_new;
  split(src,rgb);
  dst=rgb[1];
  resize(dst,dst,Size(),size0,size0,INTER_CUBIC);
  cv::Mat noise(dst.size(),dst.type());
  float m = 0;
  float sigma = 10;
  cv::randn(noise, m, sigma); //mean and variance
  dst += noise;
  dst.convertTo(dst_new, CV_32F,1.0/255);
  //?
  //cv::log(dst_new,dst_new);
  return dst_new;
}

int main(void)
{
  clock_t tStart = clock();
  Mat img1=imread("ep_x10_11A.png");
  Mat dst1 = img_proc(img1);
  //namedWindow("1");
  //imshow("1",dst1);
  //waitKey();

  Mat img2=imread("ep_x10_11B.png");
  Mat dst2 = img_proc(img2);
  //namedWindow("2");
  //imshow("2",dst2);
  //waitKey();

  Mat result = ShiftTransform(dst1, dst2,true);
  printf("Time taken: %.2fs\n", (double)(clock()-tStart)/CLOCKS_PER_SEC);
  //namedWindow("3");
  //imshow("3", result);
  //waitKey();

}
