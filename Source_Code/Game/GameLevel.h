//
//  GameLevel.h
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameLevelModel.h"
#import "constant.h"

@interface GameLevel : UIViewController{
    GameLevelModel *model;
    UIImageView *view;
    UIImageView *editButton;
}

@property (nonatomic, strong) GameLevelModel *model;
@property (nonatomic, strong) UIImageView *view;
@property (nonatomic, strong) UIImageView *editButton;

- (id)initWithModel:(GameLevelModel *)levelModel position:(int)position;
// EFFECTS: Constructs a new GameLevelLevel

@end
