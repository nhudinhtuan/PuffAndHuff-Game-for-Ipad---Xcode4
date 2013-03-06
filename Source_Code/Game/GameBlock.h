//
//  GameBlock.h
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"

@interface GameBlock : GameObject {
    UITapGestureRecognizer *singleTap;
    int type;
}
@property (nonatomic, readonly) UITapGestureRecognizer *singleTap;

- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d;
// EFFECTS: Constructs a new GameBlock. 

- (void)tap:(UITapGestureRecognizer *)gesture;
// MODIFIES: object model (path)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: change the type of the block

- (void)setPhysicalEngine;
- (void)removeAllGestureRecognizers;
@end
