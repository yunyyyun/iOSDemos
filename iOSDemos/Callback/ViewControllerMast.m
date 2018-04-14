//
//  ViewControllerMast.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/12.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "ViewControllerMast.h"
#import "ViewControllerSlave.h"

@interface ViewControllerMast ()

@property (nonatomic, strong) UITextField *tx;

@end

@implementation ViewControllerMast

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Master";
    
    _tx = [[UITextField alloc] initWithFrame:CGRectMake(100, 250, 175, 30)];
    _tx.borderStyle = UITextBorderStyleRoundedRect;
    _tx.backgroundColor = [UIColor whiteColor];
    _tx.font = [UIFont systemFontOfSize:14];
    _tx.textColor = [UIColor darkGrayColor];
    _tx.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tx];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 300, 255, 40)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitle:@"回传数据给A" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(backActionClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    int a = 10;
    __block int b = 10;
    void (^block)(void) = ^{
        NSLog(@"int block, a=%d \n",a);
    };
    block();
    void (^block2)(int a) = ^(int a){
        a = 12;
        b = 13;
        NSLog(@"int block2, a=%d,b=%d \n",a, b);
    };
    block2(a);
    NSLog(@"a=%d b=%d \n",a,b); // block是传值调用，所以a没有改变，但是__block变量修饰的会传址
    
    int num = 10;
    void(^block3)(void) = ^{
        NSLog(@"%d",num);
    };
    self.task = block3;
    NSLog(@"%@--%@",block3,self.task);// 在mrc下，分别是栈区,堆区;arc下都是堆区
    
    typedef int(^MYBlock)(void); // block是一种类型，可以定义别名
    int(^block4)(void) = ^{
        NSLog(@"%d",num);
        return num;
    };
    MYBlock mbllock = block4;
    NSLog(@"%d",mbllock());
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)backActionClicked
{
    self.callBackBlock(_tx.text); //1
    //self->callBackFunc(123);
    if (self.callBackFunc){
        NSLog(@"result is %d \n",self.callBackFunc(2));
    }
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_delegate respondsToSelector:@selector(sendValue:)]) {
        [_delegate sendValue:_tx.text];
    }
    NSArray *vcArray = self.navigationController.viewControllers;
    //[self.navigationController popToViewController:vcArray[vcArray.count-2] animated:YES];
    for(UIViewController *vc in vcArray){
        NSLog(@"class is %@", [vc description]);
        if ([vc isKindOfClass:[ViewControllerSlave class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
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
