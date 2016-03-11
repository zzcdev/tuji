
#import <Foundation/Foundation.h>

typedef void (^CallBack)(id obj);
@interface UserLoginWebRequestLogic : NSObject
+(void)verDictionary:(NSDictionary *)dic callBack:(CallBack)back;
@end
