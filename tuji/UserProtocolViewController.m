
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#import "UserProtocolViewController.h"
#import "CustomBackBarButton.h"
@interface UserProtocolViewController ()

@end

@implementation UserProtocolViewController
/**
 *  看不懂可以卸载Xcode改行了
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"用户协议";
    CustomBackBarButton *cusBck = [[CustomBackBarButton alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cusBck];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)];
    [cusBck addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 160, 40)];
    label.text = @"特别提示";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 130, SCREEN_WIDTH-20, SCREEN_HEIGHT)];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor blackColor];
    textView.text = @"滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待滴滴答答滴滴答答滴滴答答的等待";
    [self.view addSubview:textView];
}

-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
