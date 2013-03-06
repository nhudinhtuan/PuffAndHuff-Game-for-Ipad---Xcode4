//
//  GameWolf.h
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
#import "GamePower.h"
#import "GameArrow.h"
#import "GameWind.h"

@interface GameWolf : GameObject {
    UILongPressGestureRecognizer *press;
    NSMutableArray *wolfFrameAnimation;
    GamePower *power;
    GameArrow *arrow;
    GameWind *wind;
    NSTimer* timer;
    int typeOfWind;
    int skill;
}
@property (nonatomic, strong) UILongPressGestureRecognizer *press;
@property (nonatomic, strong) GamePower *power;
@property (nonatomic, strong) GameArrow *arrow;
@property (nonatomic, strong) GameWind *wind;
@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, readwrite) int typeOfWind;
@property (nonatomic, readwrite) int skill;

- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d;
// EFFECTS: Constructs a new GameWolf

- (void)press:(UIGestureRecognizer *)gesture;
// REQUIRES: game in designer mode, object in game area, game started
// EFFECTS: change the power of wind and call method to breathe

- (void)setPhysicalEngine;
- (void)updatePosition;
- (CGPoint)positionOfMouth;

- (void)initBreath;
- (void)startBreath;
- (void)stopBreath;
- (BOOL)setTypeWind:(int)type;
- (void)die;
@end
