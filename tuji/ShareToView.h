
#import <UIKit/UIKit.h>

@protocol shareToSNS <NSObject>

-(void)shareToSNS:(NSInteger)name;

@end

@interface ShareToView : UIView
@property (nonatomic,strong)id<shareToSNS> delegate;
@end
