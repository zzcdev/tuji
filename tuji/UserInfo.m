
#import "UserInfo.h"

@implementation UserInfo

+ (UserInfo *)sharedUserInfo
{
    static UserInfo *userInfoInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userInfoInstance = [[self alloc] init];
    });
    return userInfoInstance;
}
@end
