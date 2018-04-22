//
//  TestIsa.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/16.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "TestIsa.h"
#import "objc/runtime.h"

@implementation TestIsa

- (instancetype) init{
    self = [super init];
    if (self)
    {
        _helper = [HelperClass new];
    }
    return self;
}

#pragma 1获取方法地址，Runtime通过isa在 Cache 和类的方法列表(包括父类)中找要执行的方法
//- (void) foo:(NSString *)bar{
//    NSLog(@"foo: %@", bar);
//}
//
//+ (void) foo_class:(NSString *)bar{
//    NSLog(@"foo_class: %@", bar);
//}

#pragma 2动态方法解析，第一步找不到，Runtime 会调用 resolveInstanceMethod: 或 resolveClassMethod:
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"%s",__FUNCTION__);
    if (sel == @selector(foo: )) {
//        class_addMethod([self class], sel, imp_implementationWithBlock(^(id self, NSString *bar) {
//            NSLog(@"method resolution way, foo: %@", bar);
//        }), "v@*");
    }
    return YES;
}

//+ (BOOL)resolveClassMethod:(SEL)sel
//{
//    if (sel == @selector(foo_class: )) {
//        Class metaClass = objc_getMetaClass("TestIsa");
//        class_addMethod(metaClass, sel, imp_implementationWithBlock(^(id self, NSString *bar) {
//            NSLog(@"method resolution way, foo_class:%@", bar);
//        }), "v@*");
//    }
//    return YES;
//}

#pragma 3重定向，前面都失败，Runtime还允许我们设置一个类备用来处理当前消息
- (id) forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"%s",__FUNCTION__);
    if (aSelector == @selector(foo: )) {
        //return _helper;  // return nil时会往下走，调用forwardInvocation
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma 4自定义，前面都失败，Runtime还提供自定义的完整的消息转发机制
- (void) forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"%s",__FUNCTION__);
    if ([HelperClass instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_helper];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature)
    {
        if ([HelperClass instancesRespondToSelector:aSelector])
        {
            signature = [HelperClass instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}

@end
