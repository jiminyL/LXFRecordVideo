//
//  LXFDeviceManager.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFDeviceManager.h"

#import <CoreMotion/CoreMotion.h>

@interface LXFDeviceManager()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LXFDeviceManager

+ (LXFDeviceManager *)sharedInstance {
    static LXFDeviceManager* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)shutDeviceDelegate
{
    [self.motionManager stopAccelerometerUpdates];
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setupDeviceDelegate
{
    self.motionManager = [[CMMotionManager alloc]init];
    
    self.motionManager.accelerometerUpdateInterval = 0.01f;
    
    [self.motionManager startAccelerometerUpdates];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(shackAction) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)shackAction
{
    // Get the current device angle
    float xx = -self.motionManager.accelerometerData.acceleration.x;
    float yy = self.motionManager.accelerometerData.acceleration.y;
    float angle = atan2(yy, xx);
    // Read my blog for more details on the angles. It should be obvious that you
    // could fire a custom shouldAutorotateToInterfaceOrientation-event here.
    if(angle >= -2.25 && angle <= -0.25)
    {
        if(self.deviceOrientation != UIInterfaceOrientationPortrait)
        {
            self.deviceOrientation = UIInterfaceOrientationPortrait;
        }
    }
    else if(angle >= -1.75 && angle <= 0.75)
    {
        if(self.deviceOrientation != UIInterfaceOrientationLandscapeRight)
        {
            self.deviceOrientation = UIInterfaceOrientationLandscapeRight;
        }
    }
    else if(angle >= 0.75 && angle <= 2.25)
    {
        if(self.deviceOrientation != UIInterfaceOrientationPortraitUpsideDown)
        {
            self.deviceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        }
    }
    else if(angle <= -2.25 || angle >= 2.25)
    {
        if(self.deviceOrientation != UIInterfaceOrientationLandscapeLeft)
        {
            self.deviceOrientation = UIInterfaceOrientationLandscapeLeft;
        }
    }
    
    if (self.sharkActionCallback) {
        self.sharkActionCallback();
    }
}


@end
