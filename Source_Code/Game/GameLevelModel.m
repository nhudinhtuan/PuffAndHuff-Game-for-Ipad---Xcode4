//
//  GameLevelModel.m
//  Game
//
//  Created by DINH TUAN NHU on 26/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameLevelModel.h"

@implementation GameLevelModel
@synthesize levelId;
@synthesize name;
@synthesize highScore;
@synthesize wolfSKill;
@synthesize background;

- (id)initWithKey:(int)key name:(NSString *)levelName highScore:(int)levelScore wolfSkill:(int)levelWolfSkill background:(NSString *)gameBackground{
    // EFFECTS: Constructs a new GameLevelModel
    
    levelId = key;
    name = levelName;
    highScore = levelScore;
    wolfSKill = levelWolfSkill;
    background = gameBackground;
    return self;
}

@end
