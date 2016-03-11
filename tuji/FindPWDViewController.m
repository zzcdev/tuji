
#import "FindPWDViewController.h"
#import "WebViewViewController.h"
#import "CustomBackBarButton.h"
#import "ZZCPrivateClass.h"
#import "UserLoginLogic.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface FindPWDViewController ()<UITextFieldDelegate>

/**
 *  电话号码输入框
 */
@property (nonatomic,strong)UITextField *tfPhoneNum;

/**
 *  验证码输入框
 */
@property (nonatomic,strong)UITextField *tfVerCode;

/**
 *  重置密码输入框
 */
@property (nonatomic,strong)UITextField *tfPassWord;

/**
 *  发送验证码按钮
 */
@property (nonatomic,strong)UIButton *sendCodeBtn;

/**
 *  验证码输入倒计时定时器
 */
@property (nonatomic,strong)NSTimer *timer;

/**
 *  验证码输入倒计时计数器
 */
@property (nonatomic,assign)NSUInteger codeTiem;
@end

@implementation FindPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏是否隐藏
    self.fd_prefersNavigationBarHidden = NO;


    //设置导航栏标题
    self.navigationItem.title = @"重置密码";
    
    //设置导航标题的颜色字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //自定义导航栏左侧返回按钮
    CustomBackBarButton *backBar = [[CustomBackBarButton alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBar];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backView)];
    [backBar addGestureRecognizer:tap];
    
    //设置导航栏右侧按钮 点击事件 标题
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.title = @"重置密码";
    
    //初始化界面
    [self createUI];
    
}


/**
 *  绘制界面
 */
-(void)createUI
{
    //创建页面
    
    //顶部灰块
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.073, SCREEN_WIDTH, SCREEN_HEIGHT*0.075 )];
    topView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:topView];

    //手机号输入框
    self.tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.112, SCREEN_HEIGHT*0.173, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.033)];
    self.tfPhoneNum.placeholder = @"  请输入手机号码";
    UIImageView *userName = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.044, SCREEN_HEIGHT*0.033)];
    userName.image = [UIImage imageNamed:@"手机.png"];
    self.tfPhoneNum.leftView = userName;
    self.tfPhoneNum.keyboardType = UIKeyboardTypePhonePad;
    self.tfPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    self.tfPhoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.tfPhoneNum];
    

    
    UIView *sendCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.224, SCREEN_WIDTH, SCREEN_HEIGHT*0.147)];
    sendCodeView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:sendCodeView];

    
    //发送 找回密码 验证码按钮
    self.sendCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(sendCodeView.frame.size.width*0.202, sendCodeView.frame.size.height*0.25, SCREEN_WIDTH*0.595, SCREEN_HEIGHT*0.074)];
    self.sendCodeBtn.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendCodeBtn setTintColor:[UIColor whiteColor]];
    self.sendCodeBtn.layer.cornerRadius = 5;
    [self.sendCodeBtn addTarget:self action:@selector(sendVerCode) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeView addSubview:self.sendCodeBtn];

    //找回密码 验证码输入框
    self.tfVerCode = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.124, SCREEN_HEIGHT*0.398, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.027)];
    self.tfVerCode.placeholder = @"  请输入验证码";
    UIImageView *tfVerCodeTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.05, SCREEN_HEIGHT*0.027)];
    tfVerCodeTFleftView.image = [UIImage imageNamed:@"登录注册-验证码.png"];
    self.tfVerCode.leftView = tfVerCodeTFleftView;
    self.tfVerCode.leftViewMode = UITextFieldViewModeAlways;
    self.tfVerCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfVerCode.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.tfVerCode];
    
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.448, SCREEN_WIDTH, SCREEN_HEIGHT*0.134)];
    centerView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:centerView];

    //新密码输入框
    self.tfPassWord = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.126, SCREEN_HEIGHT*0.604, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.031)];
    self.tfPassWord.placeholder = @"  设置新密码";
    UIImageView *passWordTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.043, SCREEN_HEIGHT*0.031)];
    passWordTFleftView.image = [UIImage imageNamed:@"登录注册-密码.png"];
    self.tfPassWord.leftView = passWordTFleftView;
    self.tfPassWord.leftViewMode = UITextFieldViewModeAlways;
    self.tfPassWord.secureTextEntry = YES;
    self.tfPassWord.delegate = self;
    [self.view addSubview:self.tfPassWord];
    
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.655, SCREEN_WIDTH, 300)];
    bottomView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:bottomView];
    

}

/**
 *  发送找回密码验证码点击事件
 */
-(void)sendVerCode
{

    [self touchesBegan:nil withEvent:nil];

    
    [SVProgressHUD show];
    //发送 找回密码 验证码请求的参数 verState为自己定义的登陆状态方便后面的接受方查看请求接口类型是登陆login 或者register 或者sendCode
    NSDictionary *dic = @{@"verState":@"sendCode",
                          @"PhoneNum": self.tfPhoneNum.text,
                          @"action":@"1"};
    
    //请求验证，该方法主要做页面逻辑数据是否合理判断，内部再调用web请求
    [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
        
        //返回值为1001时为发送 找回密码 验证码成功
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001) {
            [SVProgressHUD dismiss];
            //如果发送成功，设置倒计时基数为60秒
            self.codeTiem = 60;
            
            //设置发送验证码按钮的背景颜色为灰色
            self.sendCodeBtn.backgroundColor = [UIColor grayColor];
            
            //设置发送验证码倒计时timer
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendCodeTime) userInfo:nil repeats:YES];
            
            //开火～～
            [self.timer fire];
            [SVProgressHUD showSuccessWithStatus:@"发送成功！请注意查看短信！"];
        }
        else if([[obj objectForKey:@"StateCode"] intValue] == 1004)
        {
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"Message"]];
        }
    }];
}



/**
 *  发送 验证码 成功后timer倒计时事件
 */
-(void)sendCodeTime
{

    
    //如果计数倒计时结束
    if (self.codeTiem == 0) {
        
        //设置按钮可点击
        self.sendCodeBtn.enabled = YES;
        
        //设置标题
        [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        //设置颜色
        self.sendCodeBtn.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#16ab90"];
        
        //倒计时停止
        [self.timer invalidate];
    }else
    {
        //设置标题
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"重发验证码（%ld）",(unsigned long)self.codeTiem--] forState:UIControlStateNormal];
        
        //设置按钮不可点击
        self.sendCodeBtn.enabled = NO;
    }
}


/**
 *  导航栏右侧完成按钮点击事件 调用
 */
-(void)doneClick
{
    [self touchesBegan:nil withEvent:nil];

    
    [SVProgressHUD show];
    NSLog(@"完成找回密码！");
    
    NSLog(@"点击右侧完成按钮！");
    
    //效验 找回密码 验证码请求的参数 verState为自己定义的登陆状态方便后面的接受方查看请求接口类型是登陆login 或者register 或者sendCode
    NSDictionary *dic = @{@"verState":@"verCode",
                          @"PhoneNum": self.tfPhoneNum.text,
                          @"Code":self.tfVerCode.text,
                          @"Password":self.tfPassWord.text};
    
    //效验注册验证码请求验证，该方法主要做页面逻辑数据是否合理判断，内部再调用web请求
    [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
        
        //返回值为1001时为注册验证码验证成功
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001) {
            
            //找回密码
            
            NSDictionary *dic = @{@"verState":@"findPWD",
                                  @"PhoneNum": self.tfPhoneNum.text,
                                  @"Password":self.tfPassWord.text};
            [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
                
                //返回值为1001时注册成功并跳转WebViewVC
                if ([[obj objectForKey:@"StateCode"] intValue] == 1001  && ![[obj objectForKey:@"Data"] isEqual:[NSNull null]]) {
                    
                    
                    //完成验证并且跳转WebViewVC
                    WebViewViewController *webVC = [[WebViewViewController alloc] init];
                    webVC.userInfo.userId = self.tfPhoneNum.text;
//                    webVC.userInfo.userToken = [[obj objectForKey:@"Data"] objectForKey:@"access_token"];

                    NSDictionary *checkObj = [obj objectForKey:@"Data"];
                    
                    NSLog(@"%lu",(unsigned long)checkObj.count);
                    
                    if (checkObj.count) {
                        
                        if ([checkObj objectForKey:@"access_token"]) {
                            
                            webVC.userInfo.userToken = [[obj objectForKey:@"Data"] objectForKey:@"access_token"];
                        }
                    }
                    [self.navigationController pushViewController:webVC animated:YES];
                    
                    [SVProgressHUD showSuccessWithStatus:@"找回密码成功！"];
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"找回密码失败"];
                }
            }];
        }else{
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"验证码效验不通过"];
            NSLog(@"验证码效验不通过");
        }
    }];
}

/**
 *  导航栏左侧返回按钮点击事件
 */
-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tfPassWord resignFirstResponder];
    [self.tfPhoneNum resignFirstResponder];
    [self.tfVerCode resignFirstResponder];
}

#pragma mark textField协议方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self doneClick];
    return YES;
}

@end
