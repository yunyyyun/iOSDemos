//
//  MasonryViewController.m
//  layoutDemon
//
//  Created by mengyun on 2018/4/4.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "MasonryViewController.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h" //宏必须添加在头文件前面

@interface MasonryViewController ()

@end

@implementation MasonryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: _bgView];
    
    _size = 3;
    _views = [NSMutableArray arrayWithCapacity:_size*_size];
    for (NSInteger i=0;i<_size*_size;++i){
        CView *view = [[CView alloc] init];
        [_views addObject:view];
        [_bgView addSubview:view];
    }
    
    NSLog(@"========1");
    [self layoutsubviews];
    NSLog(@"========12");
    
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
        [_bgView updateConstraints:^(MASConstraintMaker *make)  {
            make.left.equalTo(self.view).offset(spaceWidth);
            make.top.equalTo(self.view).offset(spaceWidth+80);
            make.right.equalTo(self.view).offset(-spaceWidth);
            make.width.equalTo(_bgView.height);
        }];
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

- (void)layoutsubviews{
    NSInteger space = 4.0;
    NSInteger edgeWidth = 10;
    [_bgView makeConstraints:^(MASConstraintMaker *make)  {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(80);
        make.right.equalTo(self.view);
        make.width.equalTo(_bgView.height);
    }];
    
    for (int index=0; index<_size*_size; ++index){
        NSInteger x = index%_size;
        NSInteger y = index/_size;
        if(x==0){
            [_views[index] makeConstraints:^(MASConstraintMaker *make)  {
                make.top.left.equalTo(_bgView).offset(space);
                make.bottom.equalTo(_bgView).offset(-space);
                make.width.equalTo(edgeWidth);
            }];
        }
        else if(x==_size-1){
            [_views[index] makeConstraints:^(MASConstraintMaker *make)  {
                make.top.equalTo(_bgView).offset(space);
                make.right.bottom.equalTo(_bgView).offset(-space);
                make.width.equalTo(edgeWidth);
            }];
        }
        else if(y==0){
            [_views[index] makeConstraints:^(MASConstraintMaker *make)  {
                make.top.left.equalTo(_bgView).offset(space);
                make.right.equalTo(_bgView).offset(-space);
                make.height.equalTo(edgeWidth);
            }];
        }
        else if(y==_size-1){
            [_views[index] makeConstraints:^(MASConstraintMaker *make)  {
                make.left.equalTo(_bgView).offset(space);
                make.bottom.right.equalTo(_bgView).offset(-space);
                make.height.equalTo(edgeWidth);
            }];
        }
        else{
            CView *leftView = _views[(y)*_size+(x-1)];
            CView *rightView = _views[(y)*_size+(x+1)];
            CView *topView = _views[(y-1)*_size+(x)];
            CView *bottomView = _views[(y+1)*_size+(x)];
            CView *referenceView = _views[(_size/2)*_size+(_size/2)];
            [_views[index] makeConstraints:^(MASConstraintMaker *make)  {
                make.left.equalTo(leftView.right).offset(space);
                make.right.equalTo(rightView.left).offset(-space);
                make.top.equalTo(topView.bottom).offset(space);
                make.bottom.equalTo(bottomView.top).offset(-space);
                make.width.height.equalTo(referenceView);
            }];
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
