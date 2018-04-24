//
//  ViewController.m
//  iOSDemos
//
//  Created by mengyun on 2018/4/12.
//  Copyright © 2018年 mengyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSArray *sectionTitleArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _sectionTitleArr = [NSArray arrayWithObjects:
                        @"Layout performance compare test",
                        @"Runtime",
                        @"Callback",
                        @"GCD",
                        @"AlterViewController",
                        nil];
    NSArray *arrForDemo1 = [NSArray arrayWithObjects:
                            @"ViewControllerForFrameTest",
                            @"MasonryViewController",
                            @"ViewControllerUseFlexBox",
                            nil];
    NSArray *arrForDemo2 = [NSArray arrayWithObjects:
                            @"ViewControllerForRuntimeTest",
                            nil];
    NSArray *arrForDemo3 = [NSArray arrayWithObjects:
                            @"ViewControllerSlave",
                            nil];
    NSArray *arrForDemo4 = [NSArray arrayWithObjects:
                            @"ViewControllerForGcdTest",
                            nil];
    NSArray *arrForDemo5 = [NSArray arrayWithObjects:
                            @"TimerViewController",
                            nil];
    _titleArr = [NSArray arrayWithObjects: arrForDemo1, arrForDemo2, arrForDemo3, arrForDemo4, arrForDemo5, nil];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView protocol
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *tmpArr = _titleArr[indexPath.section];
    NSString *className = tmpArr[indexPath.row];
    NSLog(@"className---- %@", className);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = className;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tmpArr = _titleArr[indexPath.section];
    NSString *className = tmpArr[indexPath.row];
    NSLog(@"jump to className---- %@", className);
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    vc.view.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tmpArr = _titleArr[section];
    return tmpArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _sectionTitleArr[section];
}

@end


