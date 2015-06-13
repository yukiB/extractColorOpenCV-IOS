//
//  ViewController.h
//  cvTest
//
//  Created by yuki on 2015/06/12.
//  Copyright (c) 2015年 yuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/ios.h>
#import <opencv2/opencv.hpp>

typedef enum {
    Hmax_slider,
    Hmin_slider,
    Smax_slider,
    Smin_slider,
    Vmax_slider,
    Vmin_slider
} SliderType;

@interface ViewController : UIViewController<CvVideoCameraDelegate>
{
    CvVideoCamera* videoCamera;
    BOOL isCapturing;
    __weak IBOutlet UILabel *hmaxval;
    __weak IBOutlet UILabel *hminval;
    __weak IBOutlet UILabel *smaxval;
    __weak IBOutlet UILabel *sminval;
    __weak IBOutlet UILabel *vmaxval;
    __weak IBOutlet UILabel *vminval;
    
    int hsvval[6];
    
}

@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* startCaptureButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* stopCaptureButton;

@property (nonatomic, weak) IBOutlet
UIBarButtonItem* lockFocusButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* lockExposureButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* lockBalanceButton;

@property (nonatomic, weak) IBOutlet
UIButton* closeButton;

@property (nonatomic, weak) IBOutlet
UISlider* hmax;
@property (nonatomic, weak) IBOutlet
UISlider* hmin;
@property (nonatomic, weak) IBOutlet
UISlider* smax;
@property (nonatomic, weak) IBOutlet
UISlider* smin;
@property (nonatomic, weak) IBOutlet
UISlider* vmax;
@property (nonatomic, weak) IBOutlet
UISlider* vmin;


@property (nonatomic, weak) IBOutlet
UIView* hsvController;

-(IBAction)closeButtonPressed:(id)sender;

-(IBAction)sliderModified:(id)
    sender;

@end

