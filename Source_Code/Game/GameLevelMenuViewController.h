//
//  GameLevelMenuViewController.h
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameLevel.h"
#import "GameDatabaseAccess.h"
#import "GamePlayViewController.h"

@interface GameLevelMenuViewController : UIViewController {
    GameLevelModel *selectedLevel;
    NSMutableArray *listOfLevels;
}

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIView *levelFrameView;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *addLevelButton;
@property (weak, nonatomic) IBOutlet UIScrollView *levelArea;
@property (strong, nonatomic) NSMutableArray *listOfLevels;

@end
