
#import "CustomWebView.h"
#import "SVProgressHUD.h"
@interface CustomWebView ()
@property (nonatomic,strong)UIAlertView *alertView;
@end

@implementation CustomWebView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
#if 0
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *menuItemBUDUI1 = [[UIMenuItem alloc] initWithTitle:@"paste" action:@selector(paste:)];
        NSArray *mArray = [NSArray arrayWithObjects:menuItemBUDUI1, nil];
        
        [menu setMenuItems:nil];
#endif
    }
    return self;
}

- (void)paste:(id)sender
{
    // PASTE TODO
    [SVProgressHUD showErrorWithStatus:@"一定要黏贴我哦"];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) {
        return YES;
    }
    if (action == @selector(select:)) {
        return YES;
    }
    if (action == @selector(selectAll:)) {
        return NO;
    }
    return NO;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self];
//    NSLog(@"%f",touchPoint.x);
//
//    [UIView animateWithDuration:2 animations:^{
//        self.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
//    }];
//}
@end