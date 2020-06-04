//
//  LXFRecordVideo.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFRecordVideo.h"
#import "LXFRecordVideoViewController.h"

@implementation LXFRecordVideo

- (void)showInViewController:(UIViewController *)viewController didRecordVideo:(void (^)(LXFMediaImage *mediaImage))callback {
    
    LXFRecordVideoViewController *vc = [[LXFRecordVideoViewController alloc] init];
    vc.didRecordVideo = ^(LXFMediaImage * _Nonnull mediaImage) {
        callback(mediaImage);
    };
    [viewController presentViewController:vc animated:YES completion:nil];
}

@end
