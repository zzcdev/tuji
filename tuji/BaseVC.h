
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomWebViewProtocol.h"
@interface BaseVC : UIViewController
//代理传值
@property (strong, nonatomic) id<CustomWebViewProtocol>delegate;
@end
