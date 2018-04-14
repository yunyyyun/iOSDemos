//
//  UIImage+Category.m
//  forRuntime
//
//  Created by mengyun on 2018/4/10.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "UIImage+Category.h"
#import "objc/runtime.h"
#import "UIImage+Extension.h"
static char key = 'c';
@implementation UIImage (Category)

- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, &key, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)name {
    return objc_getAssociatedObject(self, &key);
}

- (void) setTest:(NSString *)test{
    self.test = test;
}
- (NSString *)test{
    return self.test;
}

+ (UIImage *)my_imageNamed:(NSString *)name {
    NSLog(@"---my_imageNamed");
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 10.0) {
        name = [name stringByAppendingString:@"_new"];
    }
    return [UIImage my_imageNamed:name];
}

+ (void)load {
    // 获取两个类的类方法
    Method m1 = class_getClassMethod([UIImage class], @selector(imageNamed:));
    Method m2 = class_getClassMethod([UIImage class], @selector(my_imageNamed:));
    // 开始交换方法实现
    method_exchangeImplementations(m1, m2);
}

@end
