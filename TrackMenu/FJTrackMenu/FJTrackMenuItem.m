//
//  FJTrackMenuItem.m
//  TrackMenu
//
//  Created by fengjia on 13-11-20.
//  Copyright (c) 2013年 fengjia. All rights reserved.
//

#import "FJTrackMenuItem.h"
#import <QuartzCore/QuartzCore.h>
#define ITEM_HEIGHT         60
#define ITEM_IMAGE_HEIGHT   40
#define ITEM_IMAGE_WIDTH    40
@interface FJTrackMenuItem() {
}
- (float)systemVerson;
@end

@implementation FJTrackMenuItem
@synthesize titleLabel;

- (void)dealloc {
    [titleLabel release];
    [selectBlock release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image {
    self = [self initWithFrame:frame];
    if (self) {
        CGSize  size = [title sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(320, 40)];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width * 2 + 10 + ITEM_IMAGE_WIDTH, ITEM_HEIGHT)];
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        self.frame = backView.frame;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, size.width * 2, 22)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor blackColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.cornerRadius = 10;
        titleLabel.layer.masksToBounds = YES;
//        [titleLabel sizeToFit];
        [backView addSubview:titleLabel];
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(size.width * 2 + 10, 10, ITEM_IMAGE_WIDTH, ITEM_IMAGE_HEIGHT);
        [imageButton setImage:image forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:imageButton];
        
        [backView release];
    }
    return self;
}

- (void)selectMenuItemAtIndex:(int)index block:(SelectMenuItemBlock)block {
    selectBlock = [block copy];
    curIndex = index;
}

- (void)clickButton:(id)sender {
    selectBlock(curIndex);
//    [selectBlock release];
}
- (float)systemVerson {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
@end
