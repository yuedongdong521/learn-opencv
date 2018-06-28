//
//  CV_OthlineViewController.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/2.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "CV_OthlineViewController.h"

@interface CV_OthlineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *orignImage;
@property (weak, nonatomic) IBOutlet UIImageView *binaryImage;
@property (weak, nonatomic) IBOutlet UIImageView *outlineImage;
@property (weak, nonatomic) IBOutlet UISlider *outlineSlider;
@property (nonatomic, strong) OpenCVUitl *openCV;
@end

@implementation CV_OthlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _openCV = [[OpenCVUitl alloc] init];
    
    if (_index == 4) {
        _orignImage.image = [UIImage imageNamed:@"baiduxiong"];
        
        _outlineImage.image = [_openCV outlineImageTowForImage:_orignImage.image BackBinaryImage:^void(UIImage *image) {
            _binaryImage.image = image;
        }];
    } else if (_index == 7) {
        _orignImage.image = [UIImage imageNamed:@"meinv.jpg"];
        
        _outlineImage.image = [_openCV createGrayImage:_orignImage.image BackGrayImage:^(UIImage *grayImage) {
            _binaryImage.image = grayImage;
        }];
        _outlineSlider.hidden = YES;
    }
}
- (IBAction)outlineSliderValue:(id)sender {
    
    _outlineImage.image = [_openCV changeLevels:(int)_outlineSlider.value BlackBinaryImage:^(UIImage *image) {
        _binaryImage.image = image;
    }];
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
