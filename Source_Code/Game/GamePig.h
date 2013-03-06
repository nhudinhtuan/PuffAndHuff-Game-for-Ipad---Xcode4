//
//  GamePig.h
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"

@interface GamePig : GameObject{
    int health;
    BOOL inDestroyProcess;
    NSMutableArray *pigDieAnimation;
}
@property (nonatomic, readonly) BOOL inDestroyProcess;
@property (nonatomic, readwrite) int health;
- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d;
// EFFECTS: Constructs a new GamePig. 

- (void)setPhysicalEngine;
- (void)reduceHeath:(float)number;
@end
