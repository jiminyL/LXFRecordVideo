//
//  LXFRecordVideoViewController.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFRecordVideoViewController.h"

#import "WCLRecordEngine.h"
#import "WCLRecordProgressView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

#import "LXFDeviceManager.h"
#import "LXFRecord_Macro.h"

#import "LXFFileManager.h"

#import "NSDate+SSTooKitAddtions.h"

@interface LXFRecordVideoViewController ()<WCLRecordEngineDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *flashLightBtn;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *changeCameraButton;
@property (nonatomic, strong) WCLRecordProgressView *progressView;
@property (nonatomic, strong) WCLRecordEngine *recordEngine;
@property (nonatomic) BOOL allowRecord;//允许录制

@end

@implementation LXFRecordVideoViewController

- (void)dealloc {
    _recordEngine = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[LXFDeviceManager sharedInstance] shutDeviceDelegate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.recordEngine shutdown];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.recordEngine startUp];
    
    self.progressView.progress = 0.f;
    self.progressView.loadProgress = 0.f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allowRecord = YES;
    
    [self.recordEngine startUp];
}

- (void)viewWillLayoutSubviews {
    [self setupUI];
}

- (void)setupUI {
    self.recordEngine.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    [self.recordEngine resizeOrientationWithAVCaptureVideoOrientation:[self videoOrientationFromDeviceOrientation]];
    
    [self.backBtn setFrame:CGRectMake(0.f, self.view.frame.size.height - 90.f, 45.f, 45.f)];
    
    [self.recordBtn setFrame:CGRectMake((kLXFScreenWidth - 80.f)/2, self.view.frame.size.height - 100.f, 80.f, 80.f)];
    
    [self.progressView setFrame:CGRectMake(0.f, self.view.frame.size.height - 151.f, kLXFScreenWidth, 5.f)];
    
    [self.flashLightBtn setFrame:CGRectMake(kLXFScreenWidth - 60.f, 20.f, 45.f, 45.f)];
    
    [self.changeCameraButton setFrame:CGRectMake(kLXFScreenWidth - 60.f, self.view.frame.size.height - 90.f , 45.f, 45.f)];
}

#pragma mark - Event
- (void)backButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WCLRecordEngineDelegate
- (void)recordProgress:(CGFloat)progress {
    if (progress >= 1) {
        [self recordNextAction];
    }
    self.progressView.progress = progress;
}

#pragma mark - CameraAction
- (void)recordNextAction {
    if (self.recordEngine.videoPath.length > 0) {
        self.allowRecord = NO;
        @weakify(self)
        [self.recordEngine stopCaptureHandler:^(UIImage *movieImage) {
            @strongify(self)
            NSURL *videoUrl = [NSURL fileURLWithPath:self.recordEngine.videoPath];
            AVAsset *avAsset = [AVAsset assetWithURL:videoUrl];
            Float64 durationSeconds = CMTimeGetSeconds([avAsset duration]);
            NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
            if (self.didRecordVideo) {
                LXFMediaImage *mediaImage = [[LXFMediaImage alloc] init];
                mediaImage.thumb = movieImage;
                mediaImage.videoTime = durationSeconds;
                mediaImage.videoId = [NSString stringWithFormat:@"%@", [NSDate dateToStrStyle7WithDate:NSDate.date]];
                if ([LXFFileManager saveImageWithImageData:videoData andName:mediaImage.videoId]) {
                    mediaImage.videoUrl = [LXFFileManager fetchImageFileUrlWithImageName:mediaImage.videoId];
                }
                mediaImage.orgData = videoData;
                self.didRecordVideo(mediaImage);
            }
            [self backButtonEvent];
        }];
    }else {
        NSLog(@"请先录制视频~");
    }
}

- (void)recordActionTouchDown {
    if (self.allowRecord) {
        self.recordBtn.selected = YES;
        if (self.recordEngine.isCapturing) {
            [self.recordEngine resumeCapture];
        }else {
            [[LXFDeviceManager sharedInstance] shutDeviceDelegate];
            [self.recordEngine startCapture];
        }
    }
}

- (void)recordActionTouchUp {
    [self recordNextAction];
}

- (void)flashLightAction {
    if (self.changeCameraButton.selected == YES) { return; }
    
    self.flashLightBtn.selected = !self.flashLightBtn.selected;
    if (self.flashLightBtn.selected == YES) {
        [self.recordEngine openFlashLight];
    }else {
        [self.recordEngine closeFlashLight];
    }
}

- (void)changeCameraButtonEvent {
    self.changeCameraButton.selected = !self.changeCameraButton.selected;
    if (self.changeCameraButton.selected == YES) {
        //前置摄像头
        [self.recordEngine closeFlashLight];
        self.flashLightBtn.selected = NO;
    }
    self.flashLightBtn.enabled = !self.changeCameraButton.selected;
    [self.recordEngine changeCameraInputDeviceisFront:self.changeCameraButton.selected];
}

#pragma mark - Lazy
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backBtn setImage:[UIImage imageNamed:@"LXFRecord_arrow_left_white.png"] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
        [_backBtn addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"LXFRecord_recordbtn.png"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordActionTouchDown) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(recordActionTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_recordBtn];
    }
    return _recordBtn;
}

- (UIButton *)flashLightBtn {
    if (!_flashLightBtn) {
        _flashLightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_flashLightBtn setImage:[UIImage imageNamed:@"LXFRecord_flashOff.png"] forState:UIControlStateNormal];
        [_flashLightBtn setImage:[UIImage imageNamed:@"LXFRecord_flashOn.png"] forState:UIControlStateSelected];
        [_flashLightBtn addTarget:self action:@selector(flashLightAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_flashLightBtn];
    }
    return _flashLightBtn;
}

- (UIButton *)changeCameraButton {
    if (!_changeCameraButton) {
        _changeCameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_changeCameraButton setImage:[UIImage imageNamed:@"LXFRecord_changeCamera.png"] forState:UIControlStateNormal];
        [_changeCameraButton addTarget:self action:@selector(changeCameraButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeCameraButton];
    }
    return _changeCameraButton;
}

- (WCLRecordProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WCLRecordProgressView alloc] init];
        _progressView.progressBgColor = UIColor.grayColor;
        _progressView.progressColor = UIColor.redColor;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (WCLRecordEngine *)recordEngine {
    if (!_recordEngine) {
        _recordEngine = [[WCLRecordEngine alloc] init];
        _recordEngine.previewLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:_recordEngine.previewLayer atIndex:0];
        [_recordEngine resizeOrientationWithAVCaptureVideoOrientation:[self videoOrientationFromDeviceOrientation]];
        
        __weak typeof(self) mself = self;
        _recordEngine.fetchBackCameraFailed = ^(NSError *error){
            //获取后置摄像头失败
            if (error.code == -11852) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在iOS\"设置\"-\"隐私\"-\"相机\"中打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.userInfo[NSLocalizedDescriptionKey] message:error.userInfo[NSLocalizedFailureReasonErrorKey] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }
        };
        _recordEngine.fetchFrontCameraFailed = ^(NSError *error){
            //获取前置摄像头失败
            if (error.code == -11852) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在iOS\"设置\"-\"隐私\"-\"相机\"中打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.userInfo[NSLocalizedDescriptionKey] message:error.userInfo[NSLocalizedFailureReasonErrorKey] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }
        };
        _recordEngine.fetchMicrophoneFailed = ^(NSError *error){
            //获取麦克风失败
            if (error.code == -11852) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用麦克风" message:@"请在iOS\"设置\"-\"隐私\"-\"麦克风\"中打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.userInfo[NSLocalizedDescriptionKey] message:error.userInfo[NSLocalizedFailureReasonErrorKey] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }
        };
        _recordEngine.recordVideoError = ^(NSString *error) {
            NSLog(@"录制失败");
        };
        
        _recordEngine.delegate = self;

    }
    return _recordEngine;
}

#pragma mark - ManagerFunction
- (AVCaptureVideoOrientation)videoOrientationFromDeviceOrientation {
    if ([LXFDeviceManager sharedInstance].deviceOrientation == UIInterfaceOrientationPortrait) {
        return AVCaptureVideoOrientationPortrait;
    }
    if ([LXFDeviceManager sharedInstance].deviceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeLeft;
    }
    if ([LXFDeviceManager sharedInstance].deviceOrientation == UIInterfaceOrientationLandscapeRight) {
        return AVCaptureVideoOrientationLandscapeRight;
    }
    if ([LXFDeviceManager sharedInstance].deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    return AVCaptureVideoOrientationPortrait;
}

@end
