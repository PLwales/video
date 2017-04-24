//
//  ViewController.m
//  video
//
//  Created by fj-zkyc on 17/4/24.
//  Copyright © 2017年 PLwales. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
{
    
    AVPlayer *player;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor  = [UIColor brownColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 120, 100);
    [button setTitle:@"AVPlayer播放" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(demo1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(240, 100, 100, 100);
    [button1 setTitle:@"控制器播放" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(demo2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}


#pragma mark ------AVPlayer播放
-(void)demo1{
    /*
     视频播放需要AVPlayer、AVPlayerItem、AVPlayerLayer
     三者的关系及作用：
     AVPlayer（视频播放器） 去播放 -> AVPlayerItem（视频播放的元素） -> AVPlayerLayer（展示播放的视图）
     
     */
    //1、创建要播放的元素
    /*
     本地的一个视频
     NSString *path = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"m4v"];
     
     AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
     */
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://183.250.3.57:8880/bei01.mp4"]];
    
    //2、创建播放器
    player = [AVPlayer playerWithPlayerItem:playerItem];
    //3、创建视频显示的图层
    AVPlayerLayer *showVodioLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    showVodioLayer.frame = self.view.frame;
    [self.view.layer addSublayer:showVodioLayer];
    //4、播放视频
    [player play];
    
    
    //获得播放结束的状态 -> 通过发送通知的形式获得 ->AVPlayerItemDidPlayToEndTimeNotification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //只要可以获得到当前视频元素准备好的状态 就可以得到总时长
    //采取KVO的形式获得视频总时长
    //通过监视status 判断是否准备好 -> 获得
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
//当status的值改变的时候会调用这个方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSLog(@"%@",change[@"new"]);
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusUnknown: {
            NSLog(@"未知状态");
            break;
        }
        case AVPlayerItemStatusReadyToPlay: {
            NSLog(@"视频的总时长%f", CMTimeGetSeconds(player.currentItem.duration));
            
            break;
        }
        case AVPlayerItemStatusFailed: {
            NSLog(@"加载失败");
            break;
        }
    }
    
    
}
//快进
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //快进
    //跳到某一个进度的方法：seekToTime:
    //得到当前的时间 + 快进的时间
    
    
    //获得当前播放的时间 （秒）
    Float64 cur =  CMTimeGetSeconds(player.currentTime);
    cur ++;
    [player seekToTime:CMTimeMake(cur, 1)];
    
}
-(void)itemDidPlayToEndTime:(NSNotification *)not{
    NSLog(@"播放结束");
    [player seekToTime:kCMTimeZero];
    
}

#pragma mark -----控制器播放

-(void)demo2{
    
    //1、创建AVPlayer
    /*
     本地视频
     NSURL *url = [[NSBundle mainBundle]URLForResource:@"IMG_9638.m4v" withExtension:nil];
     AVPlayer *player = [AVPlayer playerWithURL:url];
     */
    //网页视频
    AVPlayer *player1 = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://183.250.3.57:8880/bei01.mp4"]];
    //2、创建视频播放视图的控制器
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
    //3、将创建的AVPlayer赋值给控制器自带的player
    playerVC.player = player1;
    //4、跳转到控制器播放
    [self presentViewController:playerVC animated:YES completion:nil];
    [playerVC.player play];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
