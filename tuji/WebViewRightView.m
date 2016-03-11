
#import "WebViewRightView.h"
#import "ZZCPrivateClass.h"

#define BUTTON_X SCREEN_WIDTH-200
#define BUTTON_HEIGHT SCREEN_HEIGHT*0.08405344

@implementation WebViewRightView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 9; i++) {
            
            UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, BUTTON_HEIGHT*i+SCREEN_HEIGHT*0.04594656, self.frame.size.width, BUTTON_HEIGHT)];
            [testBtn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
            [testBtn setTitleColor:[ZZCPrivateClass colorWithHexString:@"#00b496"] forState:UIControlStateNormal];
            
            testBtn.tag = i;
            if (i<8) {
                
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.04807742, BUTTON_HEIGHT*i+BUTTON_HEIGHT+SCREEN_HEIGHT*0.04594656, self.frame.size.width-SCREEN_WIDTH*0.04807742*2, SCREEN_HEIGHT*0.002)];
                lineLabel.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];
                [self addSubview:lineLabel];

            }
            
            switch (i) {
                case 0:
                    [testBtn setTitle:@"我的记录" forState:UIControlStateNormal];
                    break;
                case 1:
                    [testBtn setTitle:@"我的发表" forState:UIControlStateNormal];
                    break;
                case 2:
                    [testBtn setTitle:@"我的任务" forState:UIControlStateNormal];
                    break;
                case 3:
                    [testBtn setTitle:@"我的消息" forState:UIControlStateNormal];
                    break;
                case 4:
                    [testBtn setTitle:@"我的好友" forState:UIControlStateNormal];
                    break;
                case 5:
                    [testBtn setTitle:@"我的关注" forState:UIControlStateNormal];
                    break;
                case 6:
                    [testBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
                    break;
                case 7:
                    [testBtn setTitle:@"我的评论" forState:UIControlStateNormal];
                    break;
                case 8:
                    [testBtn setTitle:@"公共频道" forState:UIControlStateNormal];
                    break;
            }
            
            [self addSubview:testBtn];
        }
    }
    
    UILabel *linLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2, SCREEN_HEIGHT)];
    
    linLeft.backgroundColor = [ZZCPrivateClass colorWithHexString:@"#00b496"];//16ab90
    [self addSubview:linLeft];
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.841-SCREEN_WIDTH*0.252, SCREEN_HEIGHT*0.939, SCREEN_WIDTH*0.064, SCREEN_HEIGHT*0.036)];
    
    [setBtn setImage:[UIImage imageNamed:@"右边栏-设置.png"] forState:UIControlStateNormal];
    
    [setBtn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
    setBtn.tag = 9;
    
    [self addSubview:setBtn];
    
    return self;
}

-(void)testClick:(UIButton *)sender
{
    NSString *servesUrl = [ZZCPrivateClass getServersUrl];
    NSLog(@"测试刷新webview %ld",(long)sender.tag);
    switch (sender.tag) {
        case 0:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//myrecord.html"];
            break;
        case 1:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//myreport.html"];
            break;
        case 2:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//mytask.html"];
            break;
        case 3:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//mynews.html"];
            break;
        case 4:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//myfriend.html"];
            break;
        case 5:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//myattention.html"];
            break;
        case 6:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//mycollection.html"];
            break;
        case 7:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//mycomment.html"];
            break;
        case 8:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//public.html"];
            break;
        case 9:
            servesUrl = [servesUrl stringByAppendingString:@"TuJiApp//set.html"];
            break;

    }
    [self.delegate sendRequest:servesUrl];
}
@end
