
#import "AppDelegate.h"
#import "ViewController.h"

#pragma mark import友盟Social
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMessage.h"
#import <AVFoundation/AVFoundation.h>
#import "ZZCPrivateClass.h"
#import "WebViewViewController.h"
#import "UserInfo.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // Override point for customization after application launch.
    [UMSocialData setAppKey:@"557f7b0567e58eaf51002a5d"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104642871" appKey:@"5cd4CnoEH7WCbJUQ" url:@"https://www.baidu.com/"];
    
    
    [UMSocialWechatHandler setWXAppId:@"wx8b3a7b8c2d19c7cb" appSecret:@"5bc86ed7d5b28b62fc1993c1077d8b83" url:@"https://www.baidu.com/"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatTimeline, UMShareToWechatTimeline]];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"557f7b0567e58eaf51002a5d" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#endif
    //for log
    [UMessage setLogEnabled:YES];

    
    [SVProgressHUD setForegroundColor:[ZZCPrivateClass colorWithHexString:@"#00b496"]];
    //    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:20]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"推送.png"]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"错误提示(1)"]];
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"%lu",(unsigned long)userInfo.count);
    if (userInfo.count) {
        NSString *infoValue = [userInfo objectForKey:@"url"];
        [UserInfo sharedUserInfo].webViewUrl = infoValue;
        
        ViewController *vc = [[ViewController alloc]init];
        UINavigationController *nvi = [[UINavigationController alloc]initWithRootViewController:vc];
        nvi.navigationBar.barTintColor = [ZZCPrivateClass colorWithHexString:@"#16ab90"];
        self.window.rootViewController = nvi;
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    else
    {
        [UserInfo sharedUserInfo].webViewUrl = @"TuJiApp/edit.html";
        ViewController *vc = [[ViewController alloc]init];
        UINavigationController *nvi = [[UINavigationController alloc]initWithRootViewController:vc];
        nvi.navigationBar.barTintColor = [ZZCPrivateClass colorWithHexString:@"#16ab90"];
        self.window.rootViewController = nvi;
    }
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"deviceToken ben.%@\ndeviceToken.end\n",deviceTokenString);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"deviceTokenString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken success");
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    NSString *error_str = [NSString stringWithFormat: @"%@", err];
    NSLog(@"Failed to get token, error:%@", error_str);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    //    [UMessage setAutoAlert:NO];
    
    NSLog(@"be.接收到的推送消息%@.end",userInfo);
    /*
     AppDelegate.m : 116	be.接收到的推送消息{
     aps =     {
     alert = infotest;
     badge = 8;
     category = gategoryid;
     sound = default;
     };
     d = uu66222143833574179611;
     "http://setfriends" = "http://setfriendssetheadphoto";
     p = 0;
     }.end
     */
    
    NSString *infoValue = [userInfo objectForKey:@"url"];
    NSLog(@"%@",infoValue);
    UserInfo *uf        = [UserInfo sharedUserInfo];
    uf.webViewUrl       = infoValue;
    
    ViewController *vc             = [[ViewController alloc]init];
    UINavigationController *nvi    = [[UINavigationController alloc]initWithRootViewController:vc];
    nvi.navigationBar.barTintColor = [ZZCPrivateClass colorWithHexString:@"#16ab90"];
    self.window.rootViewController = nvi;
    
    
//    NSNotification *pushNotification = [[NSNotification alloc] initWithName:PUSH_MESSAGE_NOTIFICATION object:self userInfo:userInfo];
//    [[NSNotificationCenter defaultCenter] postNotification:pushNotification];
    
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation{
//    return YES;
//}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
