
#import "UserLoginLogic.h"
#import "ZZCPrivateClass.h"
#import "UserInfo.h"
#import "UserLoginWebRequestLogic.h"

@implementation UserLoginLogic


#pragma mark 登陆 注册 找回密码 页面数据逻辑验证
+(void)verDictionary:(NSDictionary *)dic backBlock:(BackBlock)back
{
    
    //从参数体里获得请求状态是什么 login register cendCode
    NSString *verState = [dic objectForKey:@"verState"];
    if([verState isEqualToString:@"uploadPhones"] || [verState isEqualToString:@"AutoLogin"] ||[verState isEqualToString:@"erweima"]||[verState isEqualToString:@"SFlogin"])
    {
        
#pragma mark  手机通讯录上传 uploadPhones
        [UserLoginWebRequestLogic verDictionary:dic callBack:^(id obj)
         {
            back(obj);
        }];
    }
    else if ([self verPhoneNum:[dic objectForKey:@"PhoneNum"]])
    {
        //验证电话号码是否符合规则
        if ([verState isEqualToString:@"login"]||[verState isEqualToString:@"register"]||[verState isEqualToString:@"findPWD"])
        {

#pragma mark  登陆 login 注册 register 找回密码 findPWD
            //验证登陆密码是否小于6位
            if ([self verPassWord:[dic objectForKey:@"Password"] length:6])
            {
                
                //全部验证通过以后调用web请求接口请求数据
                [UserLoginWebRequestLogic verDictionary:dic callBack:^(id obj)
                 {
                    //Block返回web接口返回的数据
                    back(obj);
                }];
            }
            
        }
        else if ([verState isEqualToString:@"verCode"])
        {
#pragma mark  验证码验证  verCode
            
            if ([self verCode:[dic objectForKey:@"Code"] length:6])
            {
                if ([self verPassWord:[dic objectForKey:@"Password"] length:6])
                {
                    
                    [UserLoginWebRequestLogic verDictionary:dic callBack:^(id obj)
                     {
                        back(obj);
                    }];
                }
            }
        }
        else if([verState isEqualToString:@"sendCode"])
        {
            
#pragma mark  发送验证码 sendCode
            [UserLoginWebRequestLogic verDictionary:dic callBack:^(id obj)
            {
                back(obj);
            }];
        }
    }
}


/**
 *  判断手机号码格式是否正确
 *
 *  @param phoneNum 传入的电话号码
 *
 *  @return 正确yes 不正确no
 */
+(BOOL)verPhoneNum:(NSString *)phoneNum
{
    //判断手机号码格式是否正确 正则表达式
    NSString * MOBILE = @"1[3|4|5|7|8|][0-9]{9}";
    
    //验证是否匹配
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    //格式和长度是否一样
    if (![regextestmobile evaluateWithObject:phoneNum] || phoneNum.length != 11)
    {
        
        [SVProgressHUD dismiss];
        //如果不一样弹出警告
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
}

/**
 *  验证密码长度是否小于 6 位
 *
 *  @param passWord
 *
 *  @return 长度
 */
+(BOOL)verPassWord:(NSString *)passWord length:(NSInteger)length
{
    if (passWord.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码长度过短"];
        return NO;
    }
    return YES;
}

+(BOOL)verCode:(NSString *)passWord length:(NSInteger)length
{
    if (passWord.length < 6)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"验证码格式不正确"];
        return NO;
    }
    return YES;
}

/**
 *  检测当前网络状况
 *
 *  @return 无网络或未知网络返回no 否则返回yes
 */
+(BOOL)verReachability
{
    NSURL *baseURL = [NSURL URLWithString:@"http://baidu.com"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    static BOOL isHaveNet;
    
    //判断网络状态
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"有网络");
                isHaveNet = YES;
                break;
            default:
                [operationQueue setSuspended:YES];
                [SVProgressHUD showErrorWithStatus:@"无法访问网络，请检查！" ];
                isHaveNet = NO;
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    return isHaveNet;
}
@end
