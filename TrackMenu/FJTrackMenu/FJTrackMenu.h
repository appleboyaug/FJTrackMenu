//
//  FJTrackMenu.h
//  TrackMenu
//
//  Created by fengjia on 13-11-20.
//  Copyright (c) 2013年 fengjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FJTrackMenuItem.h"
typedef NS_ENUM(NSInteger, FJTrackMenuDirection) {
    FJTrackMenuDirectionLeft = 0,
    FJTrackMenuDirectionRight
};



@interface FJTrackMenu : NSObject

- (id)initWithTitles:(NSArray *)titles
              images:(NSArray *)images
              inView:(UIView *)inView;

- (void)showMenuAtPosition:(CGPoint)postion
        trackMenuDirection:(FJTrackMenuDirection)menuDirection
          onSelectMenuItem:(SelectMenuItemBlock)block;


@end
