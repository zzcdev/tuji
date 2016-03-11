
#import <UIKit/UIKit.h>
#import "CustomWebViewProtocol.h"
@interface DrawBoardView : UIView

@property (nonatomic,strong)id <CustomWebViewProtocol>delegate;
//初始化相关参数
////unDo
//-(void)backImage;
//
////reDo
//-(void)forwardImage;

-(void)saveClick;
@end
