//
//  ViewControllerUseFlexBox.m
//  layoutDemon
//
//  Created by mengyun on 2018/4/5.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "ViewControllerUseFlexBox.h"
#import "UIView+FBLayout.h"
#import "FlexBoxLayout.h"
#import "FBAsyLayoutTransaction.h"

@interface ViewControllerUseFlexBox ()

@property (nonatomic, strong) FBLayoutDiv *rootDiv;

@end

@implementation ViewControllerUseFlexBox

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    _bgView.backgroundColor = [UIColor blueColor];
    [self.view addSubview: _bgView];
    
    _size = 22;
    _views = [NSMutableArray arrayWithCapacity:_size*_size];
    for (NSInteger i=0;i<_size*_size;++i){
        CView *view = [[CView alloc] init];
        [_views addObject:view];
        [_bgView addSubview:view];
    }
    
    [self layoutsubviewsWith:0];
    
    _enlargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 600, 44, 33)];
    [_enlargeBtn setTitle:@"放大" forState:UIControlStateNormal];
    [_enlargeBtn addTarget:self action:@selector(enlarge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enlargeBtn];
    
    _narrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 600, 44, 33)];
    [_narrowBtn setTitle:@"缩小" forState:UIControlStateNormal];
    [_narrowBtn addTarget:self action:@selector(narrow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_narrowBtn];
    
    self.delta= 0;
}


- (void) setDelta:(NSInteger)delta{
    NSInteger spaceWidth = delta;
    if (spaceWidth>1 && spaceWidth<self.view.frame.size.width*0.5-40){
        _delta = delta;
        NSLog(@"----------%ld",spaceWidth);
        [self layoutsubviewsWith:spaceWidth];
    }
}

-(void)enlarge:(UIButton *)button{
    self.delta = self.delta-2;
}
-(void)narrow:(UIButton *)button{
    self.delta = self.delta+2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutsubviewsWith: (NSInteger)spaceWidth{
    if (_rootDiv) {
        _rootDiv = nil;
    }
    
    NSInteger space = 4.0;
    //NSInteger edgeWidth = 10;
    _bgView.frame = CGRectMake(spaceWidth, 80+spaceWidth, self.view.frame.size.width-spaceWidth*2, self.view.frame.size.width-spaceWidth*2);
    
//    for (int i=0;i<_size;++i){
//        NSInteger index = _size*(i)+0;
//        ((CView*)_views[index]).frame = CGRectMake(space, space, edgeWidth, self.bgView.frame.size.width-space*2);
//        index = _size*(i)+_size-1;
//        ((CView*)_views[index]).frame = CGRectMake(self.bgView.frame.size.width-edgeWidth-space, space, edgeWidth, self.bgView.frame.size.width-space*2);
//        index = i;
//        ((CView*)_views[index]).frame = CGRectMake(space, space, self.bgView.frame.size.width-space*2, edgeWidth);
//        index = _size*(_size-1)+i;
//        ((CView*)_views[index]).frame = CGRectMake(space, self.bgView.frame.size.height-edgeWidth-space, self.bgView.frame.size.width-space*2, edgeWidth);
//    }
    NSMutableArray *divs = [NSMutableArray arrayWithCapacity:(_size)];
    for (int x=0; x<_size; ++x){
        divs[x] = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionRow  // 主轴纵向排列
                                                    justifyContent:FBJustifySpaceAround  //等间距
                                                        alignItems:FBAlignStretch // 交叉轴对齐
                                                   children:@[]];
        CView *referenceView = _views[(_size/2)*_size+(_size/2)];
        NSNumber *width = [NSNumber numberWithFloat: (self.bgView.frame.size.width-(space*_size+1))/(_size)];
        [referenceView fb_makeLayout:^(FBLayout *layout) {
            layout.width.height.equalTo(width);
            //layout.flexGrow.equalTo(@(2.0));
            layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        for (int y=0; y<_size; ++y){
            NSInteger index = (y*_size)+x;
            CView *cv = (CView* )_views[index];
            [_views[index] fb_makeLayout:^(FBLayout *layout) {
                layout.equalTo(referenceView);
            }];
            [divs[x] fb_addChild:cv];
        }
    }
    _rootDiv = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionColumn  // 布局排列的方向
                                                 justifyContent:FBJustifySpaceAround   // 子元素在主轴对齐方式，用于约束间隙等属性
                                                     alignItems:FBAlignStretch  // 子元素在交叉轴对齐方式，用于约束间隙等属性
                                                       children:divs];
    [_rootDiv fb_asyApplyLayoutWithSize:_bgView.frame.size];
    //NSLog(@"----%lf %lf",_bgView.frame.size.width, _bgView.frame.size.height);
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
