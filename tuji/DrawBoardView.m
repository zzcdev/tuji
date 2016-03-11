
#import "DrawBoardView.h"
#import "ZZCPrivateClass.h"
#import "WebViewViewController.h"
@interface DrawBoardView ()
@property (nonatomic,strong)UIBezierPath *bezier;
@property (nonatomic,strong)UIButton *saveBtn;
@property (nonatomic,strong)UIButton *cancelBtn;
//记录已有线条
@property (nonatomic,strong)NSMutableArray *allLine;

@end

@implementation DrawBoardView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
        self.layer.borderColor = [[UIColor blackColor] CGColor];//设置边框的颜色
        self.layer.masksToBounds = YES;//设为NO去试试。设置YES是保证添加的图片覆盖视图的效果
        self.allLine = [NSMutableArray arrayWithCapacity:50];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void)cancelClick
{
    [self removeFromSuperview];
}

-(void)saveClick
{
    if (!self.bezier) {
        [SVProgressHUD showErrorWithStatus:@"无内容！"];
        [self.delegate saveImage:nil byType:4];

    }else
    {
        UIGraphicsBeginImageContext(self.bounds.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        //截取画图版部分
        CGImageRef sourceImageRef = [uiImage CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(36, 6, 249, 352));
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
                
        //把截的屏保存到相册
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
        
        [self.delegate saveImage:newImage byType:3];
        
        //给个保存成功的反馈
        [SVProgressHUD showSuccessWithStatus:@"画板"];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //新建贝塞尔曲线
    self.bezier = [UIBezierPath bezierPath];
    //获取触摸点
    UITouch *myTouch = [touches anyObject];
    //把触摸的点设置为贝塞尔曲线的起点
    CGPoint point = [myTouch locationInView:self];
    [self.bezier moveToPoint:point];

    [self.allLine addObject:self.bezier];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [touches anyObject];
    CGPoint point = [myTouch locationInView:self];
    [self.bezier addLineToPoint:point];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    for (int i = 0; i < self.allLine.count; i ++) {

        UIBezierPath *bezier = self.allLine[i];
        UIColor *color = [UIColor blackColor];
        [color setStroke];
        [bezier setLineWidth:5];
        [bezier stroke];
    }
}
@end