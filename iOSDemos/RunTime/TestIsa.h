//
//  TestIsa.h
//  iOSDemos
//
//  Created by mengyun on 2018/4/16.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelperClass.h"

@interface TestIsa : NSObject

- (void) foo:(NSString *)bar;
+ (void) foo_class:(NSString *)bar;

@property (nonatomic, strong)HelperClass* helper;

@end
