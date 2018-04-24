//
//  TimerViewController.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/23.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()

@property(nonatomic, strong)UILabel *lab;
@property(nonatomic, strong)UIButton *btnTimer;
@property(nonatomic, strong)UIButton *btnCADisplayLink;
@property(nonatomic, strong)UIButton *btnGCD;
@property(nonatomic, strong)CADisplayLink *displayLink;
@property(nonatomic, assign)int count;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 188, 44)];
    _lab.backgroundColor = [UIColor redColor];
    _btnTimer = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, 88, 44)];
    _btnTimer.backgroundColor = [UIColor redColor];
    [_btnTimer addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
    _count=0;
    [self.view addSubview:_lab];
    [self.view addSubview:_btnTimer];
}

- (void)setCount:(int)count{
    _count = count;
    _lab.text = [NSString stringWithFormat:@"-%d-",_count];
}

- (void) clickMe:(id)sender{
    [self startDisplayLink];
    
//    NSTimeInterval period = 1.0; //设置时间间隔
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        NSLog(@"%d",_count);
//        self.count = _count+1;
//    });
//    dispatch_resume(_timer);
}

- (void)startDisplayLink{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    //self.displayLink.duration = 1;
    self.displayLink.paused = NO;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink{
    //do something
    NSLog(@"%d",_count);
    self.count = _count+1;
}

- (void)stopDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
