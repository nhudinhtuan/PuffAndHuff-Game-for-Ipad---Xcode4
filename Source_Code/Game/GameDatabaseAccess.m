//
//  GameDatabaseAccess.m
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameDatabaseAccess.h"
#import "constant.h"

@implementation GameDatabaseAccess

- (id)init {
    
    self = [super init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *writableDBPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_NAME];
    
    // if the database does not exist, copy the default to the appropriate location.
    if (![[NSFileManager defaultManager] fileExistsAtPath:writableDBPath]) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
        
        // copy unsuccessfully
        if (![[NSFileManager defaultManager] copyItemAtPath:defaultDBPath toPath:writableDBPath error:nil]) {
            return nil;
        }
    }
    
    // init database
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_NAME];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        return self;
    } else {
        return nil;
    }
}


- (NSArray *)getListOfLevels {
    // EFFECTS: return a NSArray of all GameLevelModels in the database.
    
    if (self) {
        const char *sql = "SELECT * FROM GameLevels";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            NSMutableArray *gameLevelModels = [[NSMutableArray alloc] init];
            int count = 0;
            NSString *background;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                if (!sqlite3_column_text(statement, 4)) {
                    background = DEFAULT_BACKGROUND;
                } else {
                    background = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                }
                GameLevelModel *level = [[GameLevelModel alloc] initWithKey:sqlite3_column_int(statement, 0) 
                                                                 name:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] 
                                                            highScore:sqlite3_column_int(statement, 2) 
                                                            wolfSkill:sqlite3_column_int(statement, 3) 
                                                            background:background];
                [gameLevelModels addObject:level];
                count++;
            }
            return [[NSArray alloc] initWithArray:gameLevelModels];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSArray *)getLevelDetails:(int)levelId {
    // EFFECTS: return a NSArray of all GameModels in the level with levelId.
    
    if (self) {
        const char *sql = [[NSString stringWithFormat: @"SELECT * FROM LevelDetails WHERE level_id = %d", levelId] UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            NSMutableArray *gameModels = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int type = sqlite3_column_int(statement, 2);
                int subType = sqlite3_column_int(statement, 3);
                CGPoint center = CGPointMake(sqlite3_column_double(statement, 4), sqlite3_column_double(statement, 5));
                float rotationAngle = sqlite3_column_double(statement, 6);
                float scale = sqlite3_column_double(statement, 7);
                [gameModels addObject:[[GameModel alloc] initWithType:type 
                                                              subType:subType 
                                                               center:center 
                                                             rotation:rotationAngle 
                                                                scale:scale]];
            }
            return [[NSArray alloc] initWithArray:gameModels];
        } else {
            return nil;
        }
    } else {
        return nil;
    }  
}

- (void)deleteLevel:(int)levelId{
    // EFFECTS: delete the level.
    
    // delete game level information
    const char *sql = [[NSString stringWithFormat: @"DELETE FROM GameLevels WHERE id = %d", levelId] UTF8String];
    sqlite3_exec(database, sql, NULL, NULL, NULL) ;
    
    // delete game level details
    sql = [[NSString stringWithFormat: @"DELETE FROM LevelDetails WHERE level_id = %d", levelId] UTF8String];
    sqlite3_exec(database, sql, NULL, NULL, NULL) ;
}

- (void)updateHighScore:(int)newHighScore levelId:(int)levelId {
    // EFFECTS: update the new high score for the level with levelId in the database.
    
    const char *sql = [[NSString stringWithFormat: @"UPDATE GameLevels SET high_score = %d WHERE id = %d", newHighScore, levelId] UTF8String];
    sqlite3_exec(database, sql, NULL, NULL, NULL) ;
}


- (void)updateLevelWithLevelModel:(GameLevelModel *)levelModel gameModels:(NSArray *)gameModels {
    // REQUIRES: levelModel is not nil
    // EFFECTS: add or update a level with GameLevelModel.
    
    if (self && gameModels.count > 1) {
        const char *sql;
        
        // if levelId is not 0, update the old level
        if (levelModel.levelId) {
            sql = [[NSString stringWithFormat: @"UPDATE GameLevels SET name = \"%@\", high_score = %d, wolf_skill = %d, background = \"%@\" WHERE id = %d", levelModel.name, 0, levelModel.wolfSKill, levelModel.background, levelModel.levelId] UTF8String];
        } else {
            sql = [[NSString stringWithFormat: @"INSERT INTO GameLevels (name, high_score, wolf_skill, background) VALUES (\"%@\", %d, %d, \"%@\")", levelModel.name, 0, levelModel.wolfSKill, levelModel.background] UTF8String];
        }
        
        // update GameLevelModel information
        if (sqlite3_exec(database, sql, NULL, NULL, NULL) == SQLITE_OK) {
            int levelId = levelModel.levelId;
            if (levelId) {
                sql = [[NSString stringWithFormat: @"DELETE FROM LevelDetails WHERE level_id = %d", levelId] UTF8String];
                // delete the old data
                sqlite3_exec(database, sql, NULL, NULL, NULL);
            } else {
                levelId = sqlite3_last_insert_rowid(database);
            }
            
            //add new data in GameDetails
            sql = [[GameDatabaseAccess sqlInsertStringFormatFromGameModels:gameModels levelId:levelId] UTF8String];
            sqlite3_exec(database, sql, NULL, NULL, NULL);
        } 
    } 
}

+ (NSString *)sqlInsertStringFormatFromGameModels:(NSArray *)gameModels levelId:(int)levelId{
    // REQUIRES: gameModels and levelId is not nil.
    // EFFECTS: return the sql query to insert a list of gameModels into LevelDetails table.
    
    GameModel *model = [gameModels objectAtIndex:0];
    NSMutableString *sqlString = [NSMutableString stringWithFormat: @"INSERT INTO LevelDetails (level_id , type, sub_type, center_x, center_y, rotation, scale) SELECT '%d', '%d', '%d', '%f', '%f', '%f', '%f' ", levelId, model.type, model.subType, model.center.x, model.center.y, model.rotation, model.scale];
    
    for (int i = 1; i < gameModels.count ; i++) {
        GameModel *model = [gameModels objectAtIndex:i];
        [sqlString appendFormat:@" UNION SELECT '%d', '%d', '%d', '%f', '%f', '%f', '%f'", levelId, model.type, model.subType, model.center.x, model.center.y, model.rotation, model.scale];
    }
    // NSLog(@"query string: %@", sqlString);
    return sqlString;
}

@end
