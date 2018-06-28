//
//  ViewController.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/1.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "ViewController.h"
#import "OpenCVImageViewController.h"
#import "CV_OthlineViewController.h"
#import "CV_EqualizeViewController.h"
#import "DrawViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _itemArray = [NSMutableArray arrayWithArray: @[@"缩放", @"边缘检测", @"二值化",@"轮廓检测上", @"轮廓检测下", @"圆检测", @"线段检测",@"灰度直方图", @"灰度直方图均衡化", @"彩色图像的直方图均衡化", @"绘制"]];
    
}

- (void)pushOPenCVForIndex:(NSInteger)index
{
    if ([_itemArray[index] isEqualToString:@"轮廓检测下"]
        || [_itemArray[index] isEqualToString:@"灰度直方图"]
    ) {
        CV_OthlineViewController *VC = [[CV_OthlineViewController alloc] init];
        VC.title = _itemArray[index];
        VC.index = index;
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([_itemArray[index] isEqualToString:@"灰度直方图均衡化"]) {
        CV_EqualizeViewController *VC = [[CV_EqualizeViewController alloc] init];
        VC.title = _itemArray[index];
        [self.navigationController pushViewController:VC animated:NO];
    } else if ([_itemArray[index] isEqualToString:@"绘制"]) {
        DrawViewController *VC = [[DrawViewController alloc] init];
        VC.title = _itemArray[index];
        [self.navigationController pushViewController:VC animated:YES];
        
    } else {
        OpenCVImageViewController *VC = [[OpenCVImageViewController alloc] init];
        VC.title = _itemArray[index];
        VC.type = index;
        [self.navigationController pushViewController:VC animated:YES];
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushOPenCVForIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = _itemArray[indexPath.row];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
