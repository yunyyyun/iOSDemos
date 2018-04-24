//
//  CView.m
//  layoutDemon
//
//  Created by mengyun on 2018/4/4.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "CView.h"

@implementation CView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12"]];
    }
    return self;
}

- (void) drawRect:(CGRect)rect{
    NSLog(@"---mytest----%s",__FUNCTION__);
}

- (void) layoutSubviews{
    [_imgView setFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4)];
//    _imgView.layer.cornerRadius = 2.0;
//    _imgView.layer.borderWidth = 2.0;
    
    [self addSubview:_imgView];
    [self setBackgroundColor:[UIColor redColor]];
    
    //NSLog(@"%lf  %lf  %lf",self.frame.size.width , self.frame.size.height,self.frame.size.width*self.frame.size.height/(400*400));
//    self.alpha = 1.0-self.frame.size.width*self.frame.size.height/(400*400);
}


@end
