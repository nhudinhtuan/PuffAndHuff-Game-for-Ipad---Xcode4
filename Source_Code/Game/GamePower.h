//
//  GamePower.h
//  Game
//
//  Created by DINH TUAN NHU on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "constant.h"

@interface GamePower : UIViewController{
    UIImageView *view;
    UIView *powerAnimation;
    int power;
    int changeSign;
    NSTimer* timer;
}
@property (nonatomic, readonly) int power;
@property (nonatomic, readonly) int changeSign;
@property (nonatomic, strong) UIImageView *view;
@property (nonatomic, strong) UIView *powerAnimation;
@property (nonatomic, strong) NSTimer* timer;
- (id)initWithPosition:(CGPoint)position;
- (void)changePower;
- (void)startChangePower;
- (void)endChangePower;
@end
