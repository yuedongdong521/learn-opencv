//
//  DrawViewController.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/5.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "DrawViewController.h"
#import "OpenCV_Gray.h"
#import "DrawImageView.h"

@interface DrawViewController ()<DrawImageViewDelegate>

@property (nonatomic, strong) OpenCV_Gray *openGray;
@property (nonatomic, strong) DrawImageView *drawImageView;
@property (weak, nonatomic) IBOutlet UIButton *redrawBtn;
@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    _openGray = [[OpenCV_Gray alloc] init];
    
    _drawImageView = [[DrawImageView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, self.view.frame.size.height - 200)];
    _drawImageView.image = [_openGray createDrawViewForWidth:_drawImageView.frame.size.width ForHeight:_drawImageView.frame.size.height];
    _drawImageView.delegate = self;
    [self.view addSubview:_drawImageView];
    
}

- (void)drawImageForPoint:(CGPoint)point Event:(NSInteger)event
{
    _drawImageView.image = [_openGray drawForX:point.x Y:point.y TouchEvent:event];
}
- (IBAction)redrawAction:(id)sender {
    
    _drawImageView.image = [_openGray rewardAction];
}

- (void)rightAction
{
    
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
