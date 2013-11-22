//
//  FJTrackMenuItem.h
//  TrackMenu
//
//  Created by fengjia on 13-11-20.
//  Copyright (c) 2013年 fengjia. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SelectMenuItemBlock)(int menuItemIndex);
@interface FJTrackMenuItem : UIView {
    SelectMenuItemBlock selectBlock;
    int curIndex;
}
@property (nonatomic, retain) UILabel *titleLabel;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image;
- (void)selectMenuItemAtIndex:(int)index block:(SelectMenuItemBlock)block;
@end
