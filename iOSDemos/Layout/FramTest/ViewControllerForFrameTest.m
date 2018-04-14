//
//  ViewControllerForFrameTest.m
//  layoutDemon
//
//  Created by mengyun on 2018/4/5.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "ViewControllerForFrameTest.h"

@interface ViewControllerForFrameTest ()

@end

@implementation ViewControllerForFrameTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    _bgView.backgroundColor = [UIColor whiteColor];
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
    NSInteger space = 2.0;
    NSInteger edgeWidth = 10;
    _bgView.frame = CGRectMake(spaceWidth, 80+spaceWidth, self.view.frame.size.width-spaceWidth*2, self.view.frame.size.width-spaceWidth*2);
    
    for (int index=0; index<_size*_size; ++index){
        NSInteger x = index%_size;
        NSInteger y = index/_size;
        if(x==0){
            ((CView*)_views[index]).frame = CGRectMake(space, space, edgeWidth, self.bgView.frame.size.width-space*2);
        }
        else if(x==_size-1){
            ((CView*)_views[index]).frame = CGRectMake(self.bgView.frame.size.width-edgeWidth-space, space, edgeWidth, self.bgView.frame.size.width-space*2);
        }
        else if(y==0){
            ((CView*)_views[index]).frame = CGRectMake(space, space, self.bgView.frame.size.width-space*2, edgeWidth);
        }
        else if(y==_size-1){
            ((CView*)_views[index]).frame = CGRectMake(space, self.bgView.frame.size.height-edgeWidth-space, self.bgView.frame.size.width-space*2, edgeWidth);
        }
        else{
            CGFloat width = (self.bgView.frame.size.width-(edgeWidth*2+space*3))/(_size-2); // 预先计算view的大小
            CGFloat height = (self.bgView.frame.size.height-(edgeWidth*2+space*3))/(_size-2);
            CGFloat xstart = (x-1)*(width)+space+edgeWidth; // 计算view的位置
            CGFloat ystart = (y-1)*(height)+space+edgeWidth;
            ((CView*)_views[index]).frame = CGRectMake(xstart+space, ystart+space, width-space, height-space);
        }
    }
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
