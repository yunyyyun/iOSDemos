//
//  ViewControllerMast.h
//  iOSDemos
//
//  Created by mengyun on 2018/4/12.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import <UIKit/UIKit.h>

// 代理
@protocol testDelegate <NSObject>
- (void)sendValue:(NSString *)value; //声明协议方法
@end

// block
typedef void(^testBlcok) (NSString *text);
typedef void(^testBolck2) (void);

// 函数指针
typedef int (*PF)(int);

@interface ViewControllerMast : UIViewController

@property (nonatomic, weak)id<testDelegate> delegate; //声明协议变量
@property (nonatomic, copy)testBlcok callBackBlock;
@property (nonatomic, assign)PF callBackFunc;

@property (nonatomic, copy)testBolck2 task;

@end
