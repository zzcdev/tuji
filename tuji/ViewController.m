
#import "ViewController.h"

//注册VC
#import "RegisterViewController.h"

//WebVC
#import "WebViewViewController.h"

//找回密码VC
#import "FindPWDViewController.h"

//用户数据判断 页面逻辑
#import "UserLoginLogic.h"
#import "UserInfo.h"

//我的私人封装方法类  方便开发
#import "ZZCPrivateClass.h"
@interface ViewController ()<UITextFieldDelegate>

/**
 *  登陆账号:电话号码输入框
 */
@property (nonatomic,strong)UITextField *phoneNumTF;

/**
 *  登陆密码输入框
 */
@property (nonatomic,strong)UITextField *PwdTF;

/**
 *  注册按钮
 */
@property (nonatomic,strong)UIButton *registerBtn;

/**
 *  登陆按钮
 */
@property (nonatomic,strong)UIButton *loginBtn;

/**
 *  启动页
 */
@property (nonatomic,strong)UIImageView *starIV;

@end


@implementation ViewController

/**
 *  视图即将显示时
 */
-(void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
    //隐藏时间，信号，运营商
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    [super viewWillAppear:animated];
    
    self.starIV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.starIV.image = [UIImage imageNamed:@"启动页.jpg"];
    [self.view addSubview:self.starIV];
    
    self.navigationController.navigationBarHidden = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] != NULL) {
        [self AutoLogin];
    }
    else
    {
        [self.starIV removeFromSuperview];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)AutoLogin
{
    NSDictionary *dic = @{@"verState":@"AutoLogin"};
#pragma mark  自动登录 AutoLogin
    [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
        //返回值为1001时为登陆成功
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001  && ![[obj objectForKey:@"Data"] isEqual:[NSNull null]])
        {
            
            //跳转到WebViewVC
            WebViewViewController *webVC = [[WebViewViewController alloc] init];
            webVC.userInfo.userToken = [[obj objectForKey:@"Data"] objectForKey:@"access_token"];
            webVC.userInfo.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            [self.navigationController pushViewController:webVC animated:NO];
            [SVProgressHUD showSuccessWithStatus:@"自动登陆成功"];
        }
        [self.starIV removeFromSuperview];
    }];
}

/**
 *  绘制界面
 */
-(void)createUI
{
    //logo图片
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.387, SCREEN_HEIGHT*0.1007, SCREEN_WIDTH*0.226, SCREEN_HEIGHT*0.257)];
    logoImg.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:logoImg];
    
    //账户输入框
    self.phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.187, SCREEN_HEIGHT*0.4308211473565804, SCREEN_WIDTH*0.63, SCREEN_HEIGHT*0.0292463442069741)];
    self.phoneNumTF.placeholder = @"  手机号";
    UIImageView *phoneNumTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.053, SCREEN_HEIGHT*0.0292463442069741)];
    phoneNumTFleftView.image = [UIImage imageNamed:@"登录注册-用户.png"];
    self.phoneNumTF.leftView = phoneNumTFleftView;
    self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTF.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneNumTF];
    
    //输入框下面横线
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.106, SCREEN_HEIGHT*0.4696287964004499, SCREEN_WIDTH*0.788, SCREEN_HEIGHT*0.0022497187851519)];
    label1.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    [self.view addSubview:label1];
    
    //密码输入框
    self.PwdTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.191, SCREEN_HEIGHT*0.5331833520809899, SCREEN_WIDTH*0.63, SCREEN_HEIGHT*0.031496062992126)];
    self.PwdTF.placeholder = @"  密码";
    self.PwdTF.secureTextEntry = YES;
    UIImageView *PwdTFleftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.044, SCREEN_HEIGHT*0.031496062992126)];
    PwdTFleftView.image = [UIImage imageNamed:@"登录注册-密码.png"];
    self.PwdTF.leftView = PwdTFleftView;
    self.PwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.PwdTF.delegate = self;
    [self.view addSubview:self.PwdTF];
    
    //密码输入框下面横线
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.106, SCREEN_HEIGHT*0.5725534308211474, SCREEN_WIDTH*0.788, SCREEN_HEIGHT*0.0022497187851519)];
    label2.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
    [self.view addSubview:label2];
    
    //登陆按钮
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.297, SCREEN_HEIGHT*0.6991001124859393, SCREEN_WIDTH*0.114, SCREEN_HEIGHT*0.0326209223847019)];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    //注册按钮
    self.registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.594, SCREEN_HEIGHT*0.6991001124859393, SCREEN_WIDTH*0.113, SCREEN_HEIGHT*0.033)];
    [self.registerBtn setTitleColor:[ZZCPrivateClass colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    //登陆和注册中间竖线
    UILabel *lebellogin = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.498, SCREEN_HEIGHT*0.6889763779527559, SCREEN_WIDTH*0.004, SCREEN_HEIGHT*0.044)];
    lebellogin.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00B496"];
    [self.view addSubview:lebellogin];
    
    //忘记密码，找回密码按钮
    UIButton *findPassWord = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.628, SCREEN_HEIGHT*0.5984251968503937, SCREEN_WIDTH*0.281, SCREEN_HEIGHT*0.0298087739032621)];
    [findPassWord setTitleColor:[ZZCPrivateClass colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [findPassWord setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [findPassWord addTarget:self action:@selector(findClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPassWord];
    
    //微信登陆
    UIButton *loginByWX = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.211, SCREEN_HEIGHT*0.826, SCREEN_WIDTH*0.096, SCREEN_HEIGHT*0.054)];
    [loginByWX setImage:[UIImage imageNamed:@"微信.png"] forState:UIControlStateNormal];
    loginByWX.tag = 101;
    [loginByWX addTarget:self action:@selector(loginBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginByWX];
    
    //qq登陆
    UIButton *loginByQQ = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.450, SCREEN_HEIGHT*0.826, SCREEN_WIDTH*0.096, SCREEN_HEIGHT*0.054)];
    [loginByQQ setImage:[UIImage imageNamed:@"扣扣.png"] forState:UIControlStateNormal];
    loginByQQ.tag = 102;
    [loginByQQ addTarget:self action:@selector(loginBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginByQQ];
    
    //微博登陆
    UIButton *loginByXLWB = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.698, SCREEN_HEIGHT*0.826, SCREEN_WIDTH*0.096, SCREEN_HEIGHT*0.054)];
    [loginByXLWB setImage:[UIImage imageNamed:@"新浪微博.png"] forState:UIControlStateNormal];
    loginByXLWB.tag = 103;
    [loginByXLWB addTarget:self action:@selector(loginBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginByXLWB];
    
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        
        [loginByQQ removeFromSuperview];
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        [loginByWX removeFromSuperview];
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
        [loginByXLWB removeFromSuperview];
    }
}

#pragma mark 第三方登陆
-(void)loginBy:(UIButton *)sender
{

    UMSocialSnsPlatform *snsPlatform;
    NSString *shareTo;
    if (sender.tag == 101) {
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        shareTo = UMShareToWechatSession;
        
    }else if (sender.tag == 102){
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        shareTo = UMShareToQQ;
    }
    else if (sender.tag == 103)
    {
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        shareTo = UMShareToSina;
    }
    
    
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD show];

        //获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:shareTo];
            
            NSLog(@" snsAccount is %@",snsAccount);
            
            
            //跳转到WebViewVC
            //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
//            [[UMSocialDataService defaultDataService] requestSnsInformation:shareTo  completion:^(UMSocialResponseEntity *response){
            
                NSLog(@"SnsInformation is ？%@",response.data);

                
                NSLog(@" snsAccount is %@",snsAccount);

                
                NSDictionary *dic = @{@"verState":@"SFlogin",
                                      @"Platform":snsAccount.platformName,
                                      @"OpenId":snsAccount.usid,
                                      @"Name":snsAccount.userName,
                                      @"Photo":snsAccount.iconURL};
                
                [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
                    
                    //返回值为1001时为登陆成功
                    if ([obj objectForKey:@"Data"]) {
                        
                    }
                    if ([[obj objectForKey:@"StateCode"] intValue] == 1001 && ![[obj objectForKey:@"Data"] isEqual:[NSNull null]])
                    {
                        //跳转到WebViewVC
                        WebViewViewController *webVC = [[WebViewViewController alloc] init];
                        webVC.userInfo.userToken = [[obj objectForKey:@"Data"] objectForKey:@"access_token"];
                        webVC.userInfo.userId = snsAccount.usid;
                        [self.navigationController pushViewController:webVC animated:NO];
                        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                        
                        //登陆成功清空页面数据，否则返回后依然存在
                        self.phoneNumTF.text = @"";
                        self.PwdTF.text = @"";
                    }
                }];

//            }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"您已经取消授权登录！"];
        }
    });
}

    /*
     snsAccount is {
     accessToken = "OezXcEiiBSKSxW0eoylIeF2o3loXtajqsbSTcluYhhgIkJqnyHtJOJtlr8-PbS8NMYmNuyKfIbkVZpJEyu0nRsvMx3ppKn9xVPl3xhb-EszTdumdVTMgHZQHcjCOMxSg0HMaAoVqt3DlMibZJe3yEQ";
     expirationDate = "2015-07-27 07:35:33 +0000";
     iconURL = "http://wx.qlogo.cn/mmopen/ibkKkoaQFco72rgV6P6XsAGylerquygPVsHJFk17537vXewmIpZ7n47Hjdh4vXUaiaLopzmmkg7MM2MQzHU8kCLQ/0";
     platformName = wxsession;
     profileURL = "";
     userName = "\U653b\U57ce\U72eeProgrammerMonkey";
     usid = ovRnRvk9UtPSaJdcAO8rdUpJBck4;
     }
     SnsInformation is ？{
     "access_token" = "OezXcEiiBSKSxW0eoylIeF2o3loXtajqsbSTcluYhhgIkJqnyHtJOJtlr8-PbS8NMYmNuyKfIbkVZpJEyu0nRsvMx3ppKn9xVPl3xhb-EszTdumdVTMgHZQHcjCOMxSg0HMaAoVqt3DlMibZJe3yEQ";
     gender = 1;
     location = "CN, Beijing, Haidian";
     openid = ovRnRvk9UtPSaJdcAO8rdUpJBck4;
     "profile_image_url" = "http://wx.qlogo.cn/mmopen/ibkKkoaQFco72rgV6P6XsAGylerquygPVsHJFk17537vXewmIpZ7n47Hjdh4vXUaiaLopzmmkg7MM2MQzHU8kCLQ/0";
     "screen_name" = "\U653b\U57ce\U72eeProgrammerMonkey";
     }
     

     snsAccount is {
     accessToken = 9487157B01E3F42075F11599F5732AE3;
     expirationDate = "2015-10-25 05:37:04 +0000";
     iconURL = "http://q.qlogo.cn/qqapp/1104642871/DC2437D89FC82578A4AD5E0C6A1DE928/100";
     platformName = qq;
     profileURL = "";
     userName = "\U5f20\U8d85";
     usid = DC2437D89FC82578A4AD5E0C6A1DE928;
     }
     SnsInformation is ？{
     "access_token" = 9487157B01E3F42075F11599F5732AE3;
     gender = "\U7537";
     openid = DC2437D89FC82578A4AD5E0C6A1DE928;
     "profile_image_url" = "http://qzapp.qlogo.cn/qzapp/1104642871/DC2437D89FC82578A4AD5E0C6A1DE928/100";
     "screen_name" = "\U5f20\U8d85";
     uid = DC2437D89FC82578A4AD5E0C6A1DE928;
     verified = 0;
     }
     
     
     snsAccount is {
     accessToken = "2.00joMe6C03t9ZI40026b29959npZcD";
     expirationDate = "2015-08-03 19:00:00 +0000";
     iconURL = "http://tp2.sinaimg.cn/2211256457/180/0/1";
     platformName = sina;
     profileURL = "http://www.weibo.com/u/2211256457";
     userName = ssssssss1102010;
     usid = 2211256457;
     }
     SnsInformation is ？{
     "access_token" = "2.00joMe6C03t9ZI40026b29959npZcD";
     description = "";
     "favourites_count" = 0;
     "followers_count" = 8;
     "friends_count" = 12;
     gender = 1;
     location = "\U5176\U4ed6";
     "profile_image_url" = "http://tp2.sinaimg.cn/2211256457/180/0/1";
     "screen_name" = ssssssss1102010;
     "statuses_count" = 15;
     uid = 2211256457;
     verified = 0;
     }

     */


/**
 *  找回密码点击跳转方法
 */
-(void)findClick
{

    NSLog(@"找回密码！");
    
    //设置按钮的字体颜色切换
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置按钮的字体颜色切换
    [self.registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    //跳转找回密码VC
    
    FindPWDViewController *findVC = [[FindPWDViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
}


/**
 *  登陆按钮点击事件
 */
-(void)loginClick
{
    [self touchesBegan:nil withEvent:nil];
    //登陆请求的参数 verState为自己定义的登陆状态方便后面的接受方查看请求接口类型是登陆login 或者register 或者sendCode
    NSDictionary *dic = @{@"verState":@"login",
                          @"PhoneNum": self.phoneNumTF.text,
                          @"Password":self.PwdTF.text};
    [SVProgressHUD show];
    
    //请求验证，该方法主要做页面逻辑数据是否合理判断，内部再调用web请求
    [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
    
        //返回值为1001时为登陆成功
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001  && ![[obj objectForKey:@"Data"] isEqual:[NSNull null]]) {
            //跳转到WebViewVC
            WebViewViewController *webVC = [[WebViewViewController alloc] init];
            webVC.userInfo.userId = self.phoneNumTF.text;
            webVC.userInfo.userToken = [[obj objectForKey:@"Data"] objectForKey:@"access_token"];
            [self.navigationController pushViewController:webVC animated:YES];
            [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
            
            NSLog(@"%@",webVC.userInfo.userId);
            
            //登陆成功清空页面数据，否则返回后依然存在
            self.phoneNumTF.text = @"";
            self.PwdTF.text = @"";
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"登陆失败！手机号或密码错误！"];
        }
        
    }];
    
    //设置按钮的字体颜色切换
    [self.loginBtn setTitleColor:[ZZCPrivateClass colorWithHexString:@"#00b496"] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[ZZCPrivateClass colorWithHexString:@"#333333"] forState:UIControlStateNormal];
}

/**
 *  注册按钮点击事件
 */
-(void)registerClick
{
    //设置按钮的字体颜色切换
    [self.registerBtn setTitleColor:[ZZCPrivateClass colorWithHexString:@"#00b496"] forState:UIControlStateNormal];
    
    //跳转注册VC
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.loginBtn setTitleColor:[ZZCPrivateClass colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.navigationController pushViewController:registerVC animated:YES];
}

/**
 *  触摸屏幕任意点触发事件
 *  收起键盘
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumTF resignFirstResponder];
    [self.PwdTF resignFirstResponder];
}

#pragma mark 键盘return事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginClick];
    return YES;
}


/*
 ZZCPrivateClass.m : 39	getrealTime: 2015-08-31 07:16:15 +0000
 UserLoginWebRequestLogic.m : 68	a7a4624632db777f72ec27cf8500ca26
 UserLoginWebRequestLogic.m : 100	本次请求参数{
 AppId = TuJi;
 DeviceId = 2a8b70fd8754e223e3de9397e0f719e3482b8723863be32b9789c7611be9f049;
 Password = a7a4624632db777f72ec27cf8500ca26;
 PhoneNum = 13121139427;
 System = iOS;
 Time = "2015-08-31 15:16:15";
 }
 UserLoginWebRequestLogic.m : 144	servesUrlhttp://m.tuji.linkdow.net/api/Account/Login
 UserLoginWebRequestLogic.m : 127	第三层返回打印成功
 UserLoginWebRequestLogic.m : 128	{
 Data =     {
 "access_token" = "KXz3gNm9h7CspoTEpK07173fyjSLfnB7ImFlEdZ3HRYK5hJjMZOZEwiFP-qZf8_Z_sbYKOyZ4wIPf0AUmeWrlSqR4MlE-G_Er1xXqcDWyjvO-Mizsqo_jSABBp_ag0U2UGr8Gmmg9AryU73sWxrBCiPNWv131e1Ieg8c-hNtNuRaJ6gyzjNGXvaUm8OFNHGQ8m885L0OHNHi9Ca00SDvjJPtlUD_Of0zQ5vaTifbbuhgKpzYBq31Gczqeb2hc8TJvgCOZxvLq5r-B1rW47U-v0XkxjvFNZTjDo0jeEnJwIGVPlqlcrsozYGZQUSntj8uxsNCSyqwUc3tNUu9cRo0WWXVSfiCW0jHeBOXR5hVmYA";
 "expires_in" = 604800;
 "token_type" = bearer;
 };
 Message = "\U6210\U529f";
 StateCode = 1001;
 }

 */
@end
