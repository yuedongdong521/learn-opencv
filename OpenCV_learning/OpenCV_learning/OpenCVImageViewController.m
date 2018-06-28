//
//  OpenCVImageViewController.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/1.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "OpenCVImageViewController.h"
#import "OpenCV_Gray.h"

@interface OpenCVImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *orginImage;
@property (weak, nonatomic) IBOutlet UIImageView *openCVImage;
@property (weak, nonatomic) IBOutlet UISlider *edgeSlider;
@property (nonatomic, strong) OpenCVUitl *openCVUitl;
@property (nonatomic, strong) OpenCV_Gray *openCV_Gray;

@end

@implementation OpenCVImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _openCVUitl = [[OpenCVUitl alloc] init];
    _openCV_Gray = [[OpenCV_Gray alloc] init];
    
    [_orginImage setImage:[UIImage imageNamed:@"face-points"]];
    switch (_type) {
        case 0:
            [_openCVImage setImage:[_openCVUitl scaleImage:_orginImage.image]];
            _edgeSlider.hidden = YES;
            break;
        case 1:
            [_openCVImage setImage:[_openCVUitl edgeDetectionForImage:_orginImage.image]];
            break;
        case 2:
            [_openCVImage setImage:[_openCVUitl binarizationFor:_orginImage.image]];
            break;
        case 3:
            [_orginImage setImage:[_openCVUitl drawingImage]];
            _edgeSlider.maximumValue = 6;
            [_openCVImage setImage:[_openCVUitl outlineImageForLevels:5]];
            break;
        case 4:
            break;
        case 5:
            _orginImage.image = [UIImage imageNamed:@"round2Image.jpg"];
            _openCVImage.image = [_openCVUitl roundDetectionForImage:_orginImage.image];
            break;
        case 6:
            _orginImage.image = [UIImage imageNamed:@"roundImage.jpg"];
            _openCVImage.image = [_openCVUitl lineDetectionForImage:_orginImage.image];
            break;
            
        case 7:
            _openCVImage.image = [_openCVUitl createGrayImage:_orginImage.image BackGrayImage:^(UIImage *grayImage) {
            
            }];
            break;
        case 9:
            [_orginImage setImage:[UIImage imageNamed:@"meinv1.jpg"]];
            _openCVImage.image = [_openCV_Gray converEqualizeHistImage:_orginImage.image];
            break;
        default:
            break;
    }
}
- (IBAction)edgeSilderValueChanged:(id)sender {

    NSLog(@"edgeSilder Value = %f", _edgeSlider.value);
    switch (_type) {
        case 0:
            break;
        case 1:
            [_openCVImage setImage:[_openCVUitl edgeDetectionSliderValue:(int)_edgeSlider.value]];
            break;
        case 2:
            [_openCVImage setImage:[_openCVUitl changeBinarizationValue:(int)_edgeSlider.value]];
            break;
        case 3:
            [_openCVImage setImage:[_openCVUitl outlineImageForLevels:(int)_edgeSlider.value]];
            break;
        default:
            break;
    }

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
