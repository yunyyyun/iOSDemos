//
//  AlterViewController.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/17.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "AlterViewController.h"

@interface AlterViewController ()

@property(strong,nonatomic) UIButton *button;
@property(strong,nonatomic) dispatch_semaphore_t semaphore;
@property(strong,nonatomic) NSMutableArray *avArr;

@end

@implementation AlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _semaphore = dispatch_semaphore_create(1);
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 20)];
    [self.button setTitle:@"弹框" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    
    [self.button addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) clickMe:(id)sender{
    dispatch_queue_t q = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<9; ++i){
        
        dispatch_async(q, ^(){
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            [self showAlterViewWithId:i];
        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self showAlterViewWithId:i];
//        });
    }
    
}

- (void) showAlterViewWithId:(NSInteger)n{
    NSString *msg = [NSString stringWithFormat:@"按钮被点击了 %ld",(long)n];
    //初始化提示框；
    
    
    NSString *htmlString = @"<font size='3' color='red'>This is some text!</font>";
//    NSString *newString = [htmlString stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",1.0]];
//
//    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    //str是要显示的字符串
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    [attrString addAttributes:@{NSBaselineOffsetAttributeName: @(5),//设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏，可使UILabel文本垂直居中
                                NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, attrString.length)];
    
    NSLog(@"%@",attrString);
    
    //self.descLabel.attributedText = attrString;
    
    
    //计算html字符串高度
//    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
//
//    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, htmlString.length)];
//
//    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){ScreenWidth - 20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:  UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:@"这里是正文信息"];
    [messageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 6)];
    [messageText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    [messageText addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(3, 3)];
    [alert setValue:messageText forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        dispatch_semaphore_signal(_semaphore);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        dispatch_semaphore_signal(_semaphore);
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
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
