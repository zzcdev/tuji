
#import <Foundation/Foundation.h>

@protocol CustomWebViewProtocol <NSObject>
-(void)sendRequest:(NSString *)url;
- (void)saveImage:(UIImage*)image byType:(NSInteger)type;
@end
