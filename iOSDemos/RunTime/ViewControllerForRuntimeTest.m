//
//  ViewControllerForRuntimeTest.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/12.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "ViewControllerForRuntimeTest.h"
#import "objc/runtime.h"
#import "UIImage+Category.h"

@interface ViewControllerForRuntimeTest ()

@end

@implementation ViewControllerForRuntimeTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    static char key = 'w';
    NSString *value = @"123123";
    objc_setAssociatedObject(self, &key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"---:%@",objc_getAssociatedObject(self, &key));
    
    Method m1 = class_getClassMethod([self class], @selector(write));
    Method m2 = class_getClassMethod([self class], @selector(read));
    method_exchangeImplementations(m1, m2);
    [ViewControllerForRuntimeTest write];
    [ViewControllerForRuntimeTest read];
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"成员变量名：%s 成员变量类型：%s",name,type);
    }
    // 注意释放内存！
    free(ivars);
    
    UIImage *img = [UIImage imageNamed:@"12"];
    img.name = @"123";
    //img.test = @"321";
    _imgView = [[UIImageView alloc] initWithImage: img];
    _imgView.frame = CGRectMake(10, 100, 200, 100);
    _imgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_imgView];
}

+ (void)write {
    NSLog(@"---write");
}
+ (void)read {
    NSLog(@"---read");
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
