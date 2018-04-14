//
//  ViewControllerSlave.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/12.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "ViewControllerSlave.h"
#import "ViewControllerMast.h"
static id object = nil;
@interface ViewControllerSlave ()<testDelegate>

@property (nonatomic, strong) UILabel *delegateLabel;
@property (nonatomic, strong) UILabel *blockLabel;

@end

@implementation ViewControllerSlave

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    _delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 255, 30)];
    _delegateLabel.text = @"通过delegate接受B的数据";
    _delegateLabel.textAlignment = NSTextAlignmentCenter;
    _delegateLabel.backgroundColor = [UIColor redColor];
    _delegateLabel.textColor = [UIColor whiteColor];
    _delegateLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_delegateLabel];
    
    _blockLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 250, 255, 30)];
    _blockLabel.text = @"通过block接受B的数据";
    _blockLabel.textAlignment = NSTextAlignmentCenter;
    _blockLabel.backgroundColor = [UIColor blueColor];
    _blockLabel.textColor = [UIColor whiteColor];
    _blockLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_blockLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 300, 255, 40)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitle:@"跳转到B" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.navigationItem.title = @"Slave";
    
    object = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicked
{
    ViewControllerMast *vcB = [ViewControllerMast new];
    __weak ViewControllerSlave *weakSelf = self;
    vcB.callBackBlock = ^(NSString *text){ // 1
        NSLog(@"text is %@",text);
        weakSelf.blockLabel.text = text;
    };
    vcB.delegate = self;
    //vcB.callBackFunc = f;
    [self.navigationController pushViewController:vcB animated:YES];
}

- (void) test{
    
}

- (void)sendValue:(NSString *)value
{
    _delegateLabel.text = value;
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
