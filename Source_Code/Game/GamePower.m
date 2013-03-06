//
//  GamePower.m
//  Game
//
//  Created by DINH TUAN NHU on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GamePower.h"

@implementation GamePower
@synthesize power;
@synthesize changeSign;
@synthesize view;
@synthesize timer;
@synthesize powerAnimation;

- (id)initWithPosition:(CGPoint)position {
    
    power = POWER_MIN;
    UIImage *powerImg = [UIImage imageNamed:BREATHE_BAR_IMG];
    view = [[UIImageView alloc] initWithImage:powerImg];
    view.frame = CGRectMake(position.x, position.y, powerImg.size.width, powerImg.size.height);
    changeSign = 1;
    
    powerAnimation = [[UIView alloc] initWithFrame:CGRectMake(POWER_ANIMATION_POSITION_X, POWER_ANIMATION_POSITION_Y, power, POWER_HEIGHT)];
    powerAnimation.backgroundColor = [UIColor blueColor];
    powerAnimation.layer.cornerRadius = 5.0;
    [view addSubview:powerAnimation];
    return self;
}


- (void)changePower {
    
    if (power < POWER_MAX) {
        power += POWER_CHANGE_STEP;
    }
    powerAnimation.frame = CGRectMake(POWER_ANIMATION_POSITION_X, POWER_ANIMATION_POSITION_Y, power, powerAnimation.frame.size.height);
}

- (void)startChangePower {
    
    power = POWER_MIN;
    powerAnimation.frame = CGRectMake(POWER_ANIMATION_POSITION_X, POWER_ANIMATION_POSITION_Y, power, powerAnimation.frame.size.height);
    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(changePower) userInfo:nil repeats:YES];
}
- (void)endChangePower {
    
    [timer invalidate];
}
@end
