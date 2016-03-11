
#import <UIKit/UIKit.h>
#import "CustomWebViewProtocol.h"

@interface XiutuVC : UIViewController
@property (nonatomic,strong)NSString *filePath;
@property (nonatomic,strong)id <CustomWebViewProtocol>delegate;
-(UIImage *)rotateImg:(UIImage *)img withDegree:(NSInteger)degree;
- (UIImage *)fixOrientation:(UIImage *)aImage ;
-(UIImage*)splitImage:(UIImage*)img withX:(CGFloat)X withY:(CGFloat)Y withWidth:(CGFloat) withHeight;
-(UIImage*)splitImage:(UIImage*)img;
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
@end
