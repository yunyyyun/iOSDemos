//
//  MasonryViewController.h
//  layoutDemon
//
//  Created by mengyun on 2018/4/4.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CView.h"

@interface MasonryViewController : UIViewController

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, assign) NSInteger size;

@property (nonatomic, strong) UIButton *enlargeBtn;
@property (nonatomic, strong) UIButton *narrowBtn;

@property (nonatomic, assign) NSInteger delta;
@end
