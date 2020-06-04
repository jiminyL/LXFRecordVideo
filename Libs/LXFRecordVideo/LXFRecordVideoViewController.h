//
//  LXFRecordVideoViewController.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFMediaImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFRecordVideoViewController : UIViewController

@property (nonatomic, copy) void (^didRecordVideo)(LXFMediaImage *mediaImage);

@end

NS_ASSUME_NONNULL_END
