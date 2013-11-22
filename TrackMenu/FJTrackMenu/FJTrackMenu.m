//
//  FJTrackMenu.m
//  TrackMenu
//
//  Created by fengjia on 13-11-20.
//  Copyright (c) 2013年 fengjia. All rights reserved.
//

#import "FJTrackMenu.h"
#import "FJTrackMenuItem.h"

#define MENUITEM_INTERVAL_X  10

@interface FJTrackMenu () {
@private
    UIControl *backgroundView; //作为背景，响应 touch 事件
    UIView *backView;
    
    UIView *parentView;
    NSMutableArray *menuItems;
    CGPoint startPosition;
}
@end
@implementation FJTrackMenu

- (void)dealloc {
    [backgroundView release]; backgroundView = nil;
    [parentView release]; parentView = nil;
    [menuItems release]; menuItems = nil;
    [super dealloc];
}
- (id)initWithTitles:(NSArray *)titles
              images:(NSArray *)images
              inView:(UIView *)inView {
    if ([titles count] == 0) {
        NSLog(@"menu title 不能为空!");
        return nil;
    }
    if (!inView) {
        NSLog(@"inView 父类 view 不能为空");
        return nil;
    }
    if (self = [super init]) {
        parentView = [inView retain];
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.bounds = inView.bounds;
        backView.center = inView.center;
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6;
        [parentView addSubview:backView];
        
        
        backgroundView = [[UIControl alloc] initWithFrame:CGRectZero];
        backgroundView.bounds = inView.bounds;
        backgroundView.center = inView.center;
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.alpha = 0.8;
        [backgroundView addTarget:self action:@selector(touchBackView:) forControlEvents:UIControlEventTouchUpInside];
        menuItems = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < [titles count]; i++) {
            CGRect dRect = CGRectMake(0, 0, 150, 60);
            FJTrackMenuItem *menuItem = [[FJTrackMenuItem alloc] initWithFrame:dRect title:[titles objectAtIndex:i] image:[UIImage imageNamed:[images objectAtIndex:i]]];
            [menuItems addObject:menuItem];
            [menuItem release];
        }
    }
    return self;
    
}

- (void)showMenuAtPosition:(CGPoint)position
        trackMenuDirection:(FJTrackMenuDirection)menuDirection
          onSelectMenuItem:(SelectMenuItemBlock)block {
    startPosition = position;
    [parentView addSubview:backgroundView];
    for (FJTrackMenuItem *menuItem in menuItems) {
        menuItem.titleLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
        menuItem.center = CGPointMake(position.x + 40 - menuItem.frame.size.width/2, position.y);
        [backgroundView insertSubview:menuItem atIndex:0];
        [menuItem selectMenuItemAtIndex:[menuItems indexOfObject:menuItem] block:^(int menuItemIndex) {
            block(menuItemIndex);
            [self hideMenu];
        }];
    }
    [UIView animateWithDuration:0.3 animations:^{
        float curX = 0;
        for (int i = 0; i < [menuItems count]; i++) {
            FJTrackMenuItem *item = [menuItems objectAtIndex:i];
            CGPoint center = item.center;
            curX = i * 3 + curX;
            center.x -= curX;
            center.y -= (i + 1) * 60;
            item.center = center;
            CGAffineTransform transform1 = CGAffineTransformMakeRotation(-M_PI/180 * (i * 3 + 3));
            CGAffineTransform transform2 = CGAffineTransformMakeScale(1, 1);
            CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
            item.transform = transform;
            item.titleLabel.transform = transform2;
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i < [menuItems count]; i++) {
            FJTrackMenuItem *item = [menuItems objectAtIndex:i];
            item.center = CGPointMake(startPosition.x + 40 - item.frame.size.width/2, startPosition.y);
            item.transform = CGAffineTransformMakeRotation(M_PI * 0);
            item.titleLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
            item.alpha = 0;
            backView.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [backView removeFromSuperview];
    }];
}

- (void)touchBackView:(id)sender {
    
    [self hideMenu];
}


- (void)addAnimationWithItem:(FJTrackMenuItem *)item radius:(float)radius angle:(int)angle atIndex:(int)index {
    
    float x1 = startPosition.x;
    float y1 = startPosition.y - tanf(angle/2 * M_PI/180) * radius;
    float x2 = startPosition.x - (radius - radius * cosf(angle * M_PI/180));
    float y2 = startPosition.y - radius * sinf(angle * M_PI/180);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPosition.x, startPosition.y);
    CGPathAddArcToPoint(path, NULL, x1, y1, x2, y2, radius);
    CGPathMoveToPoint(path, NULL, x2, y2);
    CGPathCloseSubpath(path);
    
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path = path;  //动画路线
    theAnimation.duration = 1;  //动画总时间
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.removedOnCompletion=NO;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CFRelease(path);
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation((index*2) *-M_PI/180, 0, 0, 1)]; //  基于Z轴同时旋转
    transformAnimation.duration = 1.5;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:1.5];
    [group setAnimations:[NSArray arrayWithObjects:theAnimation, transformAnimation, nil]];
    group.removedOnCompletion =NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    [item.layer addAnimation:group forKey:@"animationGroup"];
}

@end
