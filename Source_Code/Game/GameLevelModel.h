//
//  GameLevelModel.h
//  Game
//
//  Created by DINH TUAN NHU on 26/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLevelModel : NSObject {
    int levelId;
    NSString *name;
    int highScore;
    int wolfSKill;
    NSString *background;
}

@property (nonatomic, readonly) int levelId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readwrite) int highScore;
@property (nonatomic, readwrite) int wolfSKill;
@property (nonatomic, strong) NSString *background;

- (id)initWithKey:(int)key name:(NSString *)levelName highScore:(int)levelScore wolfSkill:(int)levelWolfSkill background:(NSString *)gameBackground;
// EFFECTS: Constructs a new GameLevelModel


@end
