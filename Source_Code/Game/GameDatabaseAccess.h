//
//  GameDatabaseAccess.h
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "GameLevelModel.h"
#import "GameModel.h"

@interface GameDatabaseAccess : NSObject {
    sqlite3 *database;
}

- (id)init;

- (NSArray *)getListOfLevels;
// EFFECTS: return a NSArray of all GameLevelModels in the database.

- (NSArray *)getLevelDetails:(int)levelId;
// EFFECTS: return a NSArray of all GameModels in the level with levelId.

- (void)deleteLevel:(int)levelId;
// EFFECTS: delete the level.

- (void)updateHighScore:(int)newHighScore levelId:(int)levelId;
// EFFECTS: update the new high score for the level into the database.

- (void)updateLevelWithLevelModel:(GameLevelModel *)levelModel gameModels:(NSArray *)gameModels;
// REQUIRES: levelModel is not nil
// EFFECTS: add or update a level with GameLevelModel.

+ (NSString *)sqlInsertStringFormatFromGameModels:(NSArray *)gameModels levelId:(int)levelId;
// REQUIRES: gameModels and levelId is not nil.
// EFFECTS: return the sql query to insert a list of gameModels into LevelDetails table.
@end
