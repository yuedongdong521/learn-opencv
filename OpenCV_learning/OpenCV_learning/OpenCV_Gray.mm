//
//  OpenCV_Gray.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/5.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "OpenCV_Gray.h"
#import "IplImageToUIImageTool.h"

@interface OpenCV_Gray ()
{
    IplImage *drawPlImage;
}


@end

@implementation OpenCV_Gray

#pragma mark 灰度直方图均衡化(图像增强的常用方法)
/**
 一．cvEqualizeHist
 函数功能：直方图均衡化，该函数能归一化图像亮度和增强对比度
 函数原型：
 // 相等的8位单通道图像的直方图
CVAPI(void)  cvEqualizeHist( const CvArr* src, CvArr* dst );
第一个参数表示输入图像，必须为灰度图（8位，单通道图）。
第二个参数表示输出图像
函数说明：
该函数采用如下法则对输入图像进行直方图均衡化：
　　1：计算输入图像的直方图H。
　　2：直方图归一化，因此直方块和为255。
　　3：计算直方图积分，H'(i) = Sum(H(j)) (0<=j<=i)。
　　4：采用H'作为查询表：dst(x, y) = H'(src(x, y))进行图像变换。
 */
- (void)fillWhite:(IplImage *)pImage
{
    //填充白色
    cvRectangle(pImage, cvPoint(0, 0), cvPoint(pImage->width, pImage->height), CV_RGB(255, 255, 255), CV_FILLED);
}
//穿件灰度图像的直方图
- (CvHistogram *)createGrayImageHist:(IplImage **)ppImage
{
    int nHistSize = 256;
    float fRange[] = {0, 255}; //灰度级的范围
    float *pfRanges[] = {fRange};
    CvHistogram *pcvHistogram = cvCreateHist(1, &nHistSize, CV_HIST_ARRAY, pfRanges);
    cvCalcHist(ppImage, pcvHistogram);
    return pcvHistogram;
}

// 根据直方图创建直方图图像
#define cvQueryHistValue_1D( hist, idx0 )  ((float)cvGetReal1D( (hist)->bins, (idx0)))
- (IplImage *)createHisogramImage:(int)imageW Scale:(int)scale ImageH:(int)imageH PCVHostogram:(CvHistogram *)pcvHistogram
{
    IplImage *pHistImage = cvCreateImage(cvSize(imageW * scale, imageH), IPL_DEPTH_8U, 1);
    [self fillWhite:pHistImage];
    
    //统计直方图中的最大直方块
    float fMaxHistValue = 0;
    cvGetMinMaxHistValue(pcvHistogram, NULL, &fMaxHistValue, NULL, NULL);
    
    //分别将每个直方块的值绘制到图中
    for(int i = 0; i < imageW; i++)
    {
        float fHistValue = cvQueryHistValue_1D(pcvHistogram, i); //像素为i的直方块大小
        int nRealHeight = cvRound((fHistValue / fMaxHistValue) * imageH);  //要绘制的高度
        cvRectangle(pHistImage,
                    cvPoint(i * scale, imageH - 1),
                    cvPoint((i + 1) * scale - 1, imageH - nRealHeight),
                    cvScalar(i, 0, 0, 0),
                    CV_FILLED
                    );
    }
    return pHistImage;
}

- (void)equalIzeGrayImage:(UIImage *)image BackEQGrayImage:(void(^)(UIImage *grayImage, UIImage *grayHImage, UIImage *grayEImage, UIImage *grayEHImage))backEQGImage
{
    IplImage *pSrcImage = [IplImageToUIImageTool convertToIplImage:image];
    IplImage *pGrayImage = cvCreateImage(cvGetSize(pSrcImage), IPL_DEPTH_8U, 1);
    IplImage *pGrayEqualizeImage = cvCreateImage(cvGetSize(pSrcImage), IPL_DEPTH_8U, 1);
    
    //灰度图
    cvCvtColor(pSrcImage, pGrayImage, CV_BGR2GRAY);
    //直方图图像数据
    int nHistImageWidth = 255;
    int nHistImageHeight = 150;
    int nScale = 2;
    
    //灰度直方图及直方图图像
    CvHistogram *pcvHistoram = [self createGrayImageHist:&pGrayImage];
    IplImage *pHistImage = [self createHisogramImage:nHistImageWidth Scale:nScale ImageH:nHistImageHeight PCVHostogram:pcvHistoram];
    
    //均衡化
    cvEqualizeHist(pGrayImage, pGrayEqualizeImage);
    
    //均衡化后的灰度直方图及直方图图像
    CvHistogram *pcvHistogramEqualize = [self createGrayImageHist:&pGrayEqualizeImage];
    IplImage *pHistEqualizeImage = [self createHisogramImage:nHistImageWidth Scale:nScale ImageH:nHistImageHeight PCVHostogram:pcvHistogramEqualize];
    
    IplImage *p_grayImage = cvCreateImage(cvGetSize(pGrayImage), IPL_DEPTH_8U, 3);
    cvCvtColor(pGrayImage, p_grayImage, CV_GRAY2BGR);
    UIImage *r_grayImage = [IplImageToUIImageTool convertToUIImage:p_grayImage];
    
    IplImage *p_grayHimage = cvCreateImage(cvGetSize(pHistImage), IPL_DEPTH_8U, 3);
    cvCvtColor(pHistImage, p_grayHimage, CV_GRAY2BGR);
    UIImage *r_gHistImage = [IplImageToUIImageTool convertToUIImage:p_grayHimage];
    
    IplImage *p_EquzlizImage = cvCreateImage(cvGetSize(pGrayEqualizeImage), IPL_DEPTH_8U, 3);
    cvCvtColor(pGrayEqualizeImage, p_EquzlizImage, CV_GRAY2BGR);
    UIImage *r_equzlizImage = [IplImageToUIImageTool convertToUIImage:p_EquzlizImage];
    
    IplImage *p_EHisImage = cvCreateImage(cvGetSize(pHistEqualizeImage), IPL_DEPTH_8U, 3);
    cvCvtColor(pHistEqualizeImage, p_EHisImage, CV_GRAY2BGR);
    UIImage *r_EhisImage = [IplImageToUIImageTool convertToUIImage:p_EHisImage];
  
    if (backEQGImage) {
        backEQGImage(r_grayImage, r_gHistImage, r_equzlizImage, r_EhisImage);
    }
    
    cvReleaseImage(&pSrcImage);
    cvReleaseImage(&pGrayImage);
    cvReleaseHist(&pcvHistoram);
    cvReleaseHist(&pcvHistogramEqualize);
}

#pragma mark 彩色直方图均衡化
//在OpenCV中，彩色的图像其实是用一个多通道数组来存储的，每个单通道数组中的元素的取值范围都是0到255。这与灰度图中像素的变化范围是相同的。因此对彩色图像进行直方图均衡化只要先将彩色图像分解成若干通道，然后这些通道分别进行直方图均衡化，最后合并所有通道即可。下面介绍下二个主要函数cvSplit()和cvMerge()。
/*
 一．cvSplit
 函数功能：分割多通道数组成几个单通道数组或者从数组中提取一个通道。
 函数原型：
CVAPI(void)  cvSplit(
                     const CvArr* src,
                     
                     CvArr* dst0,
                     
                     CvArr* dst1,
                     
                     CvArr* dst2,
                     
                     CvArr* dst3
                     
                     );
参数说明：
第一个参数表示输入的多通道数组即输入图像。
第二，三，四，五个参数分别表示输出的单通道数组。

二．cvMerge
函数功能：合并几个单通道为多通道数组或者插入一个特定的单通道到多通道数组。
函数原型：
CVAPI(void)  cvMerge(
                     
                     const CvArr* src0,
                     
                     const CvArr* src1,
                     
                     const CvArr* src2,
                     
                     const CvArr* src3,
                     
                     CvArr* dst
                     
                     );
参数说明：
第一，二，三，四个参数表示输入的单通道数组。
第五个参数分别表示合并后的多通道数组即输出图像。
 */

//彩色图像的直方图均衡化
- (IplImage *)equalizeHistColorImage:(IplImage *)pImage
{
    IplImage *pEquaImage = cvCreateImage(cvGetSize(pImage), pImage->depth, 3);
    
    //原图像分成各通道后在均衡化，最后合并即彩色图像的直方图均衡化
    const int MAX_CHANNEL = 4;
    IplImage *pImageChannel[MAX_CHANNEL] = {NULL};
    for (int i = 0; i < pImage->nChannels; i++) {
        pImageChannel[i] = cvCreateImage(cvGetSize(pImage), pImage->depth, 1);
    }
    
    cvSplit(pImage, pImageChannel[0], pImageChannel[1], pImageChannel[2], pImageChannel[3]);
    for (int i = 0; i < pImage->nChannels; i++) {
        cvEqualizeHist(pImageChannel[i], pImageChannel[i]);
    }
    
    cvMerge(pImageChannel[0], pImageChannel[1], pImageChannel[2], pImageChannel[3], pEquaImage);
    for (int i = 0; i < pImage->nChannels; i++) {
        cvReleaseImage(&pImageChannel[i]);
    }
    return pEquaImage;
}

- (UIImage *)converEqualizeHistImage:(UIImage *)image
{
    IplImage *pSrcImage = [IplImageToUIImageTool convertToIplImage:image];
    IplImage *pHistEqualizeImage = [self equalizeHistColorImage:pSrcImage];
    UIImage *rImage = [IplImageToUIImageTool convertToUIImage:pHistEqualizeImage];
    cvReleaseImage(&pSrcImage);
    cvReleaseImage(&pHistEqualizeImage);
    return rImage;
}

#pragma mark 绘图

- (UIImage *)createDrawViewForWidth:(int)width ForHeight:(int)height
{
    drawPlImage = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);
    cvSet(drawPlImage, CV_RGB(255, 255, 255));//可以用cvSet()将图像填充成白色
    return [IplImageToUIImageTool convertToUIImage:drawPlImage];
}

- (UIImage *)drawForX:(int)x Y:(int)y TouchEvent:(NSInteger)event
{
    static BOOL canDraw = NO;
    static CvPoint startCvPoint = cvPoint(0, 0);
    
    switch (event) {
        case TouchEventBegan:
            canDraw = YES;
            startCvPoint = cvPoint(x, y);
            break;
        case TouchEventMoved:
            if (canDraw) {
               CvPoint cvCurrPoint = cvPoint(x, y);
                cvLine(drawPlImage, startCvPoint, cvCurrPoint, CV_RGB(0, 0, 20), 3);
                startCvPoint = cvCurrPoint;
            }
            break;
        case TouchEventCancel:
            
        case TouchEventEnd:
            canDraw = NO;
            break;
        default:
            break;
    }
    return [IplImageToUIImageTool convertToUIImage:drawPlImage];
}

- (UIImage *)rewardAction
{
    cvSet(drawPlImage, CV_RGB(255, 255, 255));
    return [IplImageToUIImageTool convertToUIImage:drawPlImage];
}

#pragma mark 人脸识别
/*
 函数功能：检测图像中的目录
 函数原型：
 CVAPI(CvSeq*) cvHaarDetectObjects(
 const CvArr* image,
 CvHaarClassifierCascade* cascade,
 CvMemStorage* storage,
 double scale_factor CV_DEFAULT(1.1),
 int min_neighbors CV_DEFAULT(3),
 int flags CV_DEFAULT(0),
 CvSize min_size CV_DEFAULT(cvSize(0,0)),
 CvSize max_size CV_DEFAULT(cvSize(0,0))
 );
 函数说明：
 第一个参数表示输入图像，尽量使用灰度图以加快检测速度。
 第二个参数表示Haar特征分类器，可以用cvLoad()函数来从磁盘中加载xml文件作为Haar特征分类器。
 第三个参数为CvMemStorage类型，大家应该很熟悉这个CvMemStorage类型了，《OpenCV入门指南》中很多文章都介绍过了。
 第四个参数表示在前后两次相继的扫描中，搜索窗口的比例系数。默认为1.1即每次搜索窗口依次扩大10%
 第五个参数表示构成检测目标的相邻矩形的最小个数(默认为3个)。如果组成检测目标的小矩形的个数和小于 min_neighbors - 1 都会被排除。如果min_neighbors 为 0, 则函数不做任何操作就返回所有的被检候选矩形框，这种设定值一般用在用户自定义对检测结果的组合程序上。
 第六个参数要么使用默认值，要么使用CV_HAAR_DO_CANNY_PRUNING，如果设置为CV_HAAR_DO_CANNY_PRUNING，那么函数将会使用Canny边缘检测来排除边缘过多或过少的区域，因此这些区域通常不会是人脸所在区域。
 第七个，第八个参数表示检测窗口的最小值和最大值，一般设置为默认即可。
 函数返回值：
 函数将返回CvSeq对象，该对象包含一系列CvRect表示检测到的人脸矩形
 */

- (UIImage *)detectionFaceForImage:(UIImage *)image
{
    return nil;
}


@end
