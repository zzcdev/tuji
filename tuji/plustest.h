//
//  plustest.h
//  plustest
//
//  Created by kaifa on 15/7/1.
//  Copyright (c) 2015年 tuji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "opencv2.framework/Headers/imgproc.hpp"
#import "opencv2.framework/Headers/opencv.hpp"

#import "opencv2.framework/Headers/core/core_c.h"
#import "opencv2.framework/Headers/core/types_c.h"
#import "opencv2.framework/Headers/highgui/highgui_c.h"
#import "opencv2.framework/Headers/imgproc/imgproc_c.h"
#import "opencv2.framework/Headers/core/cvdef.h"
#import "opencv2.framework/Headers/imgproc.hpp"
#import "opencv2.framework/Headers/core.hpp"
#import "opencv2.framework/Headers/core/matx.hpp"
#import "opencv2.framework/Headers/core/mat.hpp"
#import "opencv2.framework/Headers/core/mat.inl.hpp"
@interface plustest : NSObject
//阴影自动模式
IplImage * yinying_auto_cj0515(IplImage * img_ipl );//阴影自动模式

IplImage * ALG_Centralize(IplImage *img,int flag_zoom, int flag_auto,int method,int ncluster,cv::Point a,cv::Point b,cv::Point c,cv::Point d ,int flag_debug,int flag_HP);//0615 扶正算法

IplImage* light_auto0515(IplImage* img_ipl);//(1) //  亮度调节 ,用在原图之前//ios

IplImage * bilateral_auto(IplImage * img,int model);//双边滤波器 用于去除图像褶皱  //ios 能用



@end