//
//  GameModel.m
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel
@synthesize type, subType, center, rotation, scale;

- (id)initWithType:(GameObjectType)mType subType:(int)mSubType center:(CGPoint)mCenter rotation:(CGFloat)mRotation scale:(CGFloat)mScale {
    // EFFECTS: constructs a new GameModel
    
    type = mType;
    subType = mSubType;
    center = mCenter;
    rotation = mRotation;
    scale = mScale;
    return self;
}

@end
