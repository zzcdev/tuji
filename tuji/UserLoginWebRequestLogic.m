
#import "UserLoginWebRequestLogic.h"
#import "ZZCPrivateClass.h"
#import "NSString+md5.h"
@implementation UserLoginWebRequestLogic
+(void)verDictionary:(NSDictionary *)dic callBack:(CallBack)back
{
    //afnetworking 方法manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *servesUrl = [ZZCPrivateClass getServersUrl];
    
    
    //从参数体里获得请求状态是什么 login register cendCode
    NSString *verState = [dic objectForKey:@"verState"];
    
    //最终用于请求的参数
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    //post方法参数  参数单独字典  剔除状态    verState   值
    [dicts removeObjectForKey:@"verState"];
    [dicts setValue:[ZZCPrivateClass getAppId] forKey:@"AppId"];
    [dicts setValue:[ZZCPrivateClass getRealTime] forKey:@"Time"];
    [dicts setValue:@"iOS" forKey:@"System"];
    
//    [dicts setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenString"] forKey:@"DeviceId"];
//    [dicts setValue:@"99443a507a1ecac2e62cdf9a1c3ec6fd07e4bce66f89147cdea26a05fe707ff4" forKey:@"DeviceId"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenString"]) {
        [dicts setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenString"] forKey:@"DeviceId"];
    }
    else
    {
        [dicts setValue:[ZZCPrivateClass getDevice] forKey:@"DeviceId"];
    }

    
    
    //发送注册验证码
    if ([verState isEqualToString:@"sendCode"]) {
        
        //get方法参数  参数在拼接地址内
        //    servesUrl = [servesUrl stringByAppendingString:@"api/ValidateCode/Get?phoneNum=13121139427&action=0&time=2015-06-18 19:30:54&AppId=TuJi"];
        
        
#pragma mark  发送验证码
        
        servesUrl = [servesUrl stringByAppendingString:@"api/ValidateCode/Get"];
        
    }else if ([verState isEqualToString:@"verCode"]){
        
        
        [dicts removeObjectForKey:@"Password"];
        
#pragma mark   验证验证码
        servesUrl = [servesUrl stringByAppendingString:@"api/ValidateCode/Validate"];
        
    }else if ([verState isEqualToString:@"register"]){
        
#pragma mark 注册     register
        servesUrl = [servesUrl stringByAppendingString:@"api/Account/Registered"];
        
        NSString *md5PWD = [dicts objectForKey:@"Password"];
        md5PWD = [md5PWD md5String];
        md5PWD = [NSString stringWithFormat:@"%@tuji%@",md5PWD,[dicts objectForKey:@"PhoneNum"]];
        md5PWD = [md5PWD md5String];
        [dicts setObject:md5PWD forKey:@"Password"];
    }else if ([verState isEqualToString:@"login"]){
        
#pragma mark 登陆     login
        servesUrl = [servesUrl stringByAppendingString:@"api/Account/Login"];
        
        
        NSString *md5PWD = [dicts objectForKey:@"Password"];
        md5PWD = [md5PWD md5String];
        md5PWD = [NSString stringWithFormat:@"%@tuji%@",md5PWD,[dicts objectForKey:@"PhoneNum"]];
        md5PWD = [md5PWD md5String];
        [dicts setObject:md5PWD forKey:@"Password"];
        NSLog(@"%@",md5PWD);
    }else if ([verState isEqualToString:@"findPWD"]){
        
#pragma mark 找回密码   findPWD
        servesUrl = [servesUrl stringByAppendingString:@"api/Account/ResetPassword"];
        
        NSString *md5PWD = [dicts objectForKey:@"Password"];
        md5PWD = [md5PWD md5String];
        md5PWD = [NSString stringWithFormat:@"%@tuji%@",md5PWD,[dicts objectForKey:@"PhoneNum"]];
        md5PWD = [md5PWD md5String];
        [dicts setObject:md5PWD forKey:@"Password"];
        
    }else if ([verState isEqualToString:@"AutoLogin"]){
        
#pragma mark 自动登录   AutoLogin
        servesUrl = [servesUrl stringByAppendingString:[NSString stringWithFormat:@"api/Account/AutoLogin?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]] ];
        
    }else if ([verState isEqualToString:@"uploadPhones"]){
        
#pragma mark 上传手机通讯录  personPhones
        servesUrl = [servesUrl stringByAppendingString:@"api/Me/AddPhoneContact"];
        
    }else if ([verState isEqualToString:@"erweima"]){
        
#pragma mark 二维码扫描登陆
        servesUrl = [servesUrl stringByAppendingString:@"api/account/LoginByQrCode"];
    }else if ([verState isEqualToString:@"SFlogin"]){
        
#pragma mark 三方登陆
        servesUrl = [servesUrl stringByAppendingString:@"api/account/OtherLogin"];
    }
    
    NSLog(@"本次请求参数%@",dicts);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    
    
    if ([verState isEqualToString:@"AutoLogin"])
    {
        manager.requestSerializer.timeoutInterval = 3;  //4比较合理 ，1体验最好
        //2.afnetworking get 方法
        [manager GET:servesUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@,%@",[responseObject objectForKey:@"Message"],responseObject);
            back(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error%@",error);
            NSDictionary *dic = @{@"error": error};
            back(dic);
        }];
    }
    else
    {
        manager.requestSerializer.timeoutInterval = 12;
        //1.afnetworking  post 方法
        [manager POST:servesUrl parameters:dicts success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"第三层返回打印%@",[responseObject objectForKey:@"Message"]);
            NSLog(@"%@",responseObject);
            back(responseObject);
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"第三层返回打印错误%@",error);
             [SVProgressHUD dismiss];
             [SVProgressHUD showErrorWithStatus:@"网络请求失败！！"];
         }];
        
        /*
         -[__NSCFString containsString:]: unrecognized selector sent to instance 0x1456f770
         WebKit discarded an uncaught exception in the webView:decidePolicyForNavigationAction:request:frame:decisionListener: delegate: <NSInvalidArgumentException> -[__NSCFString containsString:]: unrecognized selector sent to instance 0x1456f770
         
         */
    }
    NSLog(@"servesUrl%@",[[servesUrl componentsSeparatedByString:@"="] firstObject]);
    
    //    原生 post
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:servesUrl]];
    
    //    [request setValue:@"" forHTTPHeaderField:];
    //    [request setHTTPBody:[servesUrl dataUsingEncoding:NSUTF8StringEncoding]];
    //    [request setHTTPMethod:@"POST"];
    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //        NSLog(@"%@",dic);
    //        back(dic);
    //    }];
    
    
    //原生get
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:servesUrl]];
    //    [request setHTTPMethod:@"GET"];
    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
    //        NSLog(@"data%@,dic%@",data,dic);
    //        
    //    }];
}
//18612233996

//（MD5(MD5(密码)+tuji+PhoneNum)）
@end