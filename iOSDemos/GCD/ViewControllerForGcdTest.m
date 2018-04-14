//
//  ViewControllerForGcdTest.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/12.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "ViewControllerForGcdTest.h"

@interface ViewControllerForGcdTest ()

@property (nonatomic, assign) int nonatomicA;
@property (atomic, assign) int atomicA;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation ViewControllerForGcdTest

@synthesize atomicA =_atomicA;
@synthesize nonatomicA =_nonatomicA;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self limitThreadNumWith:5];
    
    [self dispatch_group_test];  // 队列组
    sleep(1);
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self testOperation];
    sleep(1);
    // 测试最大并发数 目前大约最多22062
//    int max = 100000;
//    for (int pi=0; pi<max; ++pi) {
//        [self testMaxOperationNum:pi];
//    }
//    for (int pi=0; pi<max; ++pi){
//        [self performSelectorInBackground:@selector(countForProcess:) withObject:[NSNumber numberWithInt:pi]];
//    }
    
    _atomicA=0;
    _nonatomicA=0;
    
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT); // 并发队列，异步执行
    dispatch_barrier_async(queue, ^(){});
    [self testForAtomicAInqueue:queue];
    dispatch_barrier_async(queue, ^(){NSLog(@"----------dispatch_barrier_async---------");});
    // 内存栅栏
    dispatch_barrier_async(queue, ^(){NSLog(@"-----result, _atomicA=%d, _nonatomicA=%d",self.atomicA,self.nonatomicA);});
    
    dispatch_async(queue, ^{
        NSLog(@"-----result2, _atomicA=%d, _nonatomicA=%d",self.atomicA,self.nonatomicA);
    });
    
}

// 使用信号量限制线程数量
- (void) limitThreadNumWith:(int)maxCount{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(maxCount);
    dispatch_queue_t queue = dispatch_queue_create("limitThreadTest", DISPATCH_QUEUE_CONCURRENT);
    for (int pi=0;;pi++){
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"current thread is %@ current id is %d",[NSThread currentThread], pi);
            sleep(3);
            dispatch_semaphore_signal(semaphore);
        });
    }
}

// 测试系统能开启最大线程数
- (void) countForProcess:(NSNumber *)pi{
    for (int i=0; i<10;++i){
        NSLog(@"%@ -- %d", pi, i);
    }
}

// 测试系统能开启最大线程数
- (void) testMaxOperationNum:(int)pi{
    [self.operationQueue addOperationWithBlock: ^{
        for (int i=0; i<100; ++i) {
            NSLog(@"now process index is %d", pi);
        }
    }];
}

// NSBlockOperation的顺序执行
- (void) testOperation{
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"读取文件卷： 1(%@)",[NSThread currentThread]);
    }];
    for (int i=2;i<4;++i){   // 任务追加
        [blockOperation1 addExecutionBlock:^{
            NSLog(@"读取文件卷： %d(%@)",i,[NSThread currentThread]);
        }];
    }
    
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载文件");
    }];
    [blockOperation1 addDependency:blockOperation2]; // 使blockOperation1依赖blockOperation2，来保证执行顺序
    [self.operationQueue addOperation:blockOperation1];
    [self.operationQueue addOperation:blockOperation2];
    
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            NSLog(@"通知主线程文件读取完毕(%@)",[NSThread currentThread]);
        }];
    }];
    [blockOperation3 addDependency:blockOperation1];
    [self.operationQueue addOperation:blockOperation3];
}

// 线程组特性，线程回切，执行完的回调测试
- (void) dispatch_group_test{
    dispatch_queue_t queue = dispatch_queue_create("q_test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务1，休眠1秒");
        sleep(1);
        NSLog(@"任务1，完成");
    });
    
    NSLog(@"主线程,休眠2秒");
    sleep(2);
    NSLog(@"主线程,休眠2秒,完成");
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2，休眠2秒");
        sleep(2);
        NSLog(@"任务2，完成");
    });
    
    dispatch_group_notify(group, queue, ^{  // 组内任务完成，通知回调
        NSLog(@"group内任务全部完成");
    });
    
    NSLog(@"主线程结束，%@", [NSThread currentThread]);
}

// atomic的不安全性
- (void) setAtomicA:(int)atomicA{
    _atomicA = atomicA;
}
- (int) atomicA{
    return _atomicA;
}

- (void) testForAtomicAInqueue:q{
    dispatch_async(q, ^{
        for (int i = 0;i<10;++i){
            self.atomicA=self.atomicA+1;
            NSLog(@"_atomicA+1= %d",self.atomicA);
        }
    });
    dispatch_async(q, ^{
        for (int i = 0;i<10;++i){
            self.atomicA = self.atomicA-1;
            NSLog(@"_atomicA-1= %d",self.atomicA);
        }
    });
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
