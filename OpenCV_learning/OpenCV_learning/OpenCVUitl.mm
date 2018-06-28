//
//  OpenCVUitl.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/1.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "OpenCVUitl.h"
#import <opencv2/opencv.hpp>


@interface OpenCVUitl ()
{
    IplImage *g_pSrcImage; //原图
    IplImage *g_pCannyImage;//边缘图
    IplImage *g_pGrayImage;//灰度图
    IplImage *g_pBinaryImage;//二值图
    CvSeq *g_pcvSeq;
}

@end

@implementation OpenCVUitl
/**
cvCvtColor(...),是Opencv里的颜色空间转换函数，可以实现rgb颜色向HSV,HSI等颜色空间的转换，也可以转换为灰度图像。
　　参数CV_BGR2GRAY是RGB到gray,
　　参数 CV_GRAY2BGR是gray到RGB.
处理结果是彩色的,则转灰色就是了：
　　void cvCvtColor( const CvArr* src, CvArr* dst, int code );
　　src 输入的 8-bit,16-bit或 32-bit单倍精度浮点数影像。
　　dst 输出的8-bit, 16-bit或 32-bit单倍精度浮点数影像。
　　code 色彩空间转换的模式，该code来实现不同类型的颜色空间转换。比如CV_BGR2GRAY表示转换为灰度图，CV_BGR2HSV将图片从RGB空间转换为HSV空间。其中当code选用CV_BGR2GRAY时，dst需要是单通道图片。当code选用CV_BGR2HSV时，对于8位图，需要将rgb值归一化到0-1之间。这样得到HSV图中的H范围才是0-360，S和V的范围是0-1。
*/
// UIimage转IPlImage
- (IplImage *)convertToIplImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //创建临时IplImage绘画
    IplImage *iplImage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
    //创建IplImage上下文（CGContext）
    CGContextRef contextRef = CGBitmapContextCreate(iplImage->imageData, iplImage->width, iplImage->height, iplImage->depth, iplImage->widthStep, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    //绘制CGImage 到上下文
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    //创建返回IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, ret, CV_RGB2BGR);
    cvReleaseImage(&iplImage);
    return ret;
}
/***
 * IplImage类型转换为UIImage类型
 * 注：IplImage图像通道数必须为3或4
 */
-(UIImage*)convertToUIImage:(IplImage*)image
{
     NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
    cvCvtColor(image, image, CV_BGR2RGB);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(image->width, image->height, image->depth, image->depth * image->nChannels, image->widthStep, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

/***
 *从iplimage创建一张UIImage
 *代码如下：
 * NOTE You should convert color mode as RGB before passing to this function
 */
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
    NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data =
    [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

#pragma mark 图片大小变换
/**
 1.1 cvResize
 函数功能：图像大小变换
 函数原型：
 voidcvResize(
 
 const CvArr* src,
 
 CvArr* dst,
 
 intinterpolation=CV_INTER_LINEAR
 
 );
 函数说明：
 第一个参数表示输入图像。
 第二个参数表示输出图像。
 第三个参数表示插值方法，可以有以下四种：
 CV_INTER_NN - 最近邻插值,
 CV_INTER_LINEAR - 双线性插值 (缺省使用)
 CV_INTER_AREA - 使用象素关系重采样。当图像缩小时候，该方法可以避免波纹出现。当图像放大时，类似于 CV_INTER_NN 方法..
 CV_INTER_CUBIC - 立方插值.
 这个函数在功能上与Win32 API中的StretchBlt()函数类似。
 
1.2 cvCreateImage
函数功能：创建图像
函数原型：
IplImage* cvCreateImage(CvSize size, intdepth, intchannels);
函数说明：
第一个参数表示图像的大小。
第二个参数表示图像的深度，可以为IPL_DEPTH_8U，IPL_DEPTH_16U等等。
第三个参数表示图像的通道数。
 */

- (UIImage *)scaleImage:(UIImage *)image
{
    double fScale = 0.314; //缩放倍数
    CvSize czSize; //目标图片尺寸
    //转换目标图片
    IplImage *pSrcImage = [self convertToIplImage:image];
    //缩放变化后图片
    IplImage *pDstImage = NULL;
    
    //计算目标图片大小
    czSize.width = pSrcImage->width * fScale;
    czSize.height = pSrcImage->height * fScale;
    
    //创建图像并缩放
    pDstImage = cvCreateImage(czSize, pSrcImage->depth, pSrcImage->nChannels);
    cvResize(pSrcImage, pDstImage, CV_INTER_AREA);
    
    UIImage *returnImage = [self convertToUIImage:pDstImage];
    cvReleaseImage(&pDstImage);
    cvReleaseImage(&pSrcImage);
    return returnImage;
}
#pragma mark }

#pragma mark 图像边缘检测 {
/**
 1.1 cvCanny
 函数功能：采用Canny方法对图像进行边缘检测
 函数原型：
 void cvCanny(
 
 const CvArr* image,
 
 CvArr* edges,
 
 double threshold1,double threshold2,
 
 int aperture_size=3
 
 );
 第一个参数表示输入图像，必须为单通道灰度图。
 第二个参数表示输出的边缘图像，为单通道黑白图。
 第三个参数和第四个参数表示阈值，这二个阈值中当中的小阈值用来控制边缘连接，大的阈值用来控制强边缘的初始分割即如果一个像素的梯度大与上限值，则被认为是边缘像素，如果小于下限阈值，则被抛弃。如果该点的梯度在两者之间则当这个点与高于上限值的像素点连接时我们才保留，否则删除。
 第五个参数表示Sobel 算子大小，默认为3即表示一个3*3的矩阵。Sobel 算子与高斯拉普拉斯算子都是常用的边缘算子，详细的数学原理可以查阅专业书籍
 */

- (UIImage *)edgeDetectionForImage:(UIImage *)image
{
    g_pSrcImage = [self convertToIplImage:image];
    g_pCannyImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    UIImage *returnImage = [self edgeDetectionSliderValue:1];
    return returnImage;
}

- (UIImage *)edgeDetectionSliderValue:(int)value
{
    cvCanny(g_pSrcImage, g_pCannyImage, value * 3, 3);
    IplImage* grayImagePlus = cvCreateImage(cvGetSize(g_pCannyImage), IPL_DEPTH_8U, 3);
    cvCvtColor(g_pCannyImage, grayImagePlus, CV_GRAY2BGR);
    UIImage *returnImage = [self convertToUIImage:grayImagePlus];
    return returnImage;
}
#pragma mark }

#pragma mark 图像二值化 {
//与边缘检测相比，轮廓检测有时能更好的反映图像的内容。而要对图像进行轮廓检测，则必须要先对图像进行二值化，图像的二值化就是将图像上的像素点的灰度值设置为0或255，这样将使整个图像呈现出明显的黑白效果。在数字图像处理中，二值图像占有非常重要的地位，图像的二值化使图像中数据量大为减少，从而能凸显出目标的轮廓。
/**
关键函数——cvThreshold()。
函数功能：采用Canny方法对图像进行边缘检测
函数原型：
void cvThreshold(
                 const CvArr* src,
                 
                 CvArr* dst,
                 
                 double threshold,
                 
                 double max_value,
                 
                 int threshold_type
                 
                 );
函数说明：
第一个参数表示输入图像，必须为单通道灰度图。
第二个参数表示输出的边缘图像，为单通道黑白图。
第三个参数表示阈值
第四个参数表示最大值。
第五个参数表示运算方法。
在OpenCV的imgproc\types_c.h中可以找到运算方法的定义。

 Threshold types
enum
{
    CV_THRESH_BINARY      =0,  // value = value > threshold ? max_value : 0
    CV_THRESH_BINARY_INV  =1,  // value = value > threshold ? 0 : max_value
    CV_THRESH_TRUNC       =2,  // value = value > threshold ? threshold : value
    CV_THRESH_TOZERO      =3,  // value = value > threshold ? value : 0
    CV_THRESH_TOZERO_INV  =4,  // value = value > threshold ? 0 : value
    CV_THRESH_MASK        =7,
    CV_THRESH_OTSU        =8   // use Otsu algorithm to choose the optimal threshold value; combine the flag with one of the above CV_THRESH_* values
};
注释已经写的很清楚了，因此不再用中文来表达了。
*/
- (UIImage *)binarizationFor:(UIImage *)image
{
    g_pSrcImage = [self convertToIplImage:image];
    //转为单通道灰度图
    g_pGrayImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    cvCvtColor(g_pSrcImage, g_pGrayImage, CV_BGR2GRAY);
    //创建二值图
    g_pBinaryImage = cvCreateImage(cvGetSize(g_pGrayImage), IPL_DEPTH_8U, 1);
    
    return [self changeBinarizationValue:1];
}

- (UIImage *)changeBinarizationValue:(int)value
{
    //转为二值图
    cvThreshold(g_pGrayImage, g_pBinaryImage, value, 255, CV_THRESH_BINARY);
    IplImage *resultImage = cvCreateImage(cvGetSize(g_pBinaryImage), IPL_DEPTH_8U, 3);
    cvCvtColor(g_pBinaryImage, resultImage, CV_GRAY2BGR);
    UIImage *returnImage = [self convertToUIImage:resultImage];
    cvReleaseImage(&resultImage);
    return returnImage;
}
#pragma mark }

#pragma mark 轮廓检测1 {
/**
 1.1  cvFindContours
 函数功能：对图像进行轮廓检测，这个函数将生成一条链表以保存检测出的各个轮廓信息，并传出指向这条链表表头的指针。
 函数原型：
 int cvFindContours(

 CvArr* image,
 
 CvMemStorage* storage,
 
 CvSeq** first_contour,
 
 int header_size=sizeof(CvContour),
 
 int mode=CV_RETR_LIST,
 
 int method=CV_CHAIN_APPROX_SIMPLE,
 
 CvPoint offset=cvPoint(0,0)
 );
 函数说明：
 第一个参数表示输入图像，必须为一个8位的二值图像。
 第二参数表示存储轮廓的容器。为CvMemStorage类型，定义在OpenCV的\core\types_c.h中。
 第三个参数为输出参数，这个参数将指向用来存储轮廓信息的链表表头。
 第四个参数表示存储轮廓链表的表头大小，当第六个参数传入CV_CHAIN_CODE时，要设置成sizeof(CvChain)，其它情况统一设置成sizeof(CvContour)。
 第五个参数为轮廓检测的模式，有如下取值：
    CV_RETR_EXTERNAL：只检索最外面的轮廓；
 　 CV_RETR_LIST：检索所有的轮廓，并将其保存到一条链表当中；
 　 CV_RETR_CCOMP：检索所有的轮廓，并将他们组织为两层：顶层是各部分的外部边界，第二层是空洞的边界；
    CV_RETR_TREE：检索所有的轮廓，并重构嵌套轮廓的整个层次，可以参见下图。
    (http://img.my.csdn.net/uploads/201212/03/1354536171_2954.PNG)
 第六个参数用来表示轮廓边缘的近似方法的，常用值如下所示：
    CV_CHAIN_CODE：以Freeman链码的方式输出轮廓，所有其他方法输出多边形（顶点的序列）。
    CV_CHAIN_APPROX_SIMPLE：压缩水平的、垂直的和斜的部分，也就是，函数只保留他们的终点部分。
 第七个参数表示偏移量，比如你要从图像的（100, 0）开始进行轮廓检测，那么就传入（100, 0）。
 使用cvFindContours函数能检测出图像的轮廓，将轮廓绘制出来则需要另一函数——cvDrawContours来配合了。下面介绍cvDrawContours函数。
 
 1.2  cvDrawContours
 函数功能：在图像上绘制外部和内部轮廓
 函数原型：
 void cvDrawContours(
 CvArr *img,
 CvSeq* contour,
 CvScalar external_color,
 CvScalar hole_color,
 int max_level,
 int thickness=1,
 int line_type=8,
 CvPoint offset=cvPoint(0,0)
 );
 第一个参数表示输入图像，函数将在这张图像上绘制轮廓。
 第二个参数表示指向轮廓链表的指针。
 第三个参数和第四个参数表示颜色，绘制时会根据轮廓的层次来交替使用这二种颜色。
 第五个参数表示绘制轮廓的最大层数，如果是0，只绘制contour；如果是1，追加绘制和contour同层的所有轮廓；如果是2，追加绘制比contour低一层的轮廓，以此类推；如果值是负值，则函数并不绘制contour后的轮廓，但是将画出其子轮廓，一直到abs(max_level) - 1层。
 第六个参数表示轮廓线的宽度，如果为CV_FILLED则会填充轮廓内部。
 第七个参数表示轮廓线的类型。
 第八个参数表示偏移量，如果传入（10，20），那绘制将从图像的（10，20）处开始。
 */

- (UIImage *)drawingImage
{
    int imageW = 200;
    int imageH = 100;
    g_pSrcImage = cvCreateImage(cvSize(imageW, imageH), IPL_DEPTH_8U, 3);
    //填充成白色
    cvRectangle(g_pSrcImage, cvPoint(0, 0), cvPoint(g_pSrcImage->width, g_pSrcImage->height), CV_RGB(255, 255, 255), CV_FILLED);
    //画圆
    CvPoint ptCircelCenter = cvPoint(imageW / 4, imageH / 2);//圆心
    int nRadius = 40;//半径
    cvCircle(g_pSrcImage, ptCircelCenter, nRadius, CV_RGB(255, 255, 0)
    , CV_FILLED);
    ptCircelCenter = cvPoint(imageW / 4, imageH / 2);
    nRadius = 20;
    cvCircle(g_pSrcImage, ptCircelCenter, nRadius, CV_RGB(255, 255, 255), CV_FILLED);
    
    //画矩形
    CvPoint ptLeftTop = cvPoint(imageW / 2 + 20, 20);
    CvPoint ptRightBottom = cvPoint(imageW - 20, imageH - 20);
    cvRectangle(g_pSrcImage, ptLeftTop, ptRightBottom, CV_RGB(0, 255, 255), CV_FILLED);
    ptLeftTop = cvPoint(imageW / 2 + 60, 40);
    ptRightBottom = cvPoint(imageW - 60, imageH - 40);
    cvRectangle(g_pSrcImage, ptLeftTop, ptRightBottom, CV_RGB(255, 255, 255), CV_FILLED);
    return [self convertToUIImage:g_pSrcImage];
}

- (UIImage *)outlineImageForLevels:(int)levels
{
    //转为灰度图
    g_pGrayImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    cvCvtColor(g_pSrcImage, g_pGrayImage, CV_BGR2GRAY);
    //转为二值图
    g_pBinaryImage = cvCreateImage(cvGetSize(g_pGrayImage), IPL_DEPTH_8U, 1);
    cvThreshold(g_pGrayImage, g_pBinaryImage, 250, 255, CV_THRESH_BINARY);
    
    //检索轮廓并返回检测到的轮廓的个数
    CvMemStorage *pcvMStorage = cvCreateMemStorage();
    CvSeq *pcvSeq = NULL;
    cvFindContours(g_pBinaryImage, pcvMStorage, &pcvSeq, sizeof(CvContour), CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    
    //画轮廓图
    IplImage *pOutlineImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 3);
    //填充成白色
    cvRectangle(pOutlineImage, cvPoint(0, 0), cvPoint(pOutlineImage->width, pOutlineImage->height), CV_RGB(255, 255, 255), CV_FILLED);
    cvDrawContours(pOutlineImage, pcvSeq, CV_RGB(255, 0, 0), CV_RGB(0, 255, 0), levels, 2);
    UIImage *resultImage = [self convertToUIImage:pOutlineImage];
    
    cvReleaseImage(&pOutlineImage);
    return resultImage;
}
#pragma mark }

#pragma mark 轮廓检测2 {
- (UIImage *)outlineImageTowForImage:(UIImage *)image BackBinaryImage:(void(^)(UIImage *image))backBinaryImage
{
    g_pSrcImage = [self convertToIplImage:image];
    g_pGrayImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    cvCvtColor(g_pSrcImage, g_pGrayImage, CV_BGR2GRAY);
    UIImage *returnImage = [self changeLevels:0 BlackBinaryImage:^void(UIImage *image) {
        if (backBinaryImage) {
            backBinaryImage(image);
        }
    }];
    return returnImage;
}

- (UIImage *)changeLevels:(int)levels BlackBinaryImage:(void(^)(UIImage *image))blackBinaryImage
{
    //转化为二值图
    g_pBinaryImage = cvCreateImage(cvGetSize(g_pGrayImage), IPL_DEPTH_8U, 1);
    cvThreshold(g_pGrayImage, g_pBinaryImage, levels, 255, CV_THRESH_BINARY);
    
    IplImage *binaryImage = cvCreateImage(cvGetSize(g_pBinaryImage), IPL_DEPTH_8U, 3);
    cvCvtColor(g_pBinaryImage, binaryImage, CV_GRAY2BGR);
    if (blackBinaryImage) {
        
        blackBinaryImage([self convertToUIImage:binaryImage]);
    }
    
    CvMemStorage *cvMStorage = cvCreateMemStorage();
    //检索轮廓并返回检测到的轮廓的个数
    cvFindContours(g_pBinaryImage, cvMStorage, &g_pcvSeq);
    IplImage *pOutlineImage = cvCreateImage(cvGetSize(g_pGrayImage), IPL_DEPTH_8U, 3);

    cvZero(pOutlineImage);
    cvDrawContours(pOutlineImage, g_pcvSeq, CV_RGB(255, 0, 0), CV_RGB(0, 255, 0), 5);
    
    UIImage *outlineImage = [self convertToUIImage:pOutlineImage];
    cvReleaseImage(&pOutlineImage);
    cvReleaseImage(&binaryImage);
    return outlineImage;
}
#pragma mark }

#pragma mark 线段检测与圆检测
//线段检测与圆检测主要运用Hough变换，Hough变换是一种利用图像的全局特征将特定形状的边缘连接起来，形成连续平滑边缘的一种方法。它通过将源图像上的点影射到用于累加的参数空间，实现对已知解析式曲线进行识别。
/**
 函数功能：检测图像中的线段
 CvSeq* cvHoughLines2(
 CvArr* image,
 void* line_storage,
 int method,
 double rho,
 double theta,
 int threshold,
 double param1=0, double param2=0
 );
 参数说明：
 第一个参数表示输入图像，必须为二值图像（黑白图）。
 第二个参数表示存储容器，和上一篇的轮廓检测一样，可以传入CvMemStorage类型的指针。
 第三个参数表示变换变量，可以取值：
 CV_HOUGH_STANDARD - 传统或标准 Hough 变换. 每一个线段由两个浮点数 (ρ, θ) 表示，其中 ρ 是线段与原点 (0,0) 之间的距离，θ 线段与 x-轴之间的夹角。
 CV_HOUGH_PROBABILISTIC - 概率 Hough 变换(如果图像包含一些长的线性分割，则效率更高)。它返回线段分割而不是整个线段。每个分割用起点和终点来表示。
 CV_HOUGH_MULTI_SCALE - 传统 Hough 变换的多尺度变种。线段的编码方式与 CV_HOUGH_STANDARD 的一致。
 第四个参数表示与象素相关单位的距离精度。
 第五个参数表示弧度测量的角度精度。
 第六个参数表示检测线段的最大条数，如果已经检测这么多条线段，函数返回。
 第七个参数与第三个参数有关，其意义如下：
 对传统 Hough 变换，不使用(0).
 对概率 Hough 变换，它是最小线段长度.
 对多尺度 Hough 变换，它是距离精度 rho 的分母 (大致的距离精度是 rho 而精确的应该是 rho / param1 ).
 第八个参数与第三个参数有关，其意义如下：
 对传统 Hough 变换，不使用 (0).
 对概率 Hough 变换，这个参数表示在同一条线段上进行碎线段连接的最大间隔值(gap), 即当同一条线段上的两条碎线段之间的间隔小于param2时，将其合二为一。
 对多尺度 Hough 变换，它是角度精度 theta 的分母 (大致的角度精度是 theta 而精确的角度应该是 theta / param2).
 */
- (UIImage *)lineDetectionForImage:(UIImage *)image
{
    g_pSrcImage = [self convertToIplImage:image];
    
    g_pGrayImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    cvCvtColor(g_pSrcImage, g_pGrayImage, CV_BGR2GRAY);
    
    g_pCannyImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    cvCanny(g_pSrcImage, g_pCannyImage, 30, 90);
    
    //线段检测（只能针对二值图像）
    CvMemStorage *pcvMStorage = cvCreateMemStorage();
    double fRho = 1;
    double fTheta = CV_PI / 180;
    int nMaxLineNUmber = 50; //最多检测直线数
    double fMinLineLen = 50; //最小线段长度
    double fMinLineGap = 10; //最小线段间隔
    CvSeq *pcvSeqLines = cvHoughLines2(g_pCannyImage, pcvMStorage, CV_HOUGH_PROBABILISTIC, fRho, fTheta, nMaxLineNUmber, fMinLineLen, fMinLineGap);
    //绘制线段
    IplImage *pColorImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 3);
    cvCvtColor(g_pCannyImage, pColorImage, CV_GRAY2BGR);
    for (int i = 0; i < pcvSeqLines->total; i++) {
        CvPoint *line = (CvPoint *)cvGetSeqElem(pcvSeqLines, i);
        cvLine(pColorImage, line[0], line[1], CV_RGB(255, 0, 0), 2);
    }
    UIImage *resultImage = [self convertToUIImage:pColorImage];
    cvReleaseMemStorage(&pcvMStorage);
    cvReleaseImage(&pColorImage);
    return resultImage;
}
/**
圆检测函数要用到cvHoughCircles这个函数的函数原形如下：
CVAPI(CvSeq*) cvHoughCircles(
                             CvArr* image, void* circle_storage,
                             int method,
                             double dp,
                             double min_dist,
                             double param1 CV_DEFAULT(100),
                             double param2 CV_DEFAULT(100),
                             int min_radius CV_DEFAULT(0),
                             int max_radius CV_DEFAULT(0)
                             );
可以看出cvHoughCircles与上面的cvHoughLines2函数比较类似，因此讲下部分参数的意思就可以了
第二个参数表示Hough变换方式，目前只能用CV_HOUGH_GRADIENT。
第三个参数表示寻找圆弧圆心的累计分辨率，通常设置成1就可以了。
第四个参数表示两个不同圆之间的最小距离，由于是按圆心来计算距离的，因此对同心圆的检测就无能为力了。
注意，圆检测函数可以使用灰度图。
*/
- (UIImage *)roundDetectionForImage:(UIImage *)image
{
    g_pSrcImage = [self convertToIplImage:image];
    //灰度图
    g_pGrayImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    cvCvtColor(g_pSrcImage, g_pGrayImage, CV_BGR2GRAY);
    
    //圆检测（灰度图）
    CvMemStorage *pcvMStorage = cvCreateMemStorage();
    double fMinCircleGap = g_pGrayImage->height / 10;
    CvSeq *pcvSeqCircles = cvHoughCircles(g_pGrayImage, pcvMStorage, CV_HOUGH_GRADIENT, 1, fMinCircleGap);
    //每个圆由三个浮点数表示：圆心坐标(x,y)和半径
    
    // 绘制直线
    IplImage *pColorImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 3);
    cvCvtColor(g_pGrayImage, pColorImage, CV_GRAY2BGR);
    int i;
    for (i = 0; i < pcvSeqCircles->total; i++)
    {
        float* p = (float*)cvGetSeqElem(pcvSeqCircles, i);
        cvCircle(pColorImage, cvPoint(cvRound(p[0]), cvRound(p[1])), cvRound(p[2]), CV_RGB(255, 0, 0), 2);
    }
    UIImage *resultImage = [self convertToUIImage:pColorImage];
    cvReleaseImage(&pColorImage);
    cvReleaseMemStorage(&pcvMStorage);
    return resultImage;
}
#pragma mark }

#pragma mark灰度直方图
// 直方图(Histogram)又称柱状图、质量分布图，是一种统计报告图。直方图由一系列高度不等的纵向条纹或线段表示数据分布的情况。一般用横轴表示数据类型，纵轴表示分布情况。在图像处理上，直方图是图像信息统计的有力工具。
/*
一、cvCreateHist
函数功能：创建直方图
函数原型：
CVAPI(CvHistogram*)  cvCreateHist( // Creates new histogram
                                  int dims,
                                  int* sizes,
                                  int type,
                                  float** ranges CV_DEFAULT(NULL),
                                  int uniform CV_DEFAULT(1)
                                  );
参数说明：
第一个参数表示直方图维数，灰度图为1，彩色图为3。
第二个参数表示直方图维数的数目，其实就是sizes数组的维数。
第三个参数表示直方图维数尺寸的数组。
第四个参数表示直方图类型，为CV_HIST_ARRAY表示直方图数据表示为多维密集数组，为CV_HIST_TREE表示直方图数据表示为多维稀疏数组。
第五个参数表示归一化标识，其原理有点复杂。通常使用默认值即可。

函数说明：
直方图的数据结构如下所示：
typedef struct CvHistogram {
    int     type;
    CvArr*  bins;
    float   thresh[CV_MAX_DIM][2]; // For uniform histograms.
    float** thresh2;   //For non-uniform histograms.
    CvMatND mat; // Embedded matrix header for array histograms.
}CvHistogram;

二．cvCalcHist
函数功能：根据图像计算直方图
函数原型：
void  cvCalcHist(
                 IplImage** image,
                 CvHistogram* hist,
                 int accumulate CV_DEFAULT(0),
                 const CvArr* mask CV_DEFAULT(NULL)
                 )
参数说明：
第一个参数表示输入图像。
第二个参数表示输出的直方图指针。
第三个参数操作mask, 确定输入图像的哪个象素被计数。
第四个参数表示累计标识。如果设置，则直方图在开始时不被清零。这个特征保证可以为多个图像计算一个单独的直方图，或者在线更新直方图。
函数说明：
这是个inline函数，函数内部会直接调用cvCalcArrHist( (CvArr**)image, hist, accumulate, mask );
 */
- (UIImage *)createGrayImage:(UIImage *)image BackGrayImage:(void(^)(UIImage *grayImage))backGrayImage
{
    // 从文件中加载原图
    g_pSrcImage = [self convertToIplImage:image];
    g_pGrayImage = cvCreateImage(cvGetSize(g_pSrcImage), IPL_DEPTH_8U, 1);
    // 灰度图
    cvCvtColor(g_pSrcImage, g_pGrayImage, CV_BGR2GRAY);
    
    // 灰度直方图
    CvHistogram *pcvHistogram = [self createGrayImageHist:&g_pGrayImage];
    
    // 创建直方图图像
    int nHistImageWidth = 255;
    int nHistImageHeight = 150;  //直方图图像高度
    int nScale = 2;
    IplImage *pHistImage = [self createHisogramImage:nHistImageWidth Scale:nScale ImageH:nHistImageHeight PCVHostogram:pcvHistogram];

    IplImage *histImage = cvCreateImage(cvGetSize(pHistImage), IPL_DEPTH_8U, 3);
    cvCvtColor(pHistImage, histImage, CV_GRAY2BGR);
    UIImage *resultImage = [self convertToUIImage:histImage];
    IplImage *resultGray = cvCreateImage(cvGetSize(g_pGrayImage), IPL_DEPTH_8U, 3);
    cvCvtColor(g_pGrayImage, resultGray, CV_GRAY2BGR);
    UIImage *gImage = [self convertToUIImage:resultGray];
    if (backGrayImage) {
        backGrayImage(gImage);
    }
    cvReleaseHist(&pcvHistogram);
    cvReleaseImage(&pHistImage);
    cvReleaseImage(&histImage);
    return resultImage;
}
//填充白色
- (void)fillWhiteImage:(IplImage *)pImage
{
    cvRectangle(pImage, cvPoint(0, 0), cvPoint(pImage->width, pImage->height), CV_RGB(255, 255, 255), CV_FILLED);
}

// 创建灰度图像的直方图
- (CvHistogram *)createGrayImageHist:(IplImage **)ppImage
{
    int nHistSize = 256;
    float fRange[] = {0, 255};  //灰度级的范围
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
    [self fillWhiteImage:pHistImage];

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

- (void)dealloc
{
    cvReleaseImage(&g_pSrcImage);
    cvReleaseImage(&g_pGrayImage);
    cvReleaseImage(&g_pBinaryImage);
}

@end
