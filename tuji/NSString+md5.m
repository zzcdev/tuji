
#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (md5)
-(NSString*)md5String{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
    
}
@end
