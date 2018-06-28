//
//  CV_EqualizeViewController.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/5.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "CV_EqualizeViewController.h"
#import "OpenCV_Gray.h"

@interface CV_EqualizeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *orignImage;
@property (weak, nonatomic) IBOutlet UIImageView *grayImage;

@property (weak, nonatomic) IBOutlet UIImageView *g_hisImage;
@property (weak, nonatomic) IBOutlet UIImageView *equalizeImage;
@property (weak, nonatomic) IBOutlet UIImageView *e_hisImage;

@property (nonatomic, strong) OpenCV_Gray *openCV;
@end

@implementation CV_EqualizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _openCV = [[OpenCV_Gray alloc] init];
    [_openCV equalIzeGrayImage:_orignImage.image BackEQGrayImage:^(UIImage *grayImage, UIImage *grayHImage, UIImage *grayEImage, UIImage *grayEHImage) {
        _grayImage.image = grayImage;
        _g_hisImage.image = grayHImage;
        _equalizeImage.image = grayEImage;
        _e_hisImage.image = grayEHImage;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
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
