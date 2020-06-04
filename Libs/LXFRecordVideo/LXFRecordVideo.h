//
//  LXFRecordVideo.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LXFMediaImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFRecordVideo : NSObject

- (void)showInViewController:(UIViewController *)viewController didRecordVideo:(void (^)(LXFMediaImage *mediaImage))callback;

@end

NS_ASSUME_NONNULL_END
