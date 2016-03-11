
#import "ZZCPrivateClass.h"
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>

@interface ZZCPrivateClass ()
@property (nonatomic,strong)NSFileManager *fileManager;
@end

@implementation ZZCPrivateClass

-(NSFileManager *)fileManager
{
    if (!self.fileManager) {
        
        self.fileManager = [[NSFileManager alloc] init];
    }
    return self.fileManager;
}

+(NSString *)getLocalTime{
    NSDate* date = [NSDate date];
    // NSString* ds = [NSString stringWithFormat:@"\/Date(%ld)\/",(NSInteger)[date timeIntervalSince1970]];
    //日期格式化
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateString = [formatter stringFromDate:date];
    
    
    NSTimeInterval count = [date timeIntervalSince1970]*1000+3600*8*1000;
    
    dateString = [NSString stringWithFormat:@"/Date(%ld)/",(long)count];
    
    return dateString;
}

+(NSString *)getRealTime{
    NSDate* date = [NSDate date];
    NSLog(@"getrealTime: %@",date);
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}


+(UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(void)roundImage:(UIImageView *)imageView
{
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


+(NSString *)getDevice
{
    UIDevice* device = [[UIDevice alloc]init];
    //NSString* sysVersion = [NSString stringWithFormat:@"%@%@",device.systemName,device.systemVersion];
    NSString *sysIdentifer = [NSString stringWithFormat:@"%@",device.identifierForVendor.UUIDString];
    return sysIdentifer;
}

+(NSString *)getAppId
{
    return @"TuJi";
}

+(NSString *)createUserFileByName:(NSString *)fileName andData:(NSData *)data
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *floderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    
    
    NSString *fileNameGuid = [self getGuid];
    NSString *filePath;
    if (![fileManager fileExistsAtPath:floderPath]) {
        
        [fileManager createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"image"] withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"video"] withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"recorder"] withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"draw"] withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"用户根路径内容%@，三个文件创建是否成功%@",floderPath,[fileManager contentsOfDirectoryAtPath:floderPath error:nil]);
        
        return nil;
    }
    else if ([fileName rangeOfString:@"image"].length)
    {
        fileNameGuid = [NSString stringWithFormat:@"img_%@",fileNameGuid];
        filePath = [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image/%@.jpg",fileNameGuid]];
        NSLog(@"图片文件路径%@",[fileManager contentsOfDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"image"] error:nil]);
    }
    else if ([fileName rangeOfString:@"recorder"].length)
    {
        fileNameGuid = [NSString stringWithFormat:@"aud_%@",fileNameGuid];
        filePath = [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"recorder/%@.mp3",fileNameGuid]];
        NSLog(@"录音文件路径%@",filePath);
    }
    else if ([fileName rangeOfString:@"draw"].length)
    {
        fileNameGuid = [NSString stringWithFormat:@"drw_%@",fileNameGuid];
        filePath = [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"draw/%@.jpg",fileNameGuid]];
        NSLog(@"画板文件路径%@",filePath);
    }
    else if ([fileName rangeOfString:@"video"].length)
    {
        
        fileNameGuid = [NSString stringWithFormat:@"vdo_%@",fileNameGuid];
        filePath = [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"video/%@.mp4",fileNameGuid]];
        
        NSLog(@"录像文件路径%@",filePath);
    }
    if (data)
    {
        
        [data writeToFile:filePath atomically:YES];
        [[UserInfo sharedUserInfo].fileList setValue:filePath forKey:fileNameGuid];
        NSLog(@"当前UserInfo里的内容%@",[UserInfo sharedUserInfo].fileList);
        //        [fileManager createFileAtPath:filePath contents:data attributes:nil];
        
    }
    
    NSLog(@"floderPath:%@用户名下文件夹%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"],[fileManager contentsOfDirectoryAtPath:floderPath error:nil]);
    
    NSLog(@"用户video文件夹内容%@",[fileManager contentsOfDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"video"] error:nil]);
    
    NSLog(@"用户image文件夹内容%@",[fileManager contentsOfDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"image"] error:nil]);
    
    NSLog(@"用户recorder文件夹内容%@",[fileManager contentsOfDirectoryAtPath:[floderPath stringByAppendingPathComponent:@"recorder"] error:nil]);
    return fileNameGuid;
}

+(NSString *)getFilePathByStr:(NSString *)fileUrl
{
    
    NSString *fileName = [[fileUrl componentsSeparatedByString:@"&"] firstObject];
    fileName = [[fileName componentsSeparatedByString:@"="] lastObject];
    NSLog(@"本次分解的上传文件名%@",fileName);
    NSString *userFilePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"userFilePath"];
    if ([fileName hasPrefix:@"img_"]) {
        fileName = [userFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image/%@.jpg",fileName]];
    }else if ([fileName hasPrefix:@"aud_"]){
        fileName = [userFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"recorder/%@.mp3",fileName]];
    }else if ([fileName hasPrefix:@"vdo_"]){
        fileName = [userFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"video/%@.mp4",fileName]];
    }
    NSLog(@"fileName = %@",fileName);
    return fileName;
}

+(NSString *)getFileDirectoryByFileGuid:(NSString *)fileGuid
{
    NSString *fileURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"userFilePath"];
    NSLog(@"一%d,%@,",[[NSFileManager defaultManager] fileExistsAtPath:fileURL],fileURL);
    
    if ([fileGuid hasPrefix:@"img_"]) {
        fileURL = [fileURL stringByAppendingPathComponent:@"image"];
    }else if ([fileGuid hasPrefix:@"vdo_"]){
        fileURL = [fileURL stringByAppendingPathComponent:@"video"];
    }else if ([fileGuid hasPrefix:@"aud_"]){
        fileURL = [fileURL stringByAppendingPathComponent:@"recorder"];
    }else if ([fileGuid hasPrefix:@"drw_"]){
        fileURL = [fileURL stringByAppendingPathComponent:@"draw"];
    }
    NSLog(@"二%d,%@",[[NSFileManager defaultManager] fileExistsAtPath:fileURL],fileGuid);
    return fileURL;
}

+(NSString *)getGuid{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    NSLog(@"uuid__%@",uuid);
    return uuid;
}

+(NSString *)getServersUrl
{
    return @"http://m.tuji.linkdow.net/";
}

+(NSString *)getAllPhonesNum
{
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, &error);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    NSString *personphones;
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //读取firstname
        //        NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        //        if(personName != nil)
        //        {
        //            NSLog(@"\nkABPersonFirstNameProperty：%@\n",personName);
        //        }
        
        //        NSString *testkABPersonLastNamePhoneticProperty = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
        //        NSString *testkABPersonLastNameProperty = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        //        NSLog(@"\ntestkABPersonLastNamePhoneticProperty：%@\n",testkABPersonLastNamePhoneticProperty);
        //        NSLog(@"\ntestkABPersonLastNameProperty：%@\n",testkABPersonLastNameProperty);
        
        
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            NSLog(@"test1:%@。。。。\ntest2:%@\n",personPhoneLabel,personPhone);
            
            if (!personphones) {
                personphones = personPhone;
            }
            else
            {
                //判断手机号码格式是否正确 正则表达式
                NSString * MOBILE = @"1[3|4|5|7|8|][0-9]{9}";
                
                //验证是否匹配
                NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
                
                if ([regextestmobile evaluateWithObject:personPhone])
                {
                    
                    personphones = [personphones stringByAppendingString:[NSString stringWithFormat:@",%@",personPhone]];
                    NSLog(@"test3:%@\n",personphones);
                    
                }
                
            }
        }
    }
    NSLog(@"returnpersonPhones:%@",personphones);
    return personphones;
}

@end