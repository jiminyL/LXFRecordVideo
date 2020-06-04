//
//  LXFDeviceManager.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CMMotionManager;

NS_ASSUME_NONNULL_BEGIN

@interface LXFDeviceManager : NSObject

@property (nonatomic) UIInterfaceOrientation deviceOrientation;

@property (nonatomic, strong) CMMotionManager *motionManager;

+ (LXFDeviceManager *)sharedInstance;

@property (nonatomic, copy) void (^sharkActionCallback)(void);

- (void)setupDeviceDelegate;
- (void)shutDeviceDelegate;

@end

NS_ASSUME_NONNULL_END
