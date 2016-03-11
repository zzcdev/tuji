
#import "RegisterViewController.h"
#import "WebViewViewController.h"
#import "UserProtocolViewController.h"
#import "CustomBackBarButton.h"
#import "UserLoginLogic.h"
#import "ZZCPrivateClass.h"
#import "ViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>


/**
 *  用户名昵称输入框
 */
@property (nonatomic,strong)UITextField *tfUserName;

/**
 *  身份输入框
 */
@property (nonatomic,strong)UITextField *tfIdifer;

/**
 *  注册密码输入框
 */
@property (nonatomic,strong)UITextField *tfPassWord;

/**
 *  注册电话号码输入框
 */
@property (nonatomic,strong)UITextField *tfPhoneNum;

/**
 *  发送注册验证码按钮
 */
@property (nonatomic,strong)UIButton *sendCodeBtn;

/**
 *  注册验证码输入框
 */
@property (nonatomic,strong)UITextField *tfVerCode;

/**
 *  验证码倒计时计时器
 */
@property (nonatomic,strong)NSTimer *timer;

/**
 *  验证码倒计时计数
 */
@property (nonatomic,assign)NSUInteger codeTiem;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //设置导航栏是否隐藏
//    self.navigationController.navigationBarHidden = NO;
    
    //初始化视图
    [self createUI];
}


/**
 *  绘制界面
 */
-(void)createUI
{
    //设置导航的标题
    [self.navigationItem setTitle:@"注册"];
    
    //设置导航标题的颜色字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置导航栏右侧按钮  包括名字点击事件和风格 点击验证并完成注册
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
    self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"背景色.png"];
    //设置导航栏右侧按钮的字体颜色
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    //自定义左侧返回按钮View
    CustomBackBarButton *backBarButton  = [[CustomBackBarButton alloc] init];
    
    //设置自定义左返回按钮View为导航栏左侧返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    
    //给自定义View添加点击事件，点击返回上一页面，popview
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)];
    [backBarButton addGestureRecognizer:tap];
    
    
    //创建页面
    
    //顶部灰块
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT*0.035)];
    topView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:topView];
    
    //用户注册 名昵称输入框
    self.tfUserName = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.112, SCREEN_HEIGHT*0.173, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.028)];
    self.tfUserName.placeholder = @"姓名";
    UIImageView *userName = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.052, SCREEN_HEIGHT*0.028)];
    userName.image = [UIImage imageNamed:@"登录注册-用户.png"];
    self.tfUserName.leftView = userName;
    self.tfUserName.leftViewMode = UITextFieldViewModeAlways;
    self.tfUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.tfUserName];
    
    //用户注册 昵称输入框下面横线
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.08, SCREEN_HEIGHT*0.225, SCREEN_WIDTH*0.839, SCREEN_HEIGHT*0.001)];
    label1.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#666666"];
    [self.view addSubview:label1];
    
    //用户注册 身份输入框
    self.tfIdifer = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.127, SCREEN_HEIGHT*0.25, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.028)];
    self.tfIdifer.placeholder = @"身份";
    UIImageView *idiferTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.042, SCREEN_HEIGHT*0.028)];
    idiferTFleftView.image = [UIImage imageNamed:@"登录注册-身份.png"];
    self.tfIdifer.leftView = idiferTFleftView;
    self.tfIdifer.leftViewMode = UITextFieldViewModeAlways;
    self.tfIdifer.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.tfIdifer];
    
    //身份输入框下面横线
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.08, SCREEN_HEIGHT*0.302, SCREEN_WIDTH*0.839, SCREEN_HEIGHT*0.001)];
    label2.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#666666"];
    [self.view addSubview:label2];

    //用户注册 密码输入框
    self.tfPassWord = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.127, SCREEN_HEIGHT*0.326, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.031)];
    self.tfPassWord.placeholder = @"密码";
    UIImageView *passWordTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.043, SCREEN_HEIGHT*0.031)];
    passWordTFleftView.image = [UIImage imageNamed:@"登录注册-密码.png"];
    self.tfPassWord.leftView = passWordTFleftView;
    self.tfPassWord.leftViewMode = UITextFieldViewModeAlways;
    self.tfPassWord.secureTextEntry = YES;
    [self.view addSubview:self.tfPassWord];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.38, SCREEN_WIDTH, SCREEN_HEIGHT*0.045)];
    centerView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:centerView];
    
    
    //注册手机号码输入框
    self.tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.126, SCREEN_HEIGHT*0.448, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.033)];
    self.tfPhoneNum.placeholder = @"请输入手机号码";
    UIImageView *tfPhoneNumTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.044, SCREEN_HEIGHT*0.033)];
    tfPhoneNumTFleftView.image = [UIImage imageNamed:@"手机.png"];
    self.tfPhoneNum.leftView = tfPhoneNumTFleftView;
    self.tfPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    self.tfPhoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfPhoneNum.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.tfPhoneNum];

    
    UIView *sendCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.502, SCREEN_WIDTH, SCREEN_HEIGHT*0.147)];
    sendCodeView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    
    [self.view addSubview:sendCodeView];
    
    //发送注册验证码按钮
    self.sendCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.202, sendCodeView.frame.size.height*0.202, SCREEN_WIDTH*0.595, SCREEN_HEIGHT*0.074)];
    self.sendCodeBtn.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendCodeBtn setTintColor:[UIColor whiteColor]];
    self.sendCodeBtn.layer.cornerRadius = 5;
    [self.sendCodeBtn addTarget:self action:@selector(sendVerCode) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeView addSubview:self.sendCodeBtn];
    
    //注册验证码输入框
    self.tfVerCode = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.123, SCREEN_HEIGHT*0.676, SCREEN_WIDTH-120, SCREEN_HEIGHT*0.027)];
    self.tfVerCode.placeholder = @"请输入验证码";
    UIImageView *tfVerCodeTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.05, SCREEN_HEIGHT*0.027)];
    tfVerCodeTFleftView.image = [UIImage imageNamed:@"登录注册-验证码.png"];
    self.tfVerCode.leftView = tfVerCodeTFleftView;
    self.tfVerCode.leftViewMode = UITextFieldViewModeAlways;
    self.tfVerCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfVerCode.keyboardType = UIKeyboardTypePhonePad;
    self.tfVerCode.delegate = self;
    [self.view addSubview:self.tfVerCode];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.726, SCREEN_WIDTH, SCREEN_HEIGHT*0.274)];
    bottomView.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:bottomView];
    //用户协议按钮
//    UILabel *protocolLabel = [[UILabel alloc]initWithFrame:CGRectMake(bottomView.frame.size.width*0.081, bottomView.frame.size.height*0.076, SCREEN_WIDTH, SCREEN_HEIGHT*0.023)];
//    protocolLabel.text = @"注册即表示同意《小智用户协议》";
//    protocolLabel.textAlignment = NSTextAlignmentLeft;
//    protocolLabel.textColor = [ZZCPrivateClass colorWithHexString:@"#666666"];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProtocol)];
//    [protocolLabel addGestureRecognizer:tap1];
//    protocolLabel.userInteractionEnabled = YES;
//    [bottomView addSubview:protocolLabel];
}

#pragma mark 发送注册验证码
-(void)sendVerCode
{
    [self touchesBegan:nil withEvent:nil];
    [SVProgressHUD show];
    //发送注册验证码请求的参数 verState为自己定义的登陆状态方便后面的接受方查看请求接口类型是登陆login 或者register 或者sendCode
    NSDictionary *dic = @{@"verState":@"sendCode",
                          @"PhoneNum": self.tfPhoneNum.text,
                          @"Action":@"0"};
    
    //请求验证，该方法主要做页面逻辑数据是否合理判断，内部再调用web请求
    [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
        
        //返回值为1001时为发送注册验证码成功
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001) {
        
            [SVProgressHUD showSuccessWithStatus:@"发送成功！请注意查看短信！"];

            //如果发送成功，设置倒计时基数为60秒
            self.codeTiem = 60;
            
            //设置发送验证码按钮的背景颜色为灰色
            self.sendCodeBtn.backgroundColor = [UIColor grayColor];
            
            //设置发送验证码倒计时timer
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendCodeTime) userInfo:nil repeats:YES];
            
            //开火～～
            [self.timer fire];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"Message"]];
        }
    }];
}

/**
 *  发送注册验证码成功后 timer 倒计时方法
 */
-(void)sendCodeTime
{
    [self.tfPhoneNum resignFirstResponder];
    
    //判断如果计数器为0，即倒计时完毕
    if (self.codeTiem == 0) {
        
        //设置按钮可点击
        self.sendCodeBtn.enabled = YES;
        
        //设置按钮标题名
        [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        //设置背景颜色
        self.sendCodeBtn.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#16ab90"];

        //timer停止
        [self.timer invalidate];
    }else
    {
        
        //倒计时开始，设置按钮标题名
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"重发验证码（%ld）",(unsigned long)self.codeTiem--] forState:UIControlStateNormal];
        
        //设置按钮不可点击
        self.sendCodeBtn.enabled = NO;
    }
}

/**
 *  导航栏右侧 完成按钮 点击注册事件
 */
-(void)doneClick
{
    [self touchesBegan:nil withEvent:nil];
    [SVProgressHUD show];
    NSLog(@"点击右侧完成按钮！");
    
    //效验 注册验证码 请求的参数 verState为自己定义的登陆状态方便后面的接受方查看请求接口类型是登陆login 或者register 或者sendCode
    NSDictionary *dic1 = @{@"verState":@"verCode",
                          @"PhoneNum": self.tfPhoneNum.text,
                           @"Code":self.tfVerCode.text,
                           @"Password": self.tfPassWord.text};
    
    //效验注册验证码请求验证，该方法主要做页面逻辑数据是否合理判断，内部再调用web请求
    [UserLoginLogic verDictionary:dic1 backBlock:^(id obj) {
        NSLog(@"backvalue%@",obj);
    
        //验证成功
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001) {
            NSDictionary *dic2 = @{@"verState":@"register",
                                  @"Name": self.tfUserName.text,
                                  @"Identity":self.tfIdifer.text,
                                  @"Password": self.tfPassWord.text,
                                  @"PhoneNum": self.tfPhoneNum.text};
            NSLog(@"参数初始化时的参数%@",dic2);
            //调用注册接口
            [UserLoginLogic verDictionary:dic2 backBlock:^(id obj) {
                
                //注册成功并跳转WebViewVC
                if ([[obj objectForKey:@"StateCode"] intValue] == 1001  && ![[obj objectForKey:@"Data"] isEqual:[NSNull null]]) {
                    [SVProgressHUD dismiss];
                    
                    WebViewViewController *webVC = [[WebViewViewController alloc] init];
                    webVC.userInfo.userId = self.tfPhoneNum.text;
                    webVC.userInfo.userToken = [[obj objectForKey:@"Data"] objectForKey:@"access_token"];

                    [self.navigationController pushViewController:webVC animated:YES];
                    
                    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"注册失败！"];
                }
            }];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"验证码验证不成功！"];

            NSLog(@"验证码效验不通过");
        }
    }];
}

/**
 *  导航栏左侧返回按钮点击事件
 */
-(void)backView
{
    //返回上一页面，登陆页
    [self.navigationController popViewControllerAnimated:YES];
//    ViewController *view = [[ViewController alloc] init];
//    self.view.window.rootViewController = view;
}

#pragma mark textField协议方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, -216, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneClick];
    return YES;
}

/**
 *  点击屏幕任意位置执行
 *  键盘收起
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tfPhoneNum resignFirstResponder];
    [self.tfPassWord resignFirstResponder];
    [self.tfIdifer resignFirstResponder];
    [self.tfUserName resignFirstResponder];
    [self.tfVerCode resignFirstResponder];
}

/**
 *  用户协议按钮点击事件
 */
-(void)userProtocol
{
    NSLog(@"跳转用户协议");
    //跳转用户协议VC
    UserProtocolViewController *uVC  = [[UserProtocolViewController alloc] init];
    [self.navigationController pushViewController:uVC animated:YES];
}
@end
