//
//  ViewController.m
//  cvTest
//
//  Created by yuki on 2015/06/12.
//  Copyright (c) 2015年 yuki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView;
@synthesize hsvController;
@synthesize closeButton;
@synthesize hmax;
@synthesize hmin;
@synthesize smax;
@synthesize smin;
@synthesize vmax;
@synthesize vmin;


- (void)startCamera:(NSTimer *)timer
{
    
    [videoCamera start];
    isCapturing = YES;
    
}

-(IBAction)clickCommand:(id)sender
{
    hsvController.hidden = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ( touch.view.tag == imageView.tag )
        [self clickCommand:imageView];
}


- (void)initHSV
{
    
    hmax.tag = Hmax_slider;
    hmin.tag = Hmin_slider;
    smax.tag = Smax_slider;
    smin.tag = Smin_slider;
    vmax.tag = Vmax_slider;
    vmin.tag = Vmin_slider;
    
    hmax.value = 30;
    hmin.value = 0;
    smax.value = 255;
    smin.value = 0;
    vmax.value = 255;
    vmin.value = 0;
    
    hsvval[0] = hmax.value = 10;
    hsvval[1] = hmin.value = 0;
    hsvval[2] = smax.value = 255;
    hsvval[3] = smin.value = 100;
    hsvval[4] = vmax.value = 255;
    hsvval[5] = vmin.value = 100;
    
    
    hmaxval.text =  [NSString stringWithFormat:@"%d", (int)hmax.value];
    hminval.text =  [NSString stringWithFormat:@"%d", (int)hmin.value];
    smaxval.text =  [NSString stringWithFormat:@"%d", (int)smax.value];
    sminval.text =  [NSString stringWithFormat:@"%d", (int)smin.value];
    vmaxval.text =  [NSString stringWithFormat:@"%d", (int)vmax.value];
    vminval.text =  [NSString stringWithFormat:@"%d", (int)vmin.value];
    
    
}

- (void)extarctColor: (IplImage *)srcImage
{
    IplImage *hsvImage = cvCreateImage(cvGetSize(srcImage), IPL_DEPTH_8U, 3);
    
    double h;
    double s;
    double v;
    
    
    cvCvtColor(srcImage,hsvImage, CV_BGR2HSV);
    
    unsigned char *offset;
    unsigned char *P3Image = (uchar *)(hsvImage->imageData);
    int widthStep3=hsvImage->widthStep;
    
    for(int y=0;y<hsvImage->height;y++,P3Image+=widthStep3){
        for(int x=0;x<hsvImage->width;x++){
            
            offset = (P3Image+x+(x<<1));
            h=*(offset);
            s=*(offset+1);
            v=*(offset+2);
            
            if(h<=hsvval[0] && h>=hsvval[1] &&
               s<=hsvval[2] && s>=hsvval[3] &&
               v<=hsvval[4] && v>=hsvval[5]
               ){
            } else {
                *(offset+1) = 10;
            }
        }
    }
    cvCvtColor(hsvImage,srcImage, CV_HSV2BGR);
    
    cvReleaseImage(&hsvImage);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageView.tag = 100;
    imageView.userInteractionEnabled = YES;
    
    hsvController.hidden = YES;
    hsvController.alpha = 0.6;
    
    [self initHSV];
    
    videoCamera = [[CvVideoCamera alloc]
                   initWithParentView:imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition =
    AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset =
    AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation =
    AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    
    isCapturing = NO;
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCamera:) userInfo:nil repeats:NO];
    
    printf("start");

    
}

- (NSInteger)supportedInterfaceOrientations
{
    // Only portrait orientation
    return UIInterfaceOrientationMaskPortrait;
}

- (void)processImage:(cv::Mat&)image
{
    cv::Mat image_copy;
    cv::cvtColor(image, image_copy, CV_BGRA2BGR);
    IplImage iplImage = image_copy;
    [self extarctColor: &iplImage];
    cv::Mat mat(&iplImage);
    cv::cvtColor(mat, image, CV_BGR2BGRA);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isCapturing)
    {
        [videoCamera stop];
    }
}

- (IBAction)sliderModified:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    switch(slider.tag) {
        case Hmax_slider:
            hmaxval.text =  [NSString stringWithFormat:@"%d", (int)slider.value];
            break;
        case Hmin_slider:
            hminval.text =  [NSString stringWithFormat:@"%d", (int)slider.value];
            break;
        case Smax_slider:
            smaxval.text =  [NSString stringWithFormat:@"%d", (int)slider.value];
            break;
        case Smin_slider:
            sminval.text =  [NSString stringWithFormat:@"%d", (int)slider.value];
            break;
        case Vmax_slider:
            vmaxval.text =  [NSString stringWithFormat:@"%d", (int)slider.value];
            break;
        case Vmin_slider:
            vminval.text =  [NSString stringWithFormat:@"%d", (int)slider.value];
            break;
    }
    hsvval[0] = hmax.value;
    hsvval[1] = hmin.value;
    hsvval[2] = smax.value;
    hsvval[3] = smin.value;
    hsvval[4] = vmax.value;
    hsvval[5] = vmin.value;
}


-(IBAction)closeButtonPressed:(id)sender;
{
    hsvController.hidden = YES;
}


- (void)dealloc
{
    videoCamera.delegate = nil;
}

@end