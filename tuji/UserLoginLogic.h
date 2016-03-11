
#import <Foundation/Foundation.h>

typedef void(^BackBlock) (id obj);
@interface UserLoginLogic : NSObject

/**
 *  验证页面逻辑以及调用web请求
 *
 *  @param dic       web请求的参数体
 *  @param backBlock 返回 web请求的 返回值
 */
+(void)verDictionary:(NSDictionary *)dic backBlock:(BackBlock)backBlock;
@end
