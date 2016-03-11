//
//  BaseVC.h
//  systemScanQRCode
//
//  Created by 88 on 15/1/28.
//  Copyright (c) 2015年 88. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol ScanDelegate <NSObject>
//添加代理方法（默认情况下必须实现）
- (void)setStringValue:(NSString *)stringValue;
@optional//可选的方法
- (void)saveImage:(UIImage*)image;
@end
@interface BaseVC : UIViewController
//block传值
@property (strong, nonatomic) void (^stringValue)(NSString *value);
@property(nonatomic,assign)NSInteger mode; //0为发帖 1为唱和
@property(nonatomic,copy)NSString* workID;
//代理传值
@property (strong, nonatomic) id<ScanDelegate>delegate;
@end
