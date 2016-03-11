

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#import "AuthorizeVC.h"
#import "WebViewViewController.h"
#import "UserLoginLogic.h"
#import "SVProgressHUD.h"
#import "BaseVC.h"
@interface AuthorizeVC ()
@end
@implementation AuthorizeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    self.fd_prefersNavigationBarHidden = YES;
    NSLog(@"二维码扫描结果%@",self.result);
}

-(void)createUI
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    iv.image = [UIImage imageNamed:@"70.授权页面.jpg"];
    [self.view addSubview:iv];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.0966183574879227, SCREEN_HEIGHT*0.4456521739130435,SCREEN_WIDTH-SCREEN_WIDTH*0.0966183574879227*2, SCREEN_HEIGHT*0.078804347826087)];
    [loginBtn addTarget:self action:@selector(loginByAuthorize) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loginBtn];

    UIButton *loginBtnCancel = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.0966183574879227, SCREEN_HEIGHT*0.577445652173913,SCREEN_WIDTH-SCREEN_WIDTH*0.0966183574879227*2, SCREEN_HEIGHT*0.078804347826087)];
    [loginBtnCancel addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    loginBtnCancel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loginBtnCancel];
}

-(void)loginByAuthorize
{
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"verState":@"erweima",
                          @"Authorization":[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],
                          @"qrcode":self.result};
#pragma mark  自动登录 AutoLogin
    [UserLoginLogic verDictionary:dic backBlock:^(id obj) {
        
        if ([[obj objectForKey:@"StateCode"] intValue] == 1001)
        {
            [SVProgressHUD showSuccessWithStatus:@"授权成功！"];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"授权失败！"];
        }
    }];
}

-(void)cancelBtn
{
    [SVProgressHUD showErrorWithStatus:@"取消授权！"];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end