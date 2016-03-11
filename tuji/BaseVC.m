
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE5 self.view.bounds.size.width <= 375
#define PURPLE [UIColor colorWithRed:163/255.0 green:138/255.0 blue:119/255.0 alpha:1]


#import "BaseVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMotion/CoreMotion.h>
#import "AuthorizeVC.h"
#import "XiutuVC.h"
@interface BaseVC ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    AVCaptureDevice *captureDevice;
    
    UIImage* capImage;
    UIImageView* backgroundView;
    
    //重力感应判断图片方向
    CMMotionManager* manager;
    NSInteger imageOrientation;
    NSTimer* myTimer;
    
    UIView* blingView;
    
    //控制闪光灯的三个按钮
    UIButton* button0;
    UIButton* button1;
    UIButton* button2;
    
    
    AuthorizeVC* authorVC;
    
    NSString* startTime;
    NSString* endTime;
}
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (strong, nonatomic) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic, strong)AVCaptureStillImageOutput* stillImageOutput;
@property (strong, nonatomic) UIView *viewPreview;//扫描窗口
@property (nonatomic,strong)AVCaptureConnection * videoConnection;
@property (nonatomic,strong)XiutuVC *xiutu;
@end

@implementation BaseVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏时间，信号，运营商
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    self.navigationController.navigationBarHidden = YES;
    manager = [[CMMotionManager alloc]init];
    manager.accelerometerUpdateInterval = 1.0/60.0;
    [manager startAccelerometerUpdates];
    
    imageOrientation = 0;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(judgeOrientation) userInfo:nil repeats:YES];
    
    [self initUI];
    
}
//判断手机方向
-(void)judgeOrientation{
   CGFloat x = manager.accelerometerData.acceleration.x;
   CGFloat y = manager.accelerometerData.acceleration.y;
   //CGFloat z = manager.accelerometerData.acceleration.z;
    if ((x>=-0.5&&x<=0.5) && (y>=-1&&y<=-0.5)) {
        imageOrientation = 0;
    }else if ((x>=-1.0&&x<-0.5) && (y>=-0.5&&y<=0.5)){
        imageOrientation = -1;
    }else if((x>0.5&&x<=1) && (y>=-0.5&&y<=0.5)){
        imageOrientation = 1;
    }else{
        imageOrientation = 0;
    }
  //  NSLog(@"x:%f,y:%f,orient:%d",x,y,imageOrientation);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     CaptureSession 这是个捕获会话，也就是说你可以用这个对象从输入设备捕获数据流。
     AVCaptureVideoPreviewLayer 可以通过输出设备展示被捕获的数据流。
     首先，应该判断当前设备是否有捕获数据流的设备。
     */
    NSError *error;
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    }else{
        //设置会话的输入设备
        if (!_captureSession) {
            _captureSession = [[AVCaptureSession alloc] init];
        }
        [_captureSession addInput:input];
        
        //对应输出
        if (!_captureMetadataOutput) {
            _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        }
        [_captureSession addOutput:_captureMetadataOutput];
        if (!_stillImageOutput) {
            self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        }
        [_captureSession addOutput:_stillImageOutput];
        //创建一个队列
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("myQueue",NULL);
        [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [_captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];//设置条码类型。
        
        //降捕获的数据流展现出来
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        if (!_viewPreview) {
            
                _viewPreview = [[UIView alloc]initWithFrame:self.view.frame];
            
            [self.view addSubview:_viewPreview];
        }
        
        [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
        [_viewPreview.layer addSublayer:_videoPreviewLayer];
        
        //开始捕获
        [_captureSession startRunning];
    }
    
}

//获得的数据在 AVCaptureMetadataOutputObjectsDelegate 唯一定义的方法中
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //判断是否有数据，是否是二维码数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"二维码扫描到的结果：%@",metadataObj.stringValue);
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            if ([metadataObj.stringValue rangeOfString:@"8868b9888f3ee783e11128b2581a9849"].length) {
                
                authorVC = [[AuthorizeVC alloc]init];
                authorVC.result = metadataObj.stringValue;
                //获得扫描的数据，并结束扫描
                [self performSelectorOnMainThread:@selector(stopReading:)withObject:metadataObj.stringValue waitUntilDone:YES];
            }
        }
    }
}

- (void)stopReading:(id)sender{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
    [self.navigationController pushViewController:authorVC animated:YES];
}


-(void)initUI{
    CGFloat btnBckViewHight = WIDTH/7;
    
    UIView *topBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, (HEIGHT-WIDTH-btnBckViewHight)/2)];
    topBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topBackGroundView];
    
    UIView *bottomBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, (HEIGHT-WIDTH-btnBckViewHight)/2+WIDTH, WIDTH, (HEIGHT-WIDTH-btnBckViewHight)/2)];
    bottomBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomBackGroundView];
    
    
    //背景栏
    
    if (IPHONE5) {
        backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,HEIGHT-btnBckViewHight , WIDTH, btnBckViewHight)];
    }else{
        backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,HEIGHT-btnBckViewHight , WIDTH, btnBckViewHight)];
    }
    

    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"底栏-返回.png"];
    [backBtn setImage: backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(WIDTH/7,HEIGHT-WIDTH/7, WIDTH/7, WIDTH/7)];
    [self.view addSubview:backBtn];
    //拍照按钮
    UIImage *camerImage = [UIImage imageNamed:@"底栏-相机.png"];
    UIButton *cameraBtn = [[UIButton alloc] initWithFrame:
                           CGRectMake(WIDTH/7*3,HEIGHT-WIDTH/7, WIDTH/7, WIDTH/7)];
    [cameraBtn setImage:camerImage forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    //相册
    UIImage *photoImage = [UIImage imageNamed:@"底栏-本地相册.png"];
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/7*5,HEIGHT-WIDTH/7, WIDTH/7, WIDTH/7)];

    [photoBtn setImage:photoImage forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(takeAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    
    //闪光灯图片
    UIImageView* blImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 13, 20)];
    blImage.image = [UIImage imageNamed:@"bling.png"];
    [self.view addSubview:blImage];
    
    //闪光灯按钮
    button0 = [UIButton buttonWithType:UIButtonTypeSystem];
    button0.frame = CGRectMake(33, 20, 30, 30);
    [button0 addTarget:self action:@selector(setBling:) forControlEvents:UIControlEventTouchUpInside];
    [button0 setTitle:@"自动" forState:UIControlStateNormal];
    [button0 setTitleColor:PURPLE forState:UIControlStateNormal];
    [self.view addSubview:button0];
    
//    [self autoF];
    
}

//取消
-(void)closeView{
    [self.navigationController popViewControllerAnimated:YES];
}

//拍照
- (void)shutterCamera
{
    self.videoConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!self.videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:self.videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage* image = [UIImage imageWithData:imageData];
        NSLog(@"1baseVCimage:%ld,,,imageOrientation%ld",(long)image.imageOrientation,(long)imageOrientation);
        
        
        
        
        [manager stopAccelerometerUpdates];
        [myTimer invalidate];


        self.xiutu = [[XiutuVC alloc] init];
        image = [self.xiutu splitImage:image];
//        image = [xiutu scaleImage:image toScale:.5];
        [self setCaptureMetadataOutput:nil];
        [self setCaptureSession:nil];
        [self setVideoPreviewLayer:nil];
        [self setStillImageOutput:nil];
        [self setViewPreview:nil];
        [self setVideoConnection:nil];
        [self setXiutu:nil];
        imageData = nil;
        [self.delegate saveImage:image byType:1];
        
        image = nil;
        NSLog(@"2baseVCimage.imageOrientation:%ld",(long)image.imageOrientation);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
//打开相册
-(void)takeAlbum{
    [manager stopAccelerometerUpdates];
    [myTimer invalidate];
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        imagePicker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*)kUTTypeImage, nil];
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//选图后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image;
        if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    [self.navigationController popViewControllerAnimated:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self.delegate saveImage:image byType:1];
        }];
   
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//设置闪光灯
-(void)setBling:(UIButton*)sender{

    if ([blingView superview] == self.view) {
        [blingView removeFromSuperview];
    }else if (blingView == nil){
        //创建选择板
        blingView = [[UIView alloc]initWithFrame:CGRectMake(33, 50, 30, 90)];
        
        button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        button1.frame = CGRectMake(0, 0, 30, 30);
        [button1 setTitleColor:PURPLE forState:UIControlStateNormal];
        [button1 setTitle:@"打开" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(seleteBling:) forControlEvents:UIControlEventTouchUpInside];
        [blingView addSubview:button1];
        
        button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        button2.frame = CGRectMake(0, 30, 30, 30);
        [button2 setTitleColor:PURPLE forState:UIControlStateNormal];
        [button2 setTitle:@"关闭" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(seleteBling:) forControlEvents:UIControlEventTouchUpInside];
        [blingView addSubview:button2];
        
        [self.view addSubview:blingView];

    }else{
        [self.view addSubview:blingView];
    }

}
-(void)seleteBling:(UIButton*)sender{
    
    [blingView removeFromSuperview];
    NSString* temp = button0.titleLabel.text;
    
    if ([sender.titleLabel.text isEqualToString:@"自动"]) {
        [self autoF];
        [button0 setTitle:@"自动" forState:UIControlStateNormal];
        [sender setTitle:temp forState:UIControlStateNormal];
    }else if ([sender.titleLabel.text isEqualToString:@"打开"]){
        [self open];
        [button0 setTitle:@"打开" forState:UIControlStateNormal];
        [sender setTitle:temp forState:UIControlStateNormal];
        
    }else if ([sender.titleLabel.text isEqualToString:@"关闭"]){
        [self close];
        [button0 setTitle:@"关闭" forState:UIControlStateNormal];
        [sender setTitle:temp forState:UIControlStateNormal];
    }
    
}

/**
 *  开启闪光灯
 */
-(void)open{
    AVCaptureDevice* d = nil;
    
    NSArray* allDevices = [AVCaptureDevice devices];
    for (AVCaptureDevice* currentDevice in allDevices) {
        if (currentDevice.position == AVCaptureDevicePositionBack) {
            d = currentDevice;
        }
    }
    
    NSError* err = nil;
    BOOL lockAcquired = [d lockForConfiguration:&err];
    
    if (!lockAcquired) {
    } else {
        if ([d hasFlash] && [d isFlashModeSupported:AVCaptureFlashModeOn] ) {
            [d setFlashMode:AVCaptureFlashModeOn];
        }
        
        [d unlockForConfiguration];
    }
}

/**
 *  关闭闪光灯
 */
-(void)close{
    AVCaptureDevice* d = nil;
    
    NSArray* allDevices = [AVCaptureDevice devices];
    for (AVCaptureDevice* currentDevice in allDevices) {
        if (currentDevice.position == AVCaptureDevicePositionBack) {
            d = currentDevice;
        }
    }
    
    NSError* err = nil;
    BOOL lockAcquired = [d lockForConfiguration:&err];
    
    if (!lockAcquired) {
    } else {
        if ([d hasFlash] && [d isFlashModeSupported:AVCaptureFlashModeOff] ) {
            [d setFlashMode:AVCaptureFlashModeOff];
        }
        
        [d unlockForConfiguration];
    }
}

/**
 *  自动闪光灯
 */
-(void)autoF{
    AVCaptureDevice* d = nil;
    
    NSArray* allDevices = [AVCaptureDevice devices];
    for (AVCaptureDevice* currentDevice in allDevices) {
        if (currentDevice.position == AVCaptureDevicePositionBack) {
            d = currentDevice;
        }
    }
    
    NSError* err = nil;
    BOOL lockAcquired = [d lockForConfiguration:&err];
    
    if (!lockAcquired) {
    } else {
        if ([d hasFlash] && [d isFlashModeSupported:AVCaptureFlashModeAuto] ) {
            [d setFlashMode:AVCaptureFlashModeAuto];
        }
        [d unlockForConfiguration];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
@end