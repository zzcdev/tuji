
#define SELF_WIDTH self.frame.size.width
#define SELF_HEIGHT self.frame.size.height
#define BTN_SPACE (SELF_WIDTH/4-50)/2

#import "ShareToView.h"
#import "UMSocial.h"

@interface ShareToView ()

@end

@implementation ShareToView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.layer.cornerRadius = 10;
        
        
        //发给好友按钮
        UIButton *sendToFriend = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SELF_WIDTH/2, 50)];
        [sendToFriend setTitle:@"发给好友" forState:UIControlStateNormal];
        sendToFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [sendToFriend addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        sendToFriend.tag = 101;
        [self addSubview:sendToFriend];
        
        //复制链接按钮
        UIButton *copyLink = [[UIButton alloc] initWithFrame:CGRectMake(SELF_WIDTH/2, 0, SELF_WIDTH/2, 50)];
        [copyLink setTitle:@"复制链接" forState:UIControlStateNormal];
        copyLink.titleLabel.textAlignment = NSTextAlignmentCenter;
        [copyLink addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        copyLink.tag = 102;
        [self addSubview:copyLink];
        
        //Label分享到
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SELF_WIDTH, 30)];
        shareLabel.text = @"分享到";
        shareLabel.font = [UIFont systemFontOfSize:16];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.textColor = [UIColor whiteColor];
        [self addSubview:shareLabel];
        //两条横竖线
        UILabel *lineH = [[UILabel alloc] initWithFrame:CGRectMake(SELF_WIDTH/2, 8, 1, 34)];
        lineH.backgroundColor = [UIColor whiteColor];
        lineH.alpha = 0.7;
        [self addSubview:lineH];
        
        UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(8, 50, SELF_WIDTH-16, 1)];
        lineV.backgroundColor = [UIColor whiteColor];
        lineV.alpha = 0.7;
        [self addSubview:lineV];

        
        //分享按钮
        UIButton *shareToQQ = [[UIButton alloc] initWithFrame:CGRectMake(BTN_SPACE, SELF_HEIGHT/2-25, 50, 50)];
        [shareToQQ setImage:[UIImage imageNamed:@"扣扣.png"] forState:UIControlStateNormal];
        [shareToQQ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        shareToQQ.tag = 1;
        [self addSubview:shareToQQ];
        
        UIButton *shareToWX = [[UIButton alloc] initWithFrame:CGRectMake(BTN_SPACE*3+50, SELF_HEIGHT/2-25, 50, 50)];
        [shareToWX setImage:[UIImage imageNamed:@"微信.png"] forState:UIControlStateNormal];
        [shareToWX addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        shareToWX.tag = 2;
        [self addSubview:shareToWX];

        
        UIButton *shareToSession = [[UIButton alloc] initWithFrame:CGRectMake(BTN_SPACE*5+100, SELF_HEIGHT/2-25, 50, 50)];
        [shareToSession setImage:[UIImage imageNamed:@"微信朋友圈.png"] forState:UIControlStateNormal];
        [shareToSession addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        shareToSession.tag = 3;
        [self addSubview:shareToSession];

        
        UIButton *shareToWB = [[UIButton alloc] initWithFrame:CGRectMake(BTN_SPACE*7+150, SELF_HEIGHT/2-25, 50, 50)];
        [shareToWB setImage:[UIImage imageNamed:@"新浪微博.png"] forState:UIControlStateNormal];
        shareToWB.alpha = 1;
        [shareToWB addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        shareToWB.tag = 4;
        [self addSubview:shareToWB];
        
        //取消按钮
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SELF_HEIGHT-50, SELF_WIDTH, 50)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.alpha = 0.9;
        cancelBtn.layer.cornerRadius = 10;
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag = 5;
        [self addSubview:cancelBtn];
    }
    return self;
}

-(void)btnClick:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    [self.delegate shareToSNS:sender.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
