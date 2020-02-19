#ifndef NOISE_H_INCLUDED
#define NOISE_H_INCLUDED
#include <random>
#include <cmath>
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;
double generateGaussianNoise(double mu, double sigma);
Mat addGaussianNoise(Mat &srcImag);
#endif // NOISE_H_INCLUDED
