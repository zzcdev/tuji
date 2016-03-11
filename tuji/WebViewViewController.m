
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZZCPrivateClass.h"
#import "RegexKitLite.h"
#import "WebViewViewController.h"
#import "WebViewRightView.h"
#import "XiutuVC.h"
#import "BaseVC.h"
#import "UserLoginLogic.h"
#import "DrawBoardView.h"
#import "ShareToView.h"

#import "WebViewSupport.h"

//友盟sdk
#import "UMSocial.h"
//导入录音类
#import "Recorder.h"
#import "CustomWebViewProtocol.h"
#import "ASProgressPopUpView.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
@interface WebViewViewController ()<shareToSNS,UMSocialUIDelegate,CustomWebViewProtocol,UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIScrollViewDelegate>

//editlist集合datalist页面加载获取得到的list
@property (nonatomic,strong)NSMutableArray *editFilesList;

//saveList集合点击保存或者发表时得到的list
@property (nonatomic,strong)NSMutableArray *saveFilesList;



/**
 *  右边栏弹出时加载的左边透明边栏，用于点击后右边栏回收事件
 */
@property (nonatomic,strong)UIView *customView;

@property (nonatomic,strong)MPMoviePlayerController *moviePlayer;

/**
 *  自定义webview右边栏
 */
@property (nonatomic,strong)WebViewRightView *webRight;

/**
 *  自定义webview
 */
@property (nonatomic,strong)CustomWebView *customWebView;

/**
 *  自定义录音类
 */
@property (nonatomic,strong)Recorder *recoderManager;

/**
 *  笔记提醒 下册弹出选择日期
 */
@property (nonatomic,strong)UIDatePicker *noticePicker;
@property (nonatomic,strong)UIButton *saveNoticeBtn;

/**
 *  图片选择，拍照，录像控制器
 */
@property (nonatomic,strong)UIImagePickerController *picker;

/**
 *  是否是录像
 */
@property (nonatomic,assign)NSInteger isVideo;

/**
 *  自定义分享面板
 */
@property (nonatomic,strong)ShareToView *SVC;

/**
 *  加载时间计时器，超时即刷新页面重新加载
 */
@property (nonatomic,strong)NSTimer *refreshPageTimer;

/**
 *  是否是第一次加载页面
 */
@property (nonatomic)BOOL isFirstLoadPage;
/**
 *  video播放层
 */
@property (strong, nonatomic)UIImageView *photo;//照片展示视图

/**
 *  播放器，用于录制完视频后播放视频
 */
@property (strong ,nonatomic) AVPlayer *player;

/**
 *  视频录制的时长
 */
@property (nonatomic,copy)NSString *videoLength;

/**
 *  获取到的链接
 */
@property (nonatomic,copy)NSString *webviewString;

@property (nonatomic,copy)NSString *webviewString1;
/**
 *  导航栏标题
 */
@property (nonatomic,strong) UILabel *labelTitle;

/**
 *  文件管理器
 */
@property (nonatomic,strong)NSFileManager *fileManager;

/**
 *  顶部导航栏
 */
@property (nonatomic,strong)UIView *topView;

/**
 *  是否正在录音
 */
@property (nonatomic)BOOL isRecording;

@property (nonatomic,strong)AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong)AVAudioPlayer   *audioPlayer;  //音频播放器，用于播放录音文件

/**
 *  NSUserDefault
 */
@property (nonatomic,strong)NSUserDefaults *userDF;

/**
 *  当次传入的控件id
 */
@property (nonatomic,strong)NSString *fileGuid;

/**
 *  文件上传是否结束
 */
@property (nonatomic)BOOL uploadFileIsEnd;

/**
 *  文件上传的流是否是第一段，刚开始
 */
@property (nonatomic)BOOL uploadFileIsFirst;

/**
 *  上传文件类型（0上传编辑页，1上传用户头像,2上传发表）
 */
@property (nonatomic,assign)NSInteger uploadState;

/**
 *  文件上传的文件名
 */
@property (nonatomic,copy)NSString *uploadFileName;

/**
 *  文件上传的二进制流
 */
@property (nonatomic,strong)NSData *uploadFileData;

/**
 *  文件上传的当前段数
 */
@property (nonatomic,assign)NSUInteger fileCurrentIndex;

/**
 *  文件流每次上传的大小
 */
@property (nonatomic,assign)NSUInteger fileLength;

/**
 *  上传文件的进度条
 */
@property (nonatomic,strong)ASProgressPopUpView *progressView;

/**
 *  上传文件的总进度条
 */
@property (nonatomic,strong)ASProgressPopUpView *allFilePV;

/**
 *  上传进度条背景
 */
@property (nonatomic,strong)UIView *uploadFileBackView;

/**
 *  上传文件的总数量
 */
@property (nonatomic,assign)NSUInteger uploadFileCount;

/**
 *  当前是第几个文件正在上传
 */
@property (nonatomic,assign)NSUInteger uploadCurrentFileNum;

/**
 *  上传文件失败时继续提交上传，超过次数停止上传（5次）
 */
@property (nonatomic,assign)NSUInteger uploadFaildTimes;

/**
 *  进度条标签
 */
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;

@property (nonatomic,strong)UIView *drawBoardBackView;
@property (nonatomic,strong)UIButton *drawSaveBtn;
@property (nonatomic,strong)DrawBoardView *drawVC;


@property (nonatomic,strong)NSMutableArray *sendMailFiles;
@property (nonatomic,strong)NSMutableArray *MailSrcs;
@property (nonatomic,strong)NSMutableArray *MailMsgs;
@property (nonatomic,strong)NSString *MailTitle;
@end

@implementation WebViewViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInfo = [UserInfo sharedUserInfo];
        if (!self.userInfo.fileList)
        {
            self.userInfo.fileList = [NSMutableDictionary dictionary];
            self.userInfo.httpList = [NSMutableDictionary dictionary];
        }
        self.userDF = [NSUserDefaults standardUserDefaults];
        self.uploadFileCount = 0;
        self.uploadCurrentFileNum = 0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationAction:) name:PUSH_MESSAGE_NOTIFICATION object:nil];
    
}

//-(void)pushNotificationAction:(NSNotification *)notification
//{   
//    UIView *pushView = [[UIView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, 44)];
//    [self.view addSubview:pushView];
//    [UIView animateWithDuration:.5 animations:^{
//        pushView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:.5 animations:^{
//            pushView.frame = CGRectMake(0, -44, SCREEN_WIDTH, 44);
//        } completion:^(BOOL finished) {
//            [pushView removeFromSuperview];
//            NSLog(@"获得到推送信息：%@",notification.userInfo);
//        }];
//    }];
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [value CGRectValue]; // 这里得到了键盘的frame
    // 你的操作，如键盘出现，控制视图上移等
//    if ([self.webviewString1 rangeOfString:@"app"].length) {
//        [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
//        self.webviewString1 = @"";
//    }else
//    {
//        self.customWebView.frame = CGRectMake(0, -290, SCREEN_WIDTH, SCREEN_HEIGHT);
//    }
    if ([self.webviewString1 rangeOfString:@"app"].length) {
        
        [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
        self.webviewString1 = @"";
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // 获取info同上面的方法
    // 你的操作，如键盘移除，控制视图还原等
//    self.customWebView.frame = [UIScreen mainScreen].bounds;
}

-(void)keyboardDidHide:(NSNotification *)notification{
//    self.customWebView.frame = [UIScreen mainScreen].bounds;
}

/**
 *  视图已经显示时
 */
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.customWebView resignFirstResponder];
    //隐藏导航栏
    self.navigationController.navigationBarHidden  = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    //禁止滑动返回上一页面
    self.fd_interactivePopDisabled = YES;
}

#pragma mark 创建顶部导航栏
-(void)createNAVI
{
    [self.customWebView resignFirstResponder];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 69)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 20, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"编辑页-返回.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(webviewBack) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:leftBtn];
    
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 30, 30, 25)];
    [rightBtn setImage:[UIImage imageNamed:@"右边栏.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(createRightView) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:rightBtn];
    
    //初始化导航栏标题
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREEN_WIDTH-200, 44)];
    self.labelTitle.font = [UIFont systemFontOfSize:20];
    
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    //    self.labelTitle.textColor = [UIColor blackColor];
    [self.topView addSubview:self.labelTitle];
    
    UILabel *labelBtw = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 1)];
    labelBtw.backgroundColor  = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    [self.topView addSubview:labelBtw];
}

#pragma mark  绘制UI
-(void)createUI
{
    UIView *webviewBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webviewBackView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:webviewBackView];
    //创建用户专有文件夹
    self.fileManager = [NSFileManager defaultManager];
    NSString *userFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.userInfo.userId];
    [self.userDF setObject:self.userInfo.userId forKey:@"userID"];
    [self.userDF setObject:self.userInfo.userToken forKey:@"access_token"];
    [self.userDF setObject:userFilePath forKey:@"userFilePath"];
    [self.userDF synchronize];
    [ZZCPrivateClass createUserFileByName:nil andData:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //初始化自定义webview 设置代理
    self.customWebView = [[CustomWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.customWebView.delegate = self;
    //    [self.view addSubview:self.customWebView];
    
    [self.view addSubview:self.customWebView];
    
    self.customWebView.scrollView.bounces = NO;
    self.customWebView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
    self.customWebView.scrollView.delegate = self; // 注册代理， step 2

    
    //登陆成功后直接进入编辑页，地址
    NSURL *url ;
    //    if (self.userInfo.webViewUrl == 0) {
    //        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@TuJiApp/edit.html",[ZZCPrivateClass getServersUrl]]];
    //    }else if (self.userInfo.webViewUrl == 1){
    //        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@TuJiApp/myfriend.html",[ZZCPrivateClass getServersUrl]]];
    //    }else if (self.userInfo.webViewUrl == 2){
    //        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@TuJiApp/otherPage.html",[ZZCPrivateClass getServersUrl]]];
    //    }
    NSLog(@"%@",self.userInfo.webViewUrl);
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ZZCPrivateClass getServersUrl],self.userInfo.webViewUrl]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"%@",url);
    
    [self.customWebView loadRequest:request];
    [self.customWebView setScalesPageToFit:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{ // 实现代理方法， step 3
    return nil;
}

#pragma mark 导航栏左侧返回按钮返回webview上一个链接地址
-(void)webviewBack
{
    if ([self.customWebView canGoBack]) {
        
        [self.customWebView goBack];
    }
}

#pragma mark 友盟分享完成后调用成功/失败
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"友盟第三方分享完成啦！");
    }
}

#pragma mark 创建webView右侧边栏
-(void)createRightView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.748, SCREEN_HEIGHT)];
    self.customView.backgroundColor = [UIColor whiteColor];
    self.customView.alpha = .1;
    
    //添加屏幕点击事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeRightView)];
    
    [self.customView addGestureRecognizer:tapGes];
    
    [self.view addSubview:self.customView];
    self.webRight = [[WebViewRightView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-100, SCREEN_HEIGHT)];
    self.webRight.delegate = self;
    [self.view addSubview:self.webRight];
    [UIView animateWithDuration:0.3 animations:^{
        self.webRight.frame = CGRectMake(100, 0, SCREEN_WIDTH-100, SCREEN_HEIGHT);
    }];
}

#pragma mark 移除右边栏
-(void)removeRightView
{
    if (self.webRight) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.webRight.frame = CGRectMake(self.view.frame.size.width, 0, SCREEN_WIDTH-100, SCREEN_HEIGHT);
            
            self.customView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.webRight removeFromSuperview];
            [self.customView removeFromSuperview];
        }];
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
    
    if (self.recoderManager) {
        [self.recoderManager recorderStopPlaying];
        self.recoderManager = nil;
    }
    self.isFirstLoadPage = NO;
    if (self.refreshPageTimer == NULL) {
        self.refreshPageTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(refreshPage) userInfo:nil repeats:YES];
        [self.refreshPageTimer fire];
    }
}



#pragma mark 开始加载截取链接判断
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *str = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.webviewString = str;
    self.webviewString1 = str;
    NSLog(@"获得链接%@",str);
    
    if ([str rangeOfString:@"app"].length) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    
    //|| [str rangeOfString:@"/taskDetails.html"].length || [str rangeOfString:@"/search.html"].length|| [str rangeOfString:@"/to_friend.html"].length|| [str rangeOfString:@"/personal.html"].length|| [str rangeOfString:@"/addfriend.html"].length || [str rangeOfString:@"/addfriend_son.html"].length|| [str rangeOfString:@"/record.html"].length
    if([str rangeOfString:@"/edit.html"].length || [str rangeOfString:@"/newTaskEdit.html"].length )
    {
        if (self.topView) {
            
            [self.topView removeFromSuperview];
            self.topView = nil;
            self.customWebView.frame = [UIScreen mainScreen].bounds;
        }
        
    }
    else if([str hasPrefix:@"http://"])
    {
        if (!self.topView) {
            [self createNAVI];
            webView.frame = CGRectMake(0, 49, SCREEN_WIDTH, SCREEN_HEIGHT-49);
        }
    }
    
    
    if ([str hasPrefix:@"app://camera"])
    {
        
#pragma mark webview 捕获  拍照  链接
        BaseVC *cameraVC = [[BaseVC alloc] init];
        cameraVC.delegate = self;
        [self.navigationController pushViewController:cameraVC animated:YES];
    }
    else if ([str hasPrefix:@"app://edit_img"])
    {
        
#pragma mark webview 捕获  修图  链接
        XiutuVC *xiutu = [[XiutuVC alloc] init];
        xiutu.filePath = str;
        xiutu.delegate = self;
        
        NSLog(@"sandbox:%d",[self SandBoxFileExit:str]);
        
        if ([self SandBoxFileExit:str]) {
            
            [self.navigationController pushViewController:xiutu animated:YES];
        }
        else
        {
            [self downLoadFile:str];
            
        }
    }
    else if ([str isEqualToString:@"app://record_video"])
    {
#pragma mark webview 捕获  录像  链接
        //点击录像按钮
        self.isVideo = 1;
        [self setPicker];
    }
    else if ([str hasPrefix:@"app://play_video"])
    {
#pragma mark webview 捕获 播放录像  链接
        NSLog(@"sandbox:%d",[self SandBoxFileExit:str]);
        
        if ([self SandBoxFileExit:str]) {
            
            [self videoPlayClick:str];
        }
        else
        {
            [self downLoadFile:str];
        }
        
    }
    else if ([str hasPrefix:@"app://record_voice_start"])
    {
        
#pragma mark webview 捕获  开始录音  链接
        //点击开始录音按钮
        if (!self.recoderManager) {
            self.recoderManager  = [[Recorder alloc] init];
        }
        [self.recoderManager recorderStarSavePath];
        self.recoderManager.delegate = self;
        self.isRecording = YES;
        
        //        [self recorderStarSavePath];
        //        self.isRecording = YES;
    }
    else if ([str hasPrefix:@"app://record_voice_stop"])
    {
#pragma mark webview 捕获  结束录音  链接
        
        //点击停止录音按钮
        if (self.isRecording) {
            [self.recoderManager recorderStop];
            
            self.isRecording = NO;
        }
        
        //        if (self.isRecording) {
        //            [self recorderStop];
        //
        //            self.isRecording = NO;
        //        }
    }
    else if ([str hasPrefix:@"app://play_voice"])
    {
        if (!self.recoderManager) {
            self.recoderManager  = [[Recorder alloc] init];
        }
        
        
        
#pragma mark webview 捕获  播放录音  链接
        
        NSLog(@"sandbox:%d",[self SandBoxFileExit:str]);
        if ([self SandBoxFileExit:str]) {
            
            if (self.isRecording) {
                [self.recoderManager recorderStop];
            }
            NSString *filePath = [ZZCPrivateClass getFilePathByStr:str];
            
            
            //播放动画
            NSString *fileUrl = [[str componentsSeparatedByString:@"?id="] lastObject];
            fileUrl = [[fileUrl componentsSeparatedByString:@"&"] firstObject];
            NSString *js = [NSString stringWithFormat:@"if_edit.playAudio('%@')",fileUrl];
            [self.customWebView stringByEvaluatingJavaScriptFromString:js];

            
            
            
            [self.recoderManager playRecorderWithUrl:filePath];
//            NSString *fileUrl = [[str componentsSeparatedByString:@"?id="] lastObject];
//            fileUrl = [[fileUrl componentsSeparatedByString:@"&"] firstObject];
//            NSString *js = [NSString stringWithFormat:@"if_edit.playAudio('%@')",fileUrl];
//            [self.customWebView stringByEvaluatingJavaScriptFromString:js];
            self.isRecording = NO;
//js	__NSCFString *	@"if_edit.playAudio('aud_EA4A45DB_62C2_4927_B337_4CBC420600CC')"	0x14d1fac0
        }
        else
        {
            [self downLoadFile:str];
        }
    }
    else if ([str hasPrefix:@"app://pause_voice"])
    {
#pragma mark webview 捕获  暂停播放录音  链接
        [self.recoderManager recorderPause];
        self.isRecording = NO;
    }
    else if ([str hasPrefix:@"app://goon_voice"])
    {
#pragma mark webview 捕获  继续播放录音 链接
        [self.recoderManager recorderGoonPlaying];
    }
    else if ([str hasPrefix:@"app://stop_voice"])
    {
#pragma  mark webview 捕获  停止播放录音  链接
        [self.recoderManager recorderStopPlaying];
    }
    else if ([str isEqualToString:@"app://record_write"])
    {
#pragma mark webview 捕获  画板  链接
        //点击底栏原笔迹按钮：
        self.drawVC = [[DrawBoardView alloc] initWithFrame:CGRectMake(15, 100, SCREEN_WIDTH-30, SCREEN_HEIGHT-170)];
        self.drawVC.delegate = self;
        self.customWebView.userInteractionEnabled = NO;
        self.drawBoardBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.drawBoardBackView.backgroundColor = [UIColor blackColor];
        self.drawBoardBackView.alpha = .6;
        [self.view addSubview:self.drawBoardBackView];
//        [self createBackGroundView];
        
        self.drawSaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 65, 30, 30)];
        [self.drawSaveBtn setImage:[UIImage imageNamed:@"删除1.png"] forState:UIControlStateNormal];
        [self.drawSaveBtn addTarget:self.drawVC action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.drawBoardBackView addSubview:self.drawSaveBtn];
        
        [self.view addSubview:self.drawVC];
    }
    else if ([str isEqualToString:@"app://notice"])
    {
        [self createBackGroundView];
#pragma mark webview 捕获  提醒花瓣  链接
        //点击花瓣提醒
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-DD HH:mm"];
        
        self.noticePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT, SCREEN_WIDTH-40, 216)];
        self.noticePicker.alpha = 0.95;
        self.noticePicker.layer.cornerRadius = 10;
        self.noticePicker.layer.borderWidth = 2;
        self.noticePicker.layer.borderColor = [[UIColor grayColor] CGColor];
        self.noticePicker.clipsToBounds = YES;
        
        self.saveNoticeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT, SCREEN_WIDTH-40, 50)];
        [self.saveNoticeBtn setTitle:@"保存提醒" forState:UIControlStateNormal];
        [self.saveNoticeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.saveNoticeBtn addTarget:self action:@selector(saveDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.saveNoticeBtn setBackgroundColor: [UIColor whiteColor]];
        self.saveNoticeBtn.alpha = 0.95;
        self.saveNoticeBtn.layer.cornerRadius = 10;
        [self.view addSubview:self.saveNoticeBtn];
        
        self.noticePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        self.noticePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"];
        [self.noticePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        
        
        NSDate *date = [NSDate date];
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        
        NSInteger interval = [zone secondsFromGMTForDate: date];
        
        NSDate *defaultDate = [date  dateByAddingTimeInterval: interval];
        
        NSLog(@"%@",defaultDate);
        
        
        
        [self.noticePicker setDate:defaultDate];
        self.noticePicker.minimumDate = defaultDate;
        NSDate *maxDate = [NSDate alloc];
        maxDate = [dateFormatter dateFromString:@"07-15 12:59"];
        self.noticePicker.maximumDate = maxDate;
        NSLog(@"maxDate%@",defaultDate);
        self.noticePicker.backgroundColor = [UIColor grayColor];
        
        [self.view addSubview:self.noticePicker];
        [UIView animateWithDuration:.5 animations:^{
            self.saveNoticeBtn.frame = CGRectMake(20, SCREEN_HEIGHT-50, SCREEN_WIDTH-40, 50);
            self.noticePicker.frame = CGRectMake(20, SCREEN_HEIGHT-270, SCREEN_WIDTH-40, 216);
        }];
    }
    else if ([str isEqualToString:@"app://exit"])
    {
        
#pragma mark webview 捕获  退出  链接
        //点击设置页-退出登录-确定：
        [self.userDF removeObjectForKey:@"access_token"];
        [self.userDF synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([str isEqualToString:@"app://share"])
    {
#pragma mark webview 捕获  分享  链接
        
        [self createBackGroundView];
        
        self.SVC = [[ShareToView alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT, SCREEN_WIDTH-50, 250)];
        self.SVC.delegate = self;
        [self.view addSubview:self.SVC];
        [UIView animateWithDuration:.5 animations:^{
            self.SVC.frame = CGRectMake(25, SCREEN_HEIGHT-260, SCREEN_WIDTH-50, 250);
        }];
    }
    else if ([str hasPrefix:@"app://mailto"])
#pragma mark webview 捕获  发送邮件  链接
    {
        NSString *regexString = @".*?&" ;
        NSArray  *matchArray   = NULL;
        
        
        matchArray = [self.webviewString componentsMatchedByRegex:regexString];
        NSLog(@"matchArray: %@" , matchArray);
        
        self.MailTitle = matchArray[0];
        self.MailTitle = [[[[self.MailTitle componentsSeparatedByString:@"tit="] lastObject] componentsSeparatedByString:@"&"] firstObject];
        
        self.MailMsgs = [NSMutableArray array];
        self.MailSrcs = [NSMutableArray array];
        self.sendMailFiles = [NSMutableArray array];
        for (NSString *messageSTR in matchArray)
        {
            
            NSString *tempSTR = messageSTR;
            //        tempSTR = [[tempSTR componentsSeparatedByString:@"&"] firstObject];
            
            if ([tempSTR hasPrefix:@"msg="]) {
                [self.MailMsgs addObject:tempSTR];
            }else if ([tempSTR hasPrefix:@"src="]){
                [self.MailSrcs addObject:tempSTR];
            }
        }
        NSLog(@"msgs%@,srcs%@,tit%@",self.MailMsgs,self.MailSrcs,self.MailTitle);
        
        [self downloadMailFiles];
        
    }
    else if ([str hasPrefix:@"app://uploadPhones"])
    {
#pragma mark webview 捕获  上传手机通讯录  链接
        [self ReadAllPeoples];
        
    }
    else if ([str isEqualToString:@"app://set_head"])
    {
#pragma mark webview 捕获  设置头像  链接
        UIActionSheet *changeHeadPhoto = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相机" otherButtonTitles:@"从相册选择", nil];
        
        [changeHeadPhoto showFromRect:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, SCREEN_HEIGHT) inView:self.view animated:YES];
    }
#pragma mark webview 捕获  右边栏  链接
    else if ([str hasSuffix:@"myrecord.html"])
    {
        self.labelTitle.text = @"我的记录";
    }
    else if ([str hasSuffix:@"myreport.html"])
    {
        self.labelTitle.text = @"我的发表";
    }
    else if ([str hasSuffix:@"mytask.html"])
    {
        self.labelTitle.text = @"我的任务";
        
    }
    else if ([str hasSuffix:@"mynews.html"])
    {
        self.labelTitle.text = @"我的消息";
        
    }
    else if ([str hasSuffix:@"myfriend.html"])
    {
        self.labelTitle.text = @"我的好友";
        
    }
    else if ([str hasSuffix:@"myattention.html"])
    {
        self.labelTitle.text = @"我的关注";
        
    }
    else if ([str hasSuffix:@"mycollection.html"])
    {
        self.labelTitle.text = @"我的收藏";
        
    }
    else if ([str hasSuffix:@"mycomment.html"])
    {
        self.labelTitle.text = @"我的评论";
        
    }
    else if ([str hasSuffix:@"public.html"])
    {
        self.labelTitle.text = @"公共频道";
        
    }
    else if ([str hasSuffix:@"set.html"])
    {
        self.labelTitle.text = @"设置";
        
    }
    else if ([str hasPrefix:@"app://edit_dataList"])
    {
        
#pragma mark webview 捕获  edit datalist集合
        self.editFilesList = [NSMutableArray array];
        NSString *files = [[str componentsSeparatedByString:@"app://edit_dataList?datalist="] lastObject];
        files = [files componentsSeparatedByString:@"'"][0];
        NSArray *filesArray = [files componentsSeparatedByString:@"&"];
        for (int i = 0; i < filesArray.count-1; i++) {
            [self.editFilesList addObject:[filesArray[i] componentsSeparatedByString:@"="][1]];
        }
        
        NSLog(@"strlist:%@",self.editFilesList);
    }
    else if ([str hasPrefix:@"app://save_edit_files"]){
#pragma mark webview 捕获保存   文件上传
        self.saveFilesList = [NSMutableArray array];
        NSString *files = [[str componentsSeparatedByString:@"app://save_edit_files?datalist="] lastObject];
        files = [files componentsSeparatedByString:@"'"][0];
        NSArray *filesArray = [files componentsSeparatedByString:@"&"];
        for (int i = 0; i < filesArray.count-1; i++) {
            [self.saveFilesList addObject:[filesArray[i] componentsSeparatedByString:@"="][1]];
        }
        NSLog(@"strlist:%@",self.saveFilesList);
        [self checkFileList];
//        [self filesUpload];
    }
    else if ([str hasPrefix:@"app://save_edit_public_files"])
    {
#pragma mark webview捕获 发表    文件上传
        
        self.uploadState = 2;
        self.saveFilesList = [NSMutableArray array];
        NSString *files = [[str componentsSeparatedByString:@"app://save_edit_files?datalist="] lastObject];
        files = [files componentsSeparatedByString:@"'"][0];
        NSArray *filesArray = [files componentsSeparatedByString:@"&"];
        for (int i = 0; i < filesArray.count-1; i++) {
            [self.saveFilesList addObject:[filesArray[i] componentsSeparatedByString:@"="][1]];
        }
        NSLog(@"strlist:%@",self.saveFilesList);
        [self checkFileList];
//        [self filesUpload];
    }
    
    NSLog(@"获得的加载链接地址%@\n",str);
    return YES;
}

#pragma mark 筛选文件list
-(void)checkFileList
{
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.uploadState != 1) {
            
            if (self.saveFilesList.count)
            {
                for (NSString *savefile in self.saveFilesList) {
                    if ([self.editFilesList containsObject:savefile]) {
                        if ([self.userInfo.fileList objectForKey:savefile]) {
                            [self.userInfo.fileList removeObjectForKey:savefile];
                        }
                    }
                }
                
            }
            else
            {
                [self.userInfo.fileList removeAllObjects];
            }
            
            for (NSString *fileName in self.userInfo.fileList.allKeys) {
                
                
                if (![self.saveFilesList containsObject:fileName]) {
                    [self.userInfo.fileList removeObjectForKey:fileName];
                }
            }
        }
        
        for (NSString *fileName in self.userInfo.fileList.allKeys) {
            
            if ([fileName hasPrefix:@"vdo_"]) {
                NSString *imageFileName = [fileName stringByReplacingOccurrencesOfString:@"vdo_" withString:@"img_"];
                [self.userInfo.fileList setObject:[[[ZZCPrivateClass getFileDirectoryByFileGuid:imageFileName] stringByAppendingPathComponent:imageFileName] stringByAppendingString:@".jpg"] forKey:imageFileName];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self filesUpload];
        });
    });
}

#pragma mark 保存提醒日期
-(void)saveDate:(UIButton *)sender
{
    
    NSLog(@"修改了提醒日期target %@",self.noticePicker.date);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd HH:mm"];
    NSString* dateString = [df stringFromDate:self.noticePicker.date];
    
    
    NSTimeInterval count = [self.noticePicker.date timeIntervalSince1970]*1000+3600*8*1000;
    
    NSString *dateJS = [[[NSString stringWithFormat:@"%@",self.noticePicker.date] componentsSeparatedByString:@"+"] firstObject];
    
    NSArray *dateArray = [dateJS componentsSeparatedByString:@" "];
    dateJS = [NSString stringWithFormat:@"edit.setRemind('%@ %@')",dateArray[0],dateArray[1]];
    dateString = [NSString stringWithFormat:@"/Date(%ld)/",(long)count];
    NSLog(@"date%@。?,%f,datestring%@,data%@，zzc getdata：%@",dateJS,count,dateString,self.noticePicker.date,[ZZCPrivateClass getRealTime]);
    
    [self removeBackGroundView];
    [self.customWebView stringByEvaluatingJavaScriptFromString:dateJS];
    
}

#pragma mark 创建  移除 背景灰版
-(void)createBackGroundView
{
    self.drawBoardBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.drawBoardBackView.backgroundColor = [UIColor blackColor];
    self.drawBoardBackView.alpha = .6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackGroundView)];
    [self.drawBoardBackView addGestureRecognizer:tap];
    [self.view addSubview:self.drawBoardBackView];
}

-(void)removeBackGroundView
{
    NSLog(@"noticePicker:%@,SVC:%@,drawVC:%@",self.noticePicker,self.SVC,self.drawVC);
    if (self.noticePicker) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.saveNoticeBtn.frame = CGRectMake(20, SCREEN_HEIGHT, SCREEN_WIDTH-40, 50);
            self.noticePicker.frame = CGRectMake(20, SCREEN_HEIGHT, SCREEN_WIDTH-40, 216);
        } completion:^(BOOL finished) {
            [self.saveNoticeBtn removeFromSuperview];
            [self.noticePicker removeFromSuperview];
            self.saveNoticeBtn = nil;
            self.noticePicker = nil;
        }];
    }else if (self.SVC) {
        [UIView animateWithDuration:.5 animations:^{
            self.SVC.frame = CGRectMake(25, SCREEN_HEIGHT, SCREEN_WIDTH-50, 250);
        } completion:^(BOOL finished) {
            [self.SVC removeFromSuperview];
            self.SVC = nil;
        }];
    }else if (self.drawVC){
        [self.drawVC removeFromSuperview];
        [self.drawSaveBtn removeFromSuperview];
        self.customWebView.userInteractionEnabled = YES;
        self.drawVC = nil;
        self.drawSaveBtn = nil;
    }
    [self.drawBoardBackView removeFromSuperview];
}

#pragma mark webview完成加载后
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    if ([self.customWebView.request.URL.path rangeOfString:@"TuJiApp/"].length) {
        
        
        if ([self.customWebView.request.URL.path rangeOfString:@"edit"].length) {
            
            [self.customWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"edit.getToken('%@')",self.userInfo.userToken]];
        }
        
        NSLog(@"edit.getToken%@",[NSString stringWithFormat:@"edit.getToken('%@')",self.userInfo.userToken]);
        
        [self.refreshPageTimer invalidate];
        self.refreshPageTimer = NULL;
        
        [self removeAllUserInfoFileList];
    }
    
    // 禁用用户选择
    //    [self.customWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    //
    //    // 禁用长按弹出框
    //    [self.customWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

#pragma mark 刷新页面 延迟超过几秒后
-(void)refreshPage
{
    if (!self.isFirstLoadPage) {
        self.isFirstLoadPage = YES;
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    }
    else
    {
        //        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showErrorWithStatus:@"网络状态不好，请重试！"];
        [self.refreshPageTimer invalidate];
        self.refreshPageTimer = NULL;
        //        [self.customWebView reloadInputViews];
        //        [self.view reloadInputViews];
    }
}

#pragma mark 更换头像actionsheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex%ld",(long)buttonIndex);
    self.uploadState = 1;
    switch (buttonIndex) {
        case 0:
            self.isVideo = 0;
            [self setPicker];
            
            break;
        case 1:
            self.isVideo = 2;
            [self setPicker];
            break;
    }
}


#pragma mark imgPicker初始化
-(void)setPicker
{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    
    if (self.isVideo == 0)
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.picker setMediaTypes: @[@"public.image"]];
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self presentViewController:self.picker animated:YES completion:^{
                
            }];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"模拟器中无法打开照相机,请在真机中使用"];
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
        
    }
    else if (self.isVideo == 1)
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.picker setMediaTypes: @[@"public.movie"]];
        self.picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self presentViewController:self.picker animated:YES completion:^{
                
            }];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"模拟器中无法打开照相机,请在真机中使用"];
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
        self.picker.videoMaximumDuration = 30;
    }
    else if (self.isVideo == 2)
    {
        NSLog(@"相册");
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*)kUTTypeImage, nil];
        [self presentViewController:self.picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark 协议方法获取照片后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        if (self.isVideo == 0 && self.isVideo == 2) {
            
        }
        UIImage* image;
        if ([info objectForKey:UIImagePickerControllerEditedImage]) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        
        image = [ZZCPrivateClass scaleImage:image toScale:0.1];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            NSData *picData = UIImageJPEGRepresentation(image, 1);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *guidName = [ZZCPrivateClass createUserFileByName:@"image" andData:picData];
                
                UIImage *testImage = [UIImage imageWithContentsOfFile:[self.userInfo.fileList objectForKey:guidName]];
                NSLog(@"testImage%ld",(long)testImage.imageOrientation);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self filesUpload];
                });
            });
            /*
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             
             NSString *guidName = [ZZCPrivateClass createUserFileByName:@"image" andData:picData];
             
             UIImage *testImage = [UIImage imageWithContentsOfFile:[self.userInfo.fileList objectForKey:guidName]];
             NSLog(@"testImage%ld",(long)testImage.imageOrientation);
             
             dispatch_async(dispatch_get_main_queue(), ^{
             [self filesUpload];
             });
             });
             */
            
        }];
    }
    else if([type isEqualToString:@"public.movie"])
    {
        
#pragma mark         摄像头获取内容 如果是录制视频
        
        NSLog(@"video...");
        
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        NSLog(@"%@",urlStr);
        
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        NSString *floderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
        NSString *fileNameGuid = [ZZCPrivateClass getGuid];
        NSLog(@"%@",fileNameGuid);
        NSString *videoGuid = [NSString stringWithFormat:@"vdo_%@",fileNameGuid];
        
        NSString *videoPath = [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"video/%@.mp4",videoGuid]];
        
        if (videoData) {
            [videoData writeToFile:videoPath atomically:YES];
            [self.userInfo.fileList setObject:videoPath forKey:videoGuid];
        }
        
        
        //根据url创建AVURLAsset
        AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
        //根据AVURLAsset创建AVAssetImageGenerator
        AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        /*截图
         * requestTime:缩略图创建时间
         * actualTime:缩略图实际生成的时间
         */
        NSError *error=nil;
        CMTime time=CMTimeMakeWithSeconds(1, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
        CMTime actualTime;
        CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
        if(error){
            NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        }
        CMTimeShow(actualTime);
        UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
        
        XiutuVC *xiuzheng = [[XiutuVC alloc] init];
        image = [xiuzheng rotateImg:image withDegree:90];
        NSLog(@"imageOrientation%ld",(long)image.imageOrientation);
        CGImageRelease(cgImage);
        NSData *imageData = UIImageJPEGRepresentation(image, 0.05);
        NSString *imageGuid = [NSString stringWithFormat:@"img_%@",fileNameGuid];
        
        NSString *imagePath = [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image/%@.jpg",imageGuid]];
        if (imageData) {
            [imageData writeToFile:imagePath atomically:YES];
            [self.userInfo.fileList setObject:imagePath forKey:imageGuid];
        }
        
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, nil, nil, nil);
        }
        
        AVURLAsset *avUrl=[AVURLAsset assetWithURL:url];
        CMTime videoTime = [avUrl duration];
        self.videoLength = [NSString stringWithFormat:@"%d",(int)ceil(videoTime.value/videoTime.timescale)];
        
        
        //执行js
        NSString *js = [NSString stringWithFormat:@"edit.vedioRecording('%@','%@','%@')",videoGuid,[NSString stringWithFormat:@"data:image/jpg;base64,%@",[self imgToString:image]],self.videoLength];
        [self.customWebView stringByEvaluatingJavaScriptFromString:js];
        NSLog(@"视频长度%@",self.videoLength);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 协议 保存图片协议
-(void)saveImage:(UIImage *)image byType:(NSInteger)type
{
    //把image转换成data
    NSData *data;
    data = UIImageJPEGRepresentation(image, .005);
    NSLog(@"saveImage Data:%lu",(unsigned long)data.length);
    NSString *imageGuid;
    NSString *imgStr = [self imgToString:image];
    NSLog(@"saveImagetype:%ld",(long)type);
    NSString *js;
    switch (type) {
            
        case 1:
            imageGuid = [ZZCPrivateClass createUserFileByName:@"image" andData:data];
            js = [NSString stringWithFormat:@"edit.addPic('%@','%@')",imageGuid, [NSString stringWithFormat:@"data:image/jpg;base64,%@",imgStr]];
            break;
        case 2:
            imageGuid = [ZZCPrivateClass createUserFileByName:@"image" andData:data];
            [self.userInfo.fileList removeObjectForKey:self.fileGuid];
            js = [NSString stringWithFormat:@"edit.changePic('%@','%@','%@')",self.fileGuid,imageGuid,[NSString stringWithFormat:@"data:image/jpg;base64,%@",imgStr]];
            NSLog(@"changeXIUTU JS:%@",self.fileGuid);
            NSLog(@"%@",imageGuid);
            break;
        case 3:
            imageGuid = [ZZCPrivateClass createUserFileByName:@"draw" andData:data];
            js = [NSString stringWithFormat:@"edit.drawRecording('%@','%@')",imageGuid,[NSString stringWithFormat:@"data:image/jpg;base64,%@",imgStr]];
            [self removeBackGroundView];
            break;
        case 4:
            
            [self removeBackGroundView];
            break;
    }
    NSLog(@"%lu",(unsigned long)imgStr.length);
    [self.customWebView stringByEvaluatingJavaScriptFromString:js];
}


#pragma mark img转64位data字符串
-(NSString *)imgToString:(UIImage *)image
{
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSString *imgDataString = [imgData base64EncodedStringWithOptions:0];
    return imgDataString;
}


#pragma mark 播放视频
-(void)videoPlayClick:(NSString *)fileName
{
    NSString *playPath = [ZZCPrivateClass getFilePathByStr:fileName];
    
    NSLog(@"playPath%@",playPath);
    NSURL *url=[NSURL fileURLWithPath:playPath];
    NSLog(@"url%@",url);
    
    
    self.moviePlayer = [ [ MPMoviePlayerController alloc]initWithContentURL:url];
    self.moviePlayer.view.frame = self.view.frame;
    self.moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer setFullscreen:YES];
    
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name: MPMoviePlayerDidExitFullscreenNotification object:nil];
    [self.moviePlayer play];
    
    
    //    _player=[AVPlayer playerWithURL:url];
    //    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    //    self.photo = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:self.photo];
    //    playerLayer.frame=self.photo.frame;
    //    [self.photo.layer addSublayer:playerLayer];
    //    [_player play];
    
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
#pragma mark 视频播放完成
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification
{
    NSLog(@"播放完成.%li",(long)self.moviePlayer.playbackState);
    
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer stop];
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification
{
    switch (self.moviePlayer.playbackState)
    {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%ld",(long)self.moviePlayer.playbackState);
            break;
    }
}


- (BOOL)shouldAutorotate
{
    return NO;
}
/**
 *  分享view协议代理方法  点击后  跳到对应的分享
 *
 *  @param name 点击的按钮的tag值 1 qq 2 微信 3 微信朋友圈 4新浪微博
 */
#pragma mark 分享面板
-(void)shareToSNS:(NSInteger)name
{
    
    UIImage *iv = [UIImage imageNamed:@"推送.png"];
    
    NSString *shareUrl = self.customWebView.request.URL.absoluteString;
    
    NSLog(@"shareUrl%@",self.customWebView.request.URL);
    [self.SVC removeFromSuperview];
    
    switch (name) {
        case 1:
            
            [UMSocialData defaultData].extConfig.qqData.title = @"QQ分享title";
            
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"我正在使用图记，用qq想邀请你一起使用使用图记！" image:iv location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
            
            break;
            
        case 2:
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"我正在使用图记，用微信邀请你一起使用图记！" image:iv location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
            
            break;
            
        case 3:
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"朋友圈title";
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"我正在使用图记，用微信邀请你一起使用图记！" image:iv location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
            
            break;
            
        case 4:
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"我正在使用图记，用微信邀请你一起使用图记！" shareImage:nil socialUIDelegate:self];
            
            //回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        case 5:
            [self removeBackGroundView];
            break;
        case 101:
            
            [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@TuJiApp/to_friend.html?link=%@",[ZZCPrivateClass getServersUrl],shareUrl]]]];
            [self removeBackGroundView];
            break;
        case 102:
            
            NSLog(@"复制，粘贴板的值：%@",shareUrl);
            
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.persistent = YES;
            pasteboard.string = shareUrl;
            
            
            [SVProgressHUD showSuccessWithStatus:@"复制成功！"];
            
            break;
    }
}

#pragma mark CustomWebViewProtocol 协议方法
-(void)sendRequest:(NSString *)url
{
    if ([url hasPrefix:@"http"]) {
        [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else{
        NSString *js = [NSString stringWithFormat:@"edit.soundRecording('%@')",url];
        [self.customWebView stringByEvaluatingJavaScriptFromString:js];
    }
    
    if (self.webRight) {
        [self removeRightView];
    }
}

-(void)downloadMailFiles
{
//    if (self.MailSrcs.count)
//    {
//        
//        
//        for (NSString *fileSTR in self.MailSrcs)
//        {
//            NSString *fileName =[NSString stringWithFormat:@"src=%@",[[[[fileSTR componentsSeparatedByString:@"&"] firstObject] componentsSeparatedByString:@"/"] lastObject]];
//            if ([self SandBoxFileExit:fileName])
//            {
//                [self.sendMailFiles addObject:[ZZCPrivateClass getFilePathByStr:fileSTR]];
//                [self.MailSrcs removeObject:fileSTR];
//                [self downloadMailFiles];
//            }
//            else
//            {
//                NSLog(@"%@",self.MailSrcs);
//                self.uploadState = 4;
//                [self downLoadFile:fileSTR];
//            }
//        }
//    }
//    else
//    {
//        [self sendEmailAction];
//    }
//    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSString *fileSTR in self.MailSrcs)
        {
            NSString *fileName =[NSString stringWithFormat:@"src=%@",[[[[fileSTR componentsSeparatedByString:@"&"] firstObject] componentsSeparatedByString:@"/"] lastObject]];
            if ([self SandBoxFileExit:fileName])
            {
                [self.sendMailFiles addObject:[ZZCPrivateClass getFilePathByStr:fileSTR]];
//                [self downloadMailFiles];
            }
            else
            {
                NSLog(@"%@",self.MailSrcs);
                self.uploadState = 4;
                [self downLoadFile:fileSTR];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            [SVProgressHUD dismiss];
            [self setMailSrcs:nil];
            [self sendEmailAction];
        });
        
    });
    
    //    if (self.MailSrcs.count)
    //    {
    //        for (int i = 0; i < self.MailSrcs.count; i ++)
    //        {
    //            NSString *fileName =[NSString stringWithFormat:@"src=%@",[[[[self.MailSrcs[i] componentsSeparatedByString:@"&"] firstObject] componentsSeparatedByString:@"/"] lastObject]];
    //            if ([self SandBoxFileExit:fileName])
    //            {
    //                [self.sendMailFiles addObject:[ZZCPrivateClass getFilePathByStr:self.MailSrcs[i]]];
    //            }
    //            else
    //            {
    //                NSLog(@"%@",self.MailSrcs);
    //                self.uploadState = 4;
    //                [self downLoadFile:self.MailSrcs[i]];
    //            }
    //        }
    //    }
    //    else
    //    {
    //        [self sendEmailAction];
    //    }
}

#pragma mark  判断本地沙盒是否存在该文件
-(BOOL)SandBoxFileExit:(NSString *)str
{
    
    //app://edit_img?guid=img_5857B04E_3ECC_42F7_A3B7_49F10E5C8C5E.jpg&src=http://118.194.132.115:8086/UpLoadFile/Image/img_5857B04E_3ECC_42F7_A3B7_49F10E5C8C5E.jpg
    NSString *fileName = [[str componentsSeparatedByString:@"&"] firstObject];
    fileName = [[fileName componentsSeparatedByString:@"="] lastObject];
    self.fileGuid = fileName;
    if ([fileName hasPrefix:@"img_"] || [fileName hasPrefix:@"drw_"]) {
        if (![fileName hasSuffix:@".jpg"]) {
            
            fileName = [fileName stringByAppendingString:@".jpg"];
        }
    }else if ([fileName hasPrefix:@"aud_"]) {
        if (![fileName hasSuffix:@".mp3"]) {
            
            fileName = [fileName stringByAppendingString:@".mp3"];
        }
    }else if ([fileName hasPrefix:@"vdo_"]) {
        if (![fileName hasSuffix:@".mp4"]) {
            
            fileName = [fileName stringByAppendingString:@".mp4"];
        }
    }
    NSLog(@"filename:%@",fileName);
    NSString *fileURL = [ZZCPrivateClass getFileDirectoryByFileGuid:fileName];
    return [[self.fileManager contentsOfDirectoryAtPath:fileURL error:nil] containsObject:fileName];
}

#pragma mark 发送邮件
- (void)sendEmailAction
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [SVProgressHUD showErrorWithStatus:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        [SVProgressHUD showErrorWithStatus:@"用户没有设置邮件账户"];
        return;
    }
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"我是邮件主题！图记"];
    // 设置收件人
    [mailCompose setToRecipients:@[@"hnspdszzc@126.com"]];
    /**
     *  设置邮件的正文内容
     */
    
    NSString *msg = self.MailTitle;
    
    for (int i = 0; i < self.MailMsgs.count; i++) {
        
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%@\n        ",[[[[self.MailMsgs[i] componentsSeparatedByString:@"&"] firstObject] componentsSeparatedByString:@"msg="] lastObject]]];
        NSLog(@"%@",msg);
    }
    NSString *emailContent = [NSString stringWithFormat:@"\n邮件内容：我正在使用图记！以下是编辑页内容：\n\n        %@",msg];
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    /**
     *  添加附件
     */
    if (self.sendMailFiles.count) {
        for (NSString *fileValue in self.sendMailFiles) {
            //[0]	__NSCFString *	@"http://m.tuji.linkdow.net/UpLoadFile/Image/img_42DF452C_9E99_488A_B69E_7AB5D0FC708A.jpg"	0x1b09ec40
            NSString *fileName =[[fileValue componentsSeparatedByString:@"/"] lastObject];
            NSString *filePath = [ZZCPrivateClass getFileDirectoryByFileGuid:fileName];
            filePath = [filePath stringByAppendingPathComponent:fileName];
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            NSLog(@"MailDatalength:%lu",(unsigned long)fileData.length);
            [mailCompose addAttachmentData:fileData mimeType:@"" fileName:fileName];
            //                [self.sendMailFiles removeObject:fileValue];
        }
    }
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}




- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            [SVProgressHUD showSuccessWithStatus:@"正在发送"];
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 文件上传
-(void)singleFileUpload:(NSString *)fileKey
{
    NSString *filePath = [self.userInfo.fileList objectForKey:fileKey];
    
    //文件类型 Image Video Media
    NSString *fileType;
    //文件名
    NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
    //文件前缀名
    NSString *filePrifix = [[fileName componentsSeparatedByString:@"_"] firstObject];
    NSString *mimeType;
    if ([filePrifix isEqualToString:@"aud"])
    {
        self.fileLength = 102400;
        fileType = @"Media";
        mimeType = @"Media/mp3";
    }
    else if([filePrifix isEqualToString:@"vdo"])
    {
        self.fileLength = 10240000;
        fileType = @"Video";
        mimeType = @"Video/mp4";
    }
    else if([filePrifix isEqualToString:@"img"])
    {
        self.fileLength = 10240000;
        fileType = @"Image";
        mimeType = @"Image/jpg";
    }
    else if ([filePrifix isEqualToString:@"drw"])
    {
        self.fileLength = 102400;
        fileType = @"Image";
        mimeType = @"Image/jpg";
    }
    
    NSLog(@"mimeType:%@",mimeType);
    if (self.uploadFileIsFirst) {
        NSLog(@"filePath%@",filePath);
        ///var/mobile/Containers/Data/Applicationos/3BBB743B-5574-4B58-96D6-1B76E6EF7832/Documents/13121139427/image/img_A3023C3A_3F95_4EF2_A795_BC3ECD8A5995.jpg
        ///var/mobile/Containers/Data/Application/3BBB743B-5574-4B58-96D6-1B76E6EF7832/Documents/13121139427/image/img_EDFF7D7D_2FA5_4972_AE4F_E73AB5ADA5B8.jpg
        self.uploadFileData = [NSData dataWithContentsOfFile:filePath];
        self.uploadFileIsFirst = NO;
        self.fileCurrentIndex = 0;
    }
    NSLog(@"%ld",(unsigned long)self.uploadFileData.length);
    //本次文件共需要分成几段上传
    NSUInteger fileCount = self.uploadFileData.length/self.fileLength + 1;
    if ((self.fileCurrentIndex +1)*self.fileLength > self.uploadFileData.length)
    {
        self.fileLength = self.uploadFileData.length - self.fileLength * self.fileCurrentIndex;
        self.uploadFileIsEnd = YES;
    }
    NSRange range = {self.fileCurrentIndex * self.fileLength,self.fileLength};
    NSLog(@"range===location:%ld,length:%ld",(long)range.location,(long)range.length);
    
    NSData *subData = [self.uploadFileData subdataWithRange:range];
    
    NSString *loadUrl = [NSString stringWithFormat:@"%@api/UpLoad/File?Type=%@&FileName=%@&Segments=%ld&Current=%ld&Size=%ld&Position=%ld",[ZZCPrivateClass getServersUrl],fileType,fileName,(unsigned long)fileCount,(unsigned long)self.fileCurrentIndex+1,(unsigned long)self.uploadFileData.length,(unsigned long)self.fileLength*(self.fileCurrentIndex+1)];
    NSLog(@"%@",loadUrl);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    [manager POST:loadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"formData%@",formData);
        [formData appendPartWithFileData:subData name:@"uploadFile" fileName:@"uploadFileName" mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"上传文件1！%@",responseObject);
        NSLog(@"Message:%@?",[dic objectForKey:@"Message"]);
        
        NSLog(@"uploadFileIsEnd:%d",self.uploadFileIsEnd);
        //这样判断是为了保证最后一段也能上传成功
        if ([[dic objectForKey:@"StateCode"] intValue] == 1001 && !self.uploadFileIsEnd)
        {
            if (!self.progressView && self.uploadState != 1)
            {
                [self createPRV];
            }
            self.fileCurrentIndex ++;
            [self.progressView setProgress:(float)self.fileCurrentIndex/fileCount animated:YES];
            
            [self singleFileUpload:fileKey];
        }
        else if([[dic objectForKey:@"StateCode"] intValue] != 1001)
        {
            NSLog(@"上传文件失败！%@",[dic objectForKey:@"Message"]);
            self.uploadFaildTimes++;
            if (self.uploadFaildTimes <= 5) {
                
                [self singleFileUpload:filePath];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"上传失败，请稍候重新尝试！"];
            }
        }
        else
        {
            NSString *servesUrl = [ZZCPrivateClass getServersUrl];
            
            [self.allFilePV setProgress:(float)self.uploadCurrentFileNum/self.uploadFileCount animated:YES];
            
            if (self.uploadState == 1) {
                
                [self.customWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setImage('%@')",[servesUrl stringByAppendingString:[dic objectForKey:@"Message"]]]];
                [SVProgressHUD dismiss];
            }
            
            
            [self.userInfo.httpList setObject:[servesUrl stringByAppendingString:[dic objectForKey:@"Message"]] forKey:fileKey];
            
            [self.userInfo.fileList removeObjectForKey:fileKey];
            
            [self filesUpload];
            NSLog(@"接着上传下一个");
        }
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"上传文件失败！%@",error);
         self.uploadFaildTimes++;
         if (self.uploadFaildTimes <= 5) {
             
             [self singleFileUpload:filePath];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"上传失败，请稍候重新尝试！"];
         }
     }];
}

-(void)filesUpload
{
    
    
    
    //value	NSPathStore2 *	@"/var/mobile/Containers/Data/Application/7A77EAFE-EC25-4DC2-B9FF-1A5CF0B87034/Documents/DC2437D89FC82578A4AD5E0C6A1DE928/image/img_57A73A5A_234B_4E74_BD09_D0D07C99711C"	0x18fe7930
    //value	NSPathStore2 *	@"/var/mobile/Containers/Data/Application/7A77EAFE-EC25-4DC2-B9FF-1A5CF0B87034/Documents/DC2437D89FC82578A4AD5E0C6A1DE928/video/vdo_57A73A5A_234B_4E74_BD09_D0D07C99711C.mp4"	0x1c8637d0
    //value	__NSCFString *	@"/var/mobile/Containers/Data/Application/64066F21-B886-4C2B-8F7E-6FB4876A29B5/Documents/DC2437D89FC82578A4AD5E0C6A1DE928/image/img_F21D50AF_953E_4E2D_AD91_6CDF5FFEF448.jpg"	0x155438e0
    if (self.uploadFileCount == 0) {
        self.uploadFileCount = self.userInfo.fileList.count;
    }
    //value	__NSCFString *	@"/var/mobile/Containers/Data/Application/55536730-00DF-4809-98C6-4D75CADBE843/Documents/DC2437D89FC82578A4AD5E0C6A1DE928/image/img_1521E6DA_158D_4006_B7C1_3A9DC99D5E0A.jpg"	0x17e870c0
    //value	NSPathStore2 *	@"/var/mobile/Containers/Data/Application/55536730-00DF-4809-98C6-4D75CADBE843/Documents/DC2437D89FC82578A4AD5E0C6A1DE928/video/vdo_1521E6DA_158D_4006_B7C1_3A9DC99D5E0A.mp4"	0x1da60810
    
    
    NSLog(@"fileList:%@",self.userInfo.fileList);
    
    if (self.userInfo.fileList.count)
    {
        for (NSString *fileKey in self.userInfo.fileList.allKeys) {
            NSLog(@"filePath%@",fileKey);
            self.uploadFileIsEnd = NO;
            self.uploadFileIsFirst = YES;
            [self singleFileUpload:fileKey];
            self.uploadCurrentFileNum++;
            [SVProgressHUD showWithStatus:@"正在上传同步..." ];
            return;
        }
    }
    else
    {
        if (self.uploadState == 1) {
            [SVProgressHUD dismiss];
            self.uploadState = 0;
        }
        else
        {
            for (NSString *httpKey in self.userInfo.httpList.allKeys)
            {
                NSString *value = [self.userInfo.httpList objectForKey:httpKey];
                NSString *tihuanJS;
                if ([httpKey hasPrefix:@"img_"])
                {
                    tihuanJS = [NSString stringWithFormat:@"edit.tranPic('%@','%@')",httpKey,value];
                    
                    
                    //edit.tranPic('img_2C6A5CB8_7A95_4EE2_B6A6_DA203F2D96A9','http://m.tuji.linkdow.net/UpLoadFile/Image/img_2C6A5CB8_7A95_4EE2_B6A6_DA203F2D96A9.jpg')
                }
                else if ([httpKey hasPrefix:@"aud_"])
                {
                    tihuanJS = [NSString stringWithFormat:@"edit.tranAudio('%@','%@')",httpKey,value];
                }
                else if ([httpKey hasPrefix:@"drw_"])
                {
                    tihuanJS = [NSString stringWithFormat:@"edit.tranDraw('%@','%@')",httpKey,value];
                    
                }
                else if ([httpKey hasPrefix:@"vdo_"])
                {
                    NSString *value2 = [value stringByReplacingOccurrencesOfString:@"vdo_" withString:@"img_"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"];
                    value2 = [value2 stringByReplacingOccurrencesOfString:@"Video/" withString:@"Image/"];
                    tihuanJS = [NSString stringWithFormat:@"edit.tranImg_Vedio('%@','%@','%@')",httpKey,value2,value];
                }
                NSLog(@"tihuanJS%@",tihuanJS);
                [self.customWebView stringByEvaluatingJavaScriptFromString:tihuanJS];
                [self.userInfo.httpList removeObjectForKey:httpKey];
            }
            
            
            //edit.tranImg_Vedio('vdo_CA987130_B415_4FD9_80FF_0249195C7254','http://m.tuji.linkdow.net/UpLoadFile/Video/img_CA987130_B415_4FD9_80FF_0249195C7254.mp4','http://m.tuji.linkdow.net/UpLoadFile/Video/vdo_CA987130_B415_4FD9_80FF_0249195C7254.mp4')
            //edit.tranPic('img_CA987130_B415_4FD9_80FF_0249195C7254','http://m.tuji.linkdow.net/UpLoadFile/Image/img_CA987130_B415_4FD9_80FF_0249195C7254.jpg')
            
            [SVProgressHUD showSuccessWithStatus:@"同步完成！"];
//            [SVProgressHUD show];
            if (self.uploadState == 2) {
                [self.customWebView stringByEvaluatingJavaScriptFromString:@"savefile.saveasPublic()"];
                [SVProgressHUD show];
            }
            else
            {
                [self.customWebView stringByEvaluatingJavaScriptFromString:@"savefile.save()"];
//                [SVProgressHUD show];
            }
        }
        [self.allFilePV removeFromSuperview];
        self.allFilePV = nil;
        [self.progressView removeFromSuperview];
        self.progressView = nil;
        [self.label1 removeFromSuperview];
        self.label1 = nil;
        [self.label2 removeFromSuperview];
        self.label2 = nil;
        [self.uploadFileBackView removeFromSuperview];
        self.uploadFileBackView = nil;
    }
}

#pragma mark  下载编辑页文件
-(void)downLoadFile:(NSString *)str
{
    [SVProgressHUD show];
    
    //    NSString *fileUrl = [[str componentsSeparatedByString:@"&"] lastObject];
    //    fileUrl = [[fileUrl componentsSeparatedByString:@"="] lastObject];
    
    NSString *fileUrl;
    if (self.uploadState == 4) {
        fileUrl = [[str componentsSeparatedByString:@"&"] firstObject];
    }else
    {
        fileUrl = [[str componentsSeparatedByString:@"&"] lastObject];
    }
    fileUrl = [[fileUrl componentsSeparatedByString:@"="] lastObject];
    
    //    "src=http://m.tuji.linkdow.net/UpLoadFile/Image/img_AFE1786B_2F75_465A_A7C9_73AA57916024.jpg&"
    //fileUrl	__NSCFString *	@"http://m.tuji.linkdow.net/UpLoadFile/Media/aud_33A06EC2_DAED_41EC_BEED_CEA5B1205CB0.mp3"	0x160948d0
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDictionaryURL = [self.fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSLog(@"targetPath:%@,response:%@,[response suggestedFilename]:%@,documentsDictionaryURL:%@",targetPath,response,[response suggestedFilename],documentsDictionaryURL);
        
        return [documentsDictionaryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"reponse%@,filepath:%@",response,filePath);
        
        NSString *fileName = [response suggestedFilename];
        //fileName	__NSCFString *	@"src=img_99115552_0020_45D4_8C16_A7769B32D248.jpg"	0x16692a40
        NSString *fileDirectory = [ZZCPrivateClass getFileDirectoryByFileGuid:fileName];
        fileDirectory = [fileDirectory stringByAppendingPathComponent:fileName];
        [self.fileManager copyItemAtURL:filePath toURL:[NSURL fileURLWithPath:fileDirectory] error:nil];
        if (self.uploadState == 4)
        {
            [self.sendMailFiles addObject:[ZZCPrivateClass getFilePathByStr:str]];
            self.uploadState = 0;
//            [self downloadMailFiles];
        }
        else if ([fileName hasPrefix:@"img_"])
        {
            XiutuVC *xiutu = [[XiutuVC alloc] init];
            xiutu.filePath = self.webviewString;
            xiutu.delegate = self;
            [self.navigationController pushViewController:xiutu animated:YES];
        }
        else if ([fileName hasPrefix:@"vdo_"])
        {
            [self videoPlayClick:self.webviewString];
        }
        else if ([fileName hasPrefix:@"aud_"])
        {
            if (self.isRecording)
            {
                [self.recoderManager recorderStop];
            }
            NSString *filePath = [ZZCPrivateClass getFilePathByStr:self.webviewString];
            [self.recoderManager playRecorderWithUrl:filePath];
            NSString *fileUrl = [[str componentsSeparatedByString:@"?id="] lastObject];
            fileUrl = [[fileUrl componentsSeparatedByString:@"&"] firstObject];
            [self.customWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"if_edit.playAudio(%@)",fileUrl]];
            //filePath	NSPathStore2 *	@"/var/mobile/Containers/Data/Application/BBDBC2C2-E10B-4020-A4B5-ADC1DDCD4B58/Documents/DC2437D89FC82578A4AD5E0C6A1DE928/recorder/aud_02C83BCD_B693_46CA_9803_B214EE8BEB3B.mp3"	0x1b963880
            self.isRecording = NO;
        }
    }];
    
    [downloadTask resume];
}

#pragma mark 创建上传文件进度条
-(void)createPRV
{
    self.uploadFileBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 150)];
    self.uploadFileBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.uploadFileBackView];
    self.progressView = [[ASProgressPopUpView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26];
    self.progressView.frame = CGRectMake(100, 120, SCREEN_WIDTH-115, 1);
    self.progressView.popUpViewAnimatedColors = @[[ZZCPrivateClass colorWithHexString:@"#00b496"]];
    self.progressView.popUpViewCornerRadius = 10.0;
    [self.view addSubview:self.progressView];
    [self.progressView showPopUpViewAnimated:YES];
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 110, 85, 20)];
    self.label1.textColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    self.label1.text = @"当前文件：";
    [self.view addSubview:self.label1];
    
    self.allFilePV = [[ASProgressPopUpView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.allFilePV.frame = CGRectMake(100, 160, SCREEN_WIDTH-115, 1);
    self.allFilePV.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    self.allFilePV.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:18];
    self.allFilePV.popUpViewCornerRadius = 10.0;
    [self.view addSubview:self.allFilePV];
    [self.allFilePV showPopUpViewAnimated:YES];
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, 85, 20)];
    self.label2.textColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    self.label2.text = @"全部文件：";
    [self.view addSubview:self.label2];
}

#pragma mark 获取手机通讯录
-(void)ReadAllPeoples
{
    [SVProgressHUD showWithStatus:@"正在查找好友..."];
    
    NSDictionary *dic = @{@"verState":@"uploadPhones",
                          @"PhoneNums": [ZZCPrivateClass getAllPhonesNum],
                          @"Authorization":[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]};
    
    [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001) {
            [SVProgressHUD showSuccessWithStatus:@"查找通讯录成功"];
            [self.customWebView stringByEvaluatingJavaScriptFromString:@"adfriend()"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"查找通讯录失败"];
        }
    }];
}
-(void)removeAllUserInfoFileList
{
    if (self.userInfo.fileList.count) {
        [self.userInfo.fileList removeAllObjects];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.customWebView resignFirstResponder];
}
@end