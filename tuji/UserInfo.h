
#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *userToken;
@property (nonatomic,strong)NSString *userImg;
@property (nonatomic,copy)NSString *webViewUrl;
@property (nonatomic,strong)NSString *userPhoneNum;
/**
 *  编辑页文件列表List
 */
@property (nonatomic,strong)NSMutableDictionary *fileList;

@property (nonatomic,strong)NSMutableDictionary *httpList;
+ (UserInfo *)sharedUserInfo;
@end
