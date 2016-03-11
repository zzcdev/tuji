
#import <UIKit/UIKit.h>
#import "CustomWebView.h"
#import "UserInfo.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface WebViewViewController : UIViewController
@property (nonatomic)BOOL isLoginByQQ;
@property (nonatomic,strong)UserInfo *userInfo;
@property (nonatomic,strong)NSString *loadURL;
@end
