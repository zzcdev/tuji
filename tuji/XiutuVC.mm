
#import "XiutuVC.h"
#import "ZZCPrivateClass.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "plustest.h"

#define  TOOL_W (SCREEN_WIDTH/5)
#define  TOOL_H (SCREEN_WIDTH/5>64?64:45)
#define  line_H 1.5f
#define  ITEM_H 49.f
#define  CELL_H 2.0f

@interface XiutuVC ()

@property (nonatomic,strong) UIImageView *backgroundIV;
@property (nonatomic,strong) UIImage     *originalImage;
@property (nonatomic,strong) UIImage     *quyinyingImage;
@property (nonatomic,strong) UIImage     *fuzhengImage;
@property (nonatomic,strong) UIImage     *qubowenImage;
@property (nonatomic,strong) UIImage     *caijianImage;
@property (nonatomic,strong) UIImage     *image;
@property (nonatomic,strong) UIImageView *iv;
@property (nonatomic       ) IplImage    *iplImage1;
@property (nonatomic,strong) UIView      *topView;

@end

@implementation XiutuVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self createUI];
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor blackColor];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/5*2-44)];
    self.topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topView];
    
    //解析str获得图片
    NSLog(@"Xiutu.filePath1%@",self.filePath);
    self.filePath = [ZZCPrivateClass getFilePathByStr:self.filePath];
    NSLog(@"Xiutu.filePath2%@",self.filePath);
    
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:self.filePath];
    NSLog(@"data,lenght%lu",(unsigned long)data.length);
    self.originalImage = [UIImage imageWithData:data];
    self.image = self.originalImage;
    //背景图片控件
    self.backgroundIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    self.backgroundIV.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundIV.image = self.originalImage;
    NSLog(@"朝上%ld",(long)self.originalImage.imageOrientation);
    
    NSLog(@"朝上？%ld",(long)self.originalImage.imageOrientation);
    
    [self.topView addSubview:self.backgroundIV];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-ITEM_H - CELL_H - line_H, SCREEN_WIDTH, line_H)];
    line2.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    [self.view addSubview:line2];
    
    // 返回
    UIButton *backView = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-ITEM_H, ITEM_H, ITEM_H)];
    [backView setBackgroundImage:[UIImage imageNamed:@"底栏-返回.png"] forState:UIControlStateNormal];
    backView.tag = 101;
    [backView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backView];
    
    //确定
    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-ITEM_H, ITEM_H, ITEM_H)];
    CGPoint p1 = confirm.center;
    p1.x = self.view.center.x;
    confirm.center = p1;
    [confirm setBackgroundImage:[UIImage imageNamed:@"底栏-完成.png"] forState:UIControlStateNormal];
    confirm.tag = 102;
    [confirm addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
    
    NSArray * imgArr = @[@"修图-原图.png",
                         @"修图-亮度.png",
                         @"修图-扶正.png",
                         @"修图-去波纹.png",
                         @"修图-裁剪.png"];
    for (NSInteger i = 0; i < 5; i++)
    {
        UIButton * toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn setFrame:CGRectMake(i*TOOL_W,
                                     CGRectGetMinY(line2.frame) - TOOL_H - CELL_H,
                                     TOOL_W,
                                     TOOL_H)];
        toolBtn.tag = i + 1;
        [toolBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [toolBtn setImageEdgeInsets:UIEdgeInsetsMake(TOOL_H/4,
                                                     TOOL_W/2-TOOL_H/4,
                                                     TOOL_H/4,
                                                     TOOL_W/2-TOOL_H/4)];
        [toolBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:toolBtn];
    }    //两条线
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(line2.frame) - TOOL_H - CELL_H*2 - line_H, SCREEN_WIDTH, line_H)];
    line1.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    [self.view addSubview:line1];
}

-(void)btnClick:(UIButton *)sender
{
    [self removeAllSubViewsFromTopView];
    UIImageView *ivyinying = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, SCREEN_WIDTH-20,SCREEN_WIDTH-20)];
    ivyinying.contentMode = UIViewContentModeScaleAspectFit;
    [self.topView addSubview:ivyinying];
    
    NSLog(@"修图%ld!",(long)sender.tag);
    switch (sender.tag) {
        case 1:
            [SVProgressHUD showWithStatus:@"原图..."];
            
            ivyinying.image = self.originalImage;
            self.image = self.originalImage;
            NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
            
            
            [SVProgressHUD dismiss];
            break;
        case 2:
            [SVProgressHUD showWithStatus:@"修图中－去阴影..."];
            
            if (self.quyinyingImage) {
                ivyinying.image = self.quyinyingImage;
                self.image = self.quyinyingImage;
                NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
                [SVProgressHUD dismiss];
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 执⾏耗时的异步操作...
                    
                    UIImage *imagetest = self.originalImage;
                    NSLog(@"self.quyinyingImage%ld",(long)imagetest.imageOrientation);
                    
                    
                    self.iplImage1 = [self convertToIplImage:[self fixOrientation:self.originalImage]];
                    self.iplImage1 =yinying_auto_cj0515(self.iplImage1);
                    
                    self.quyinyingImage = [self convertToUIImage:self.iplImage1];
                    
                    NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 回到主线程,执⾏UI刷新操作
                        
                        ivyinying.image = self.quyinyingImage;
                        
                        self.image = self.quyinyingImage;
                        NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
                        
                        [SVProgressHUD dismiss];
                    });
                });
            }
            
            break;
        case 3:
            [SVProgressHUD showWithStatus:@"修图中－扶正..."];
            
            if (self.fuzhengImage) {
                ivyinying.image = self.fuzhengImage;
                self.image = self.fuzhengImage;
                [SVProgressHUD dismiss];
            }
            else
            {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 执⾏耗时的异步操作...
                    self.iplImage1 = [self convertToIplImage:[self fixOrientation:self.originalImage]];
                    IplImage *iplImageFuzheng = ALG_Centralize(self.iplImage1,2, 1, 1, 3, cv::Point(50,0), cv::Point(0,0),cv::Point(0,80),  cv::Point(60,80),10,0);
                    
                    self.fuzhengImage = [self convertToUIImage:iplImageFuzheng];
                    
                    NSLog(@"self.quyinyingImage%ld",(long)self.fuzhengImage.imageOrientation);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // 回到主线程,执⾏UI刷新操作
                        ivyinying.image = self.fuzhengImage;
                        self.image = self.fuzhengImage;
                        [SVProgressHUD dismiss];
                    });
                });
            }
            break;
        case 4:
            [SVProgressHUD showWithStatus:@"修图中－去波纹..."];
            
            if (self.qubowenImage) {
                ivyinying.image = self.qubowenImage;
                self.image = self.qubowenImage;
                [SVProgressHUD dismiss];
            }
            else
            {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 执⾏耗时的异步操作...
                    self.iplImage1 = [self convertToIplImage:[self fixOrientation:self.originalImage]];
                    self.iplImage1 = bilateral_auto(self.iplImage1,10);
                    
                    self.qubowenImage = [self convertToUIImage:self.iplImage1];
                    
                    NSLog(@"self.quyinyingImage%ld",(long)self.qubowenImage.imageOrientation);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // 回到主线程,执⾏UI刷新操作
                        ivyinying.image = self.qubowenImage;
                        self.image = self.qubowenImage;
                        [SVProgressHUD dismiss];
                    });
                });
            }
            break;
        case 5:
            [SVProgressHUD showImage:[UIImage imageNamed:@"推送.png"] status:@"暂不支持,敬请期待!"];
            ivyinying.image = self.originalImage;
            self.image = self.originalImage;
            break;
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
            break;
        case 102:
            NSLog(@"self.image.length%lu",(unsigned long)UIImageJPEGRepresentation(self.image, 0.3).length);
            [self.delegate saveImage:self.image byType:2];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
            break;
    }
}


-(void)removeAllSubViewsFromTopView
{
    for (UIView *subview in self.topView.subviews) {
        [subview removeFromSuperview];
    }
    self.backgroundIV = nil;
}

-(IplImage*)convertToIplImage:(UIImage*)image
{
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    IplImage *iplImage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
    CGContextRef contextRef = CGBitmapContextCreate(iplImage->imageData, iplImage->width, iplImage->height, iplImage->depth, iplImage->widthStep, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    IplImage *ret = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, ret, CV_RGB2BGR);
    cvReleaseImage(&iplImage);
    return ret;
}

-(UIImage*)convertToUIImage:(IplImage*)image
{
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

-(UIImage *)rotateImg:(UIImage *)img withDegree:(NSInteger)degree{
    img = [self fixOrientation:img];
    IplImage* ipimg = [self convertToIplImage:img];
    ipimg = Rotate_Imagecj(ipimg, (int)degree);
    return [self convertToUIImage:ipimg];
}

IplImage* Rotate_Imagecj(IplImage* img, int degree)
{
    double angle = degree  * CV_PI / 180.;
    double a = sin(angle), b = cos(angle);
    int width=img->width, height=img->height;
    
    int width_rotate= int(height * fabs(a) + width * fabs(b));
    int height_rotate=int(width * fabs(a) + height * fabs(b));
    IplImage* img_rotate = cvCreateImage(cvSize(width_rotate, height_rotate), img->depth, img->nChannels);
    cvZero(img_rotate);
    
    int tempLength = (int)(sqrt((double)width * width + (double)height *height) + 10);
    int tempX = (tempLength + 1) / 2 - width / 2;
    int tempY = (tempLength + 1) / 2 - height / 2;
    IplImage* temp = cvCreateImage(cvSize(tempLength, tempLength), img->depth, img->nChannels);
    cvZero(temp);
    
    cvSetImageROI(temp, cvRect(tempX, tempY, width, height));
    cvCopy(img, temp, NULL);
    cvResetImageROI(temp);
    
    float m[6];
    int w = temp->width;
    int h = temp->height;
    m[0] = (float)b;
    m[1] = (float)a;
    m[3] = -m[1];
    m[4] = m[0];
    
    m[2] = w * 0.5f;
    m[5] = h * 0.5f;
    CvMat M = cvMat(2, 3, CV_32F, m);
    cvGetQuadrangleSubPix(temp, img_rotate, &M);
    cvReleaseImage(&temp);
    
    return img_rotate;
    
}

//修正图片方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(UIImage*)splitImage:(UIImage*)img withX:(CGFloat)X withY:(CGFloat)Y withWidth:(CGFloat) withHeight
{
    return [UIImage imageNamed:@"启动页.jpg"];
}


//按比例截图
-(UIImage*)splitImage:(UIImage*)img{
    CGFloat width = img.size.width;
    CGFloat height = img.size.height;
    
    img = [self fixOrientation:img];
    //    IplImage* ipImg = Split_img([self convertToIplImage:img], ratio);
    IplImage* ipImg = Split_img([self convertToIplImage:img], 0,(height-width-width/7)/2,width,width);
    NSLog(@"%f",img.size.width);
    
    return [self convertToUIImage:ipImg];
}

IplImage * Split_img(IplImage * img ,int x,int y,int hei,int wid)
{
    
    IplImage* imgres= cvCreateImage(cvSize(wid,hei),img->depth,img->nChannels);
    CvScalar pix;
    int i=0,j=0;
    
    for( i = y;i<hei+y;i++)
    {
        for (j=x;j<wid+x;j++)
        {
            pix=cvGet2D(img,i,j);
            cvSet2D(imgres,i-y,j-x,pix);
            
        }
    }
    
    return imgres;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

//
//#import "XiutuVC.h"
//#import "ZZCPrivateClass.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"
//#import "plustest.h"
//
//
//
//@interface XiutuVC ()
//@property (nonatomic,strong)UIImageView *backgroundIV;
//@property (nonatomic,strong)UIImage *originalImage;
//@property (nonatomic,strong)UIImage *quyinyingImage;
//@property (nonatomic,strong)UIImage *fuzhengImage;
//@property (nonatomic,strong)UIImage *qubowenImage;
//@property (nonatomic,strong)UIImage *caijianImage;
//@property (nonatomic,strong)UIImage *image;
//@property (nonatomic,strong)UIImageView *iv;
//@property (nonatomic)IplImage *iplImage1;
//@property (nonatomic,strong)UIView *topView;
//@end
//
//@implementation XiutuVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.fd_prefersNavigationBarHidden = YES;
//    self.navigationController.navigationBarHidden = NO;
//    [self createUI];
//}
//
//-(void)createUI
//{
//    self.view.backgroundColor = [UIColor blackColor];
//    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/5*2-44)];
//    self.topView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:self.topView];
//    
//    //解析str获得图片
//    NSLog(@"Xiutu.filePath1%@",self.filePath);
//    self.filePath = [ZZCPrivateClass getFilePathByStr:self.filePath];
//    NSLog(@"Xiutu.filePath2%@",self.filePath);
//    
//
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:self.filePath];
//    NSLog(@"data,lenght%lu",(unsigned long)data.length);
//    self.originalImage = [UIImage imageWithData:data];
//    //背景图片控件
//    self.backgroundIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
//    self.backgroundIV.contentMode = UIViewContentModeScaleAspectFit;
//    self.backgroundIV.image = self.originalImage;
//    NSLog(@"朝上%ld",(long)self.originalImage.imageOrientation);
//    
//    NSLog(@"朝上？%ld",(long)self.originalImage.imageOrientation);
//
//    [self.topView addSubview:self.backgroundIV];
//    
//    //返回
//    UIButton *backView = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-SCREEN_WIDTH/5, SCREEN_WIDTH/7, SCREEN_WIDTH/7)];
//    [backView setBackgroundImage:[UIImage imageNamed:@"底栏-返回.png"] forState:UIControlStateNormal];
//    backView.tag = 101;
//    [backView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backView];
//    
//    //确定
//    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/7*3, SCREEN_HEIGHT-SCREEN_WIDTH/5, SCREEN_WIDTH/7, SCREEN_WIDTH/7)];
//    [confirm setBackgroundImage:[UIImage imageNamed:@"底栏-完成.png"] forState:UIControlStateNormal];
//    confirm.tag = 102;
//    [confirm addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confirm];
//    
//    
//    //修图按钮
//    //原图
//    UIButton *yuantu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/20, SCREEN_HEIGHT-SCREEN_WIDTH/5*2, SCREEN_WIDTH/10, SCREEN_WIDTH/10)];
//    [yuantu setBackgroundImage:[UIImage imageNamed:@"修图-原图.png"] forState:UIControlStateNormal];
//    yuantu.tag = 1;
//    [yuantu addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:yuantu];
//    
//    //修图按钮
//    //去阴影
//    UIButton *quyinying = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/20+SCREEN_WIDTH/10*2, SCREEN_HEIGHT-SCREEN_WIDTH/5*2, SCREEN_WIDTH/10, SCREEN_WIDTH/10)];
//    [quyinying setBackgroundImage:[UIImage imageNamed:@"修图-亮度.png"] forState:UIControlStateNormal];
//    quyinying.tag = 2;
//    [quyinying addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:quyinying];
//    
//    
//    //修图按钮
//    //扶正
//    UIButton *fuzheng = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/20+SCREEN_WIDTH/10*4, SCREEN_HEIGHT-SCREEN_WIDTH/5*2, SCREEN_WIDTH/10, SCREEN_WIDTH/10)];
//    [fuzheng setBackgroundImage:[UIImage imageNamed:@"修图-扶正.png"] forState:UIControlStateNormal];
//    fuzheng.tag = 3;
//    [fuzheng addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:fuzheng];
//    
//    
//    //修图按钮
//    //去波纹
//    UIButton *qubowen = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/20+SCREEN_WIDTH/10*6, SCREEN_HEIGHT-SCREEN_WIDTH/5*2, SCREEN_WIDTH/10, SCREEN_WIDTH/10)];
//    [qubowen setBackgroundImage:[UIImage imageNamed:@"修图-去波纹.png"] forState:UIControlStateNormal];
//    qubowen.tag = 4;
//    [qubowen addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:qubowen];
//    
//    
//    //修图按钮
//    //裁减
//    UIButton *caijian = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/20+SCREEN_WIDTH/10*8, SCREEN_HEIGHT-SCREEN_WIDTH/5*2, SCREEN_WIDTH/10, SCREEN_WIDTH/10)];
//    [caijian setBackgroundImage:[UIImage imageNamed:@"修图-裁剪.png"] forState:UIControlStateNormal];
//    caijian.tag = 5;
//    [caijian addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:caijian];
//    
//    //两条线
//    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH/5*2-20, SCREEN_WIDTH, 2)];
//    line1.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
//    [self.view addSubview:line1];
//    
//    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH/5-20, SCREEN_WIDTH, 2)];
//    line2.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
//    [self.view addSubview:line2];
//}
//
//-(void)btnClick:(UIButton *)sender
//{
//    [self removeAllSubViewsFromTopView];
//    UIImageView *ivyinying = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, SCREEN_WIDTH-20,SCREEN_WIDTH-20)];
//    ivyinying.contentMode = UIViewContentModeScaleAspectFit;
//    [self.topView addSubview:ivyinying];
//
//    NSLog(@"修图%ld!",(long)sender.tag);
//    switch (sender.tag) {
//        case 1:
//            [SVProgressHUD showWithStatus:@"原图..."];
//
//            ivyinying.image = self.originalImage;
//            self.image = self.originalImage;
//            NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
//
//            
//            [SVProgressHUD dismiss];
//            break;
//        case 2:
//            [SVProgressHUD showWithStatus:@"修图中－去阴影..."];
//
//            if (self.quyinyingImage) {
//                ivyinying.image = self.quyinyingImage;
//                self.image = self.quyinyingImage;
//                NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
//                [SVProgressHUD dismiss];
//            }
//            else
//            {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    // 执⾏耗时的异步操作...
//                    
//                    UIImage *imagetest = self.originalImage;
//                    NSLog(@"self.quyinyingImage%ld",(long)imagetest.imageOrientation);
//
//                    
//                    self.iplImage1 = [self convertToIplImage:[self fixOrientation:self.originalImage]];
//                    self.iplImage1 =yinying_auto_cj0515(self.iplImage1);
//                    
//                    self.quyinyingImage = [self convertToUIImage:self.iplImage1];
//                    
//                    NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
//                    
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // 回到主线程,执⾏UI刷新操作
//                        
//                        ivyinying.image = self.quyinyingImage;
//
//                        self.image = self.quyinyingImage;
//                        NSLog(@"self.quyinyingImage%ld",(long)self.quyinyingImage.imageOrientation);
//
//                        [SVProgressHUD dismiss];
//                    });
//                });
//            }
//            
//            break;
//        case 3:
//            [SVProgressHUD showWithStatus:@"修图中－扶正..."];
//
//            if (self.fuzhengImage) {
//                ivyinying.image = self.fuzhengImage;
//                self.image = self.fuzhengImage;
//                [SVProgressHUD dismiss];
//            }
//            else
//            {
//                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    // 执⾏耗时的异步操作...
//                    self.iplImage1 = [self convertToIplImage:[self fixOrientation:self.originalImage]];
//                    IplImage *iplImageFuzheng = ALG_Centralize(self.iplImage1,2, 1, 1, 3, cv::Point(50,0), cv::Point(0,0),cv::Point(0,80),  cv::Point(60,80),10,0);
//                    
//                    self.fuzhengImage = [self convertToUIImage:iplImageFuzheng];
//                    
//                    NSLog(@"self.quyinyingImage%ld",(long)self.fuzhengImage.imageOrientation);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        // 回到主线程,执⾏UI刷新操作
//                        ivyinying.image = self.fuzhengImage;
//                        self.image = self.fuzhengImage;
//                        [SVProgressHUD dismiss];
//                    });
//                });
//            }
//            break;
//        case 4:
//            [SVProgressHUD showWithStatus:@"修图中－去波纹..."];
//
//            if (self.qubowenImage) {
//                ivyinying.image = self.qubowenImage;
//                self.image = self.qubowenImage;
//                [SVProgressHUD dismiss];
//            }
//            else
//            {
//                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    // 执⾏耗时的异步操作...
//                    self.iplImage1 = [self convertToIplImage:[self fixOrientation:self.originalImage]];
//                    self.iplImage1 = bilateral_auto(self.iplImage1,10);
//                    
//                    self.qubowenImage = [self convertToUIImage:self.iplImage1];
//                    
//                    NSLog(@"self.quyinyingImage%ld",(long)self.qubowenImage.imageOrientation);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        // 回到主线程,执⾏UI刷新操作
//                        ivyinying.image = self.qubowenImage;
//                        self.image = self.qubowenImage;
//                        [SVProgressHUD dismiss];
//                    });
//                });
//            }
//            break;
//        case 5:
//                [SVProgressHUD showImage:[UIImage imageNamed:@"推送.png"] status:@"暂不支持,敬请期待!"];
//            ivyinying.image = self.originalImage;
//            self.image = self.originalImage;
//            break;
//        case 101:
//            [self.navigationController popViewControllerAnimated:YES];
//            [SVProgressHUD dismiss];
//            break;
//        case 102:
//            NSLog(@"self.image.length%lu",(unsigned long)UIImageJPEGRepresentation(self.image, 0.3).length);
//            [self.delegate saveImage:self.image byType:2];
//            [self.navigationController popViewControllerAnimated:YES];
//            [SVProgressHUD dismiss];
//            break;
//    }
//}
//
//
//-(void)removeAllSubViewsFromTopView
//{
//    for (UIView *subview in self.topView.subviews) {
//        [subview removeFromSuperview];
//    }
//    self.backgroundIV = nil;
//}
//
//-(IplImage*)convertToIplImage:(UIImage*)image
//{
//    CGImageRef imageRef = image.CGImage;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    IplImage *iplImage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
//    CGContextRef contextRef = CGBitmapContextCreate(iplImage->imageData, iplImage->width, iplImage->height, iplImage->depth, iplImage->widthStep, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
//    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
//    CGContextRelease(contextRef);
//    CGColorSpaceRelease(colorSpace);
//    IplImage *ret = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
//    cvCvtColor(iplImage, ret, CV_RGB2BGR);
//    cvReleaseImage(&iplImage);
//    return ret;
//}
//
//-(UIImage*)convertToUIImage:(IplImage*)image
//{
//    cvCvtColor(image, image, CV_BGR2RGB);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
//    CGImageRef imageRef = CGImageCreate(image->width, image->height, image->depth, image->depth * image->nChannels, image->widthStep, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
//    UIImage *ret = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    CGDataProviderRelease(provider);
//    CGColorSpaceRelease(colorSpace);
//    return ret;
//}
//
//-(UIImage *)rotateImg:(UIImage *)img withDegree:(NSInteger)degree{
//    img = [self fixOrientation:img];
//    IplImage* ipimg = [self convertToIplImage:img];
//    ipimg = Rotate_Imagecj(ipimg, (int)degree);
//    return [self convertToUIImage:ipimg];
//}
//
//IplImage* Rotate_Imagecj(IplImage* img, int degree)
//{
//    double angle = degree  * CV_PI / 180.;
//    double a = sin(angle), b = cos(angle);
//    int width=img->width, height=img->height;
//    
//    int width_rotate= int(height * fabs(a) + width * fabs(b));
//    int height_rotate=int(width * fabs(a) + height * fabs(b));
//    IplImage* img_rotate = cvCreateImage(cvSize(width_rotate, height_rotate), img->depth, img->nChannels);
//    cvZero(img_rotate);
//    
//    int tempLength = (int)(sqrt((double)width * width + (double)height *height) + 10);
//    int tempX = (tempLength + 1) / 2 - width / 2;
//    int tempY = (tempLength + 1) / 2 - height / 2;
//    IplImage* temp = cvCreateImage(cvSize(tempLength, tempLength), img->depth, img->nChannels);
//    cvZero(temp);
//    
//    cvSetImageROI(temp, cvRect(tempX, tempY, width, height));
//    cvCopy(img, temp, NULL);
//    cvResetImageROI(temp);
//    
//    float m[6];
//    int w = temp->width;
//    int h = temp->height;
//    m[0] = (float)b;
//    m[1] = (float)a;
//    m[3] = -m[1];
//    m[4] = m[0];
//    
//    m[2] = w * 0.5f;
//    m[5] = h * 0.5f;
//    CvMat M = cvMat(2, 3, CV_32F, m);
//    cvGetQuadrangleSubPix(temp, img_rotate, &M);
//    cvReleaseImage(&temp);
//    
//    return img_rotate;
//    
//}
//
////修正图片方向
//- (UIImage *)fixOrientation:(UIImage *)aImage {
//    
//    // No-op if the orientation is already correct
//    if (aImage.imageOrientation == UIImageOrientationUp)
//        return aImage;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        default:
//            break;
//    }
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        default:
//            break;
//    }
//    
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
//                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
//                                             CGImageGetColorSpace(aImage.CGImage),
//                                             CGImageGetBitmapInfo(aImage.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}
//
//-(UIImage*)splitImage:(UIImage*)img withX:(CGFloat)X withY:(CGFloat)Y withWidth:(CGFloat) withHeight
//{
//    return [UIImage imageNamed:@"启动页.jpg"];
//}
//
////按比例截图
//-(UIImage*)splitImage:(UIImage*)img{
//    CGFloat width = img.size.width;
//    CGFloat height = img.size.height;
//    
//    img = [self fixOrientation:img];
////    IplImage* ipImg = Split_img([self convertToIplImage:img], ratio);
//    IplImage* ipImg = Split_img([self convertToIplImage:img], 0,(height-width-width/7)/2,width,width);
//    NSLog(@"%f",img.size.width);
//
//    return [self convertToUIImage:ipImg];
//}
//
//IplImage * Split_img(IplImage * img ,int x,int y,int hei,int wid)
//{
//    
//    IplImage* imgres= cvCreateImage(cvSize(wid,hei),img->depth,img->nChannels);
//    CvScalar pix;
//    int i=0,j=0;
//    
//    for( i = y;i<hei+y;i++)
//    {
//        for (j=x;j<wid+x;j++)
//        {
//            pix=cvGet2D(img,i,j);
//            cvSet2D(imgres,i-y,j-x,pix);
//            
//        }
//    }
//    
//    return imgres;
//}
//
//
//@end


