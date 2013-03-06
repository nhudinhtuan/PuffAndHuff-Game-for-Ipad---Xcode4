//
//  GamePlayViewController.h
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "GameLevelModel.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"
#import "GameArrow.h"
#import "GamePower.h"
#import "GameDatabaseAccess.h"
#import "GameDialogViewController.h"


@interface GamePlayViewController : UIViewController<GameObjectDelegate> {
    
    GameLevelModel *model;
    int score;
    int remainPig;
    NSMutableArray *objects;
    GameWolf *gameWolf;
    ChipmunkSpace *space;
    CADisplayLink *displayLink;
    GameDialogViewController *dialog;
    BOOL isInEndGameProcess;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *gamearea;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *wolfSkillLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wolfSkillImgView;
@property (weak, nonatomic) IBOutlet UIImageView *windType0View;
@property (weak, nonatomic) IBOutlet UIImageView *windType1View;
@property (weak, nonatomic) IBOutlet UIImageView *windType2View;
@property (weak, nonatomic) IBOutlet UIImageView *windType3View;
@property (weak, nonatomic) IBOutlet UILabel *windTypeSkillRequire;
@property (weak, nonatomic) IBOutlet UIImageView *windTypeSelectView;
@property (weak, nonatomic) IBOutlet UILabel *levelTitle;

@property (nonatomic, strong) GameLevelModel *model;
@property (readwrite, nonatomic) int score; 
@property (readonly, nonatomic) int remainPig;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) GameWolf *gameWolf;
@property (nonatomic, strong) ChipmunkSpace *space;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) GameDialogViewController *dialog;


// Chipmunk Physics collision handles
- (void)separateCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
- (bool)beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
- (void)windCollidesBlock:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
- (void)windCollidesBorder:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
- (void)blockCollidesPig:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

- (void)reset;
// EFFECTS: reset the game.

- (void)pigDied;
// MODIFIES: reduce the remaining number of pig
//           call endGame if there is no pig alive.

- (void)backLevelList;
// EFFECTS: back to the GameLevelMenueViewController.

- (id)getObjectFromBody:(ChipmunkBody *)body;
// REQUIRES: shape is a shape of GameObject and in the space.
// EFFECTS: return a GameObject which the shape belongs to.

- (void)showDialogNotEnoughSkill;
// EFFECTS: display a dialog box to alert the wolf don't have enough skills.

- (void)endGame;
// EFFECTS: end game and show score.
@end
