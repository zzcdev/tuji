
#import <UIKit/UIKit.h>
#import "CustomWebViewProtocol.h"

@interface WebViewRightView : UIView
@property (nonatomic,weak)id<CustomWebViewProtocol>delegate;
@end
