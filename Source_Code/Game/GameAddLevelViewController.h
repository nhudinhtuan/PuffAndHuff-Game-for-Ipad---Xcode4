//
//  GameAddLevelViewController.h
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constant.h"
#import "GameDatabaseAccess.h"
#import "GameDialogViewController.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"
#import "GameArrow.h"
#import "GamePower.h"

@interface GameAddLevelViewController : UIViewController<GameObjectDelegate> {
    GameLevelModel *model;
    GameDialogViewController *dialog;
    NSMutableArray *objects;
    GameWolf *gameWolf;
}
@property (nonatomic, strong) GameLevelModel *model;
@property (nonatomic, strong) GameDialogViewController *dialog;
@property (nonatomic, strong) GameWolf *gameWolf;
@property (nonatomic, strong) NSMutableArray *objects;
@property (weak, nonatomic) IBOutlet UIScrollView *gamearea;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UIView *palette;
@property (weak, nonatomic) IBOutlet UIImageView *resetButton;
@property (weak, nonatomic) IBOutlet UIImageView *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *BG1_button;
@property (weak, nonatomic) IBOutlet UIImageView *BG2_button;
@property (weak, nonatomic) IBOutlet UIImageView *BG3_button;
@property (weak, nonatomic) IBOutlet UIImageView *BG4_button;

- (void)back:(UITapGestureRecognizer *)gesture;
- (void)resetRecoginer:(UITapGestureRecognizer *)gesture;
- (void)reset;
- (void)tapSaveButton:(UITapGestureRecognizer *)gesture;
- (void)tapDeleteButton:(UITapGestureRecognizer *)gesture;
- (void)save;
- (void)deleteLevel;
@end
