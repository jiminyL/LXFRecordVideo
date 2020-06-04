//
//  ViewController.m
//  LXFRecordVideo
//
//  Created by 梁啸峰 on 2020/6/4.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "ViewController.h"
#import "LXFRecordVideo.h"


@interface ViewController ()

@property (nonatomic, strong) LXFRecordVideo *recordVideo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.recordVideo showInViewController:self didRecordVideo:^(LXFMediaImage * _Nonnull mediaImage) {
        
    }];
}

- (LXFRecordVideo *)recordVideo {
    if (!_recordVideo) {
        _recordVideo = [[LXFRecordVideo alloc] init];
    }
    return _recordVideo;
}


@end
