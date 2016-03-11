
#import "CustomBackBarButton.h"
@implementation CustomBackBarButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 60, 40);
        UIImageView *backIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录注册-左上角返回.png"]];
        backIV.frame = CGRectMake(0, 8, 15, 25);
        [self addSubview:backIV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 40, 30)];
        label.text = @"返回";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
    }
    return self;
}
@end
