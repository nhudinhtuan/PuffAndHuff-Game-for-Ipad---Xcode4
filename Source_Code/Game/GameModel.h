//
//  GameModel.h
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants for the three game objects to be implemented
typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock} GameObjectType;

@interface GameModel : NSObject {
    GameObjectType type;
    int subType;
    CGPoint center;
    CGFloat rotation;
    CGFloat scale;
}

@property (nonatomic, assign) GameObjectType type;
@property (nonatomic, readwrite) int subType;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;

- (id)initWithType:(GameObjectType)mType subType:(int)mSubType center:(CGPoint)mCenter rotation:(CGFloat)mRotation scale:(CGFloat)mScale;
// EFFECTS: constructs a new GameModel
@end
