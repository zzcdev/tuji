
#import <Foundation/Foundation.h>
#import "CustomWebViewProtocol.h"

@interface Recorder : NSObject

@property (nonatomic,strong)id <CustomWebViewProtocol>delegate;
@property (nonatomic,strong)NSString *fileName;


-(void)recorderStarSavePath;
-(void)recorderStop;
-(void)playRecorderWithUrl:(NSString *)url;
-(void)recorderPause;
-(void)recorderGoonPlaying;
-(void)recorderStopPlaying;
@end
