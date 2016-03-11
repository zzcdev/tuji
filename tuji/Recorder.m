
#import <AVFoundation/AVFoundation.h>
#import "Recorder.h"
#import "ZZCPrivateClass.h"

#define kRecordAudioFile @"myRecord.caf"


@interface Recorder ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong)AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong)AVAudioPlayer   *audioPlayer;  //音频播放器，用于播放录音文件

@end

@implementation Recorder


#pragma mark 设置音频
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    
    return url;
}
/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

#pragma mark 点击录音开始录音
-(void)recorderStarSavePath
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
        }
    }
    
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    }
}

-(void)recorderStop
{
    
    [self.audioRecorder stop];
    NSData *recorderData = [NSData dataWithContentsOfURL:[self getSavePath]];
    
    NSLog(@"stop recorderData.length%lu",(unsigned long)recorderData.length);
    
    if (recorderData) {
        
        NSString *fileNameGuid = [ZZCPrivateClass createUserFileByName:@"recorder" andData:recorderData];
        self.audioRecorder = nil;
        [self.delegate sendRequest:fileNameGuid];
    }
}

-(void)recorderPause
{
    if (self.audioPlayer) {
        [self.audioPlayer pause];
    }
}

-(void)recorderGoonPlaying
{
    [self.audioPlayer play];
}

-(void)recorderStopPlaying
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
}



#pragma mark 点击开始播放录音文件
-(void)playRecorderWithUrl:(NSString *)url
{
    NSError *error=nil;
    
    [self setAudioSession];
    
    NSData *data = [NSData dataWithContentsOfFile:url];
    _audioPlayer=[[AVAudioPlayer alloc]initWithData:data error:&error];
    
    NSLog(@"data.length%lu",(unsigned long)data.length);
    //    _audioPlayer.numberOfLoops=1;
    _audioPlayer.delegate = self;
    if (error) {
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}
@end