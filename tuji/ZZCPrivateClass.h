
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PUSH_MESSAGE_NOTIFICATION @"pushmessagenotification" 
#define PUSH_ADDFRIEND_NOTIFICATION @"pushaddfriendnotification"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UMSocial.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
@interface ZZCPrivateClass : NSObject

/**
 *  接口参数，获取当前系统时间用于
 *
 *  @return dateString
 */
+(NSString *)getLocalTime;

/**
 *  返回一个具体的真实的时间
 *
 *  @return 例:1991-05-11
 */
+(NSString *)getRealTime;

/**
 *  返回一个基于16进制的颜色
 *
 *  @return #16ab09
 */
+ (UIColor*)colorWithHexString:(NSString*)string;

/**
 *  把imageView切圆
 *
 *  @param imageView 传入需要切圆的imageView
 */
+ (void)roundImage:(UIImageView *)imageView;

/**
 *  压缩图片
 *
 *  @param image     原图
 *  @param scaleSize 压缩的尺寸（比例？）
 *
 *  @return 压缩后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/**
 *  获取手机设备信息
 *
 *  @return 系统名和系统版本
 */
+(NSString *)getDevice;

/**
 *  获得应用标识
 *
 *  @return 应用标识，版本？
 */
+(NSString *)getAppId;

/**
 *  根据 参数 创建一个用户文件夹
 *
 *  @param folderName 文件夹名称
 */
+(NSString *)createUserFileByName:(NSString *)fileName andData:(NSData *)data;

/**
 *  根据参数 返回一个文件的沙盒路径
 *
 *  @param fileUrl 服务器传递的文件guid
 *
 *  @return 返回文件沙盒路径
 */
+(NSString *)getFilePathByStr:(NSString *)fileUrl;

/**
 *
 */
+(NSString *)getFileDirectoryByFileGuid:(NSString *)fileGuid;

/**
 *  获得guid
 *
 *  @return guid
 */
+(NSString *)getGuid;

/**
 *  获得服务器根地址：http://118.194.132.115:8086/  &&  http://118.194.132.115:8087/
 */
+(NSString *)getServersUrl;

/**
 *  获取手机通讯录，返回通讯录符合条件的电话号字符串以,分隔
 */
+(NSString *)getAllPhonesNum;

@end
