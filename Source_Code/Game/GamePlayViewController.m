//
//  GamePlayViewController.m
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GamePlayViewController.h"

@implementation GamePlayViewController
@synthesize model;
@synthesize mainView;
@synthesize gamearea;
@synthesize backButton;
@synthesize refreshButton;
@synthesize scoreLabel;
@synthesize wolfSkillLabel;
@synthesize wolfSkillImgView;
@synthesize windType0View;
@synthesize windType1View;
@synthesize windType2View;
@synthesize windType3View;
@synthesize windTypeSkillRequire;
@synthesize windTypeSelectView;
@synthesize levelTitle;
@synthesize dialog;
@synthesize objects;
@synthesize space;
@synthesize displayLink;
@synthesize gameWolf;
@synthesize score;
@synthesize remainPig;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage *bgImage;
    if (model.background && ![model.background isEqualToString:@""]) {
        bgImage = [UIImage imageNamed:model.background];
    } else {
        bgImage = [UIImage imageNamed:DEFAULT_BACKGROUND];
    }
    
    // Get the width and height of the two images
    CGFloat backgroundWidth = bgImage.size.width;
    CGFloat backgroundHeight = bgImage.size.height;
    
    //place each of them in an UIImageView
    UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];

    //the frame property holds the position and size of the views
    //the CGRectMake methods arguments are : x position, y position, width,
    //height
    background.frame = CGRectMake(0, 0, backgroundWidth, backgroundHeight);
    
    //add the view as subviews of the gamearea.
    [gamearea addSubview:background];
    
    //set the content size so that gamearea is scrollable
    //otherwise it defaults to the current window size
    [gamearea setContentSize:CGSizeMake(backgroundWidth, backgroundHeight)];
    gamearea.canCancelContentTouches = NO;
    
    
    //------Game Objects initialization------//
    objects = [[NSMutableArray alloc] init]; 
    
    // init a dialog object.
    dialog = [[GameDialogViewController alloc] init];
    
    
    // add tap gesture recognizer to blackButton.
    backButton.userInteractionEnabled = YES;
    [backButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    // add tap gesture recognizer to refreshButton.
    refreshButton.userInteractionEnabled = YES;
    [refreshButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRefreshButton:)]];
    
    
    // add tap gesture recognizer to windTypeViews, allow users to select different type of winds
    [windType0View addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWindTypeView:)]];
    [windType1View addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWindTypeView:)]];
    [windType2View addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWindTypeView:)]];
    [windType3View addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWindTypeView:)]];
    
    
    // create a space for physical engine.
    space = [[ChipmunkSpace alloc] init];
    CGRect spaceBounds = CGRectMake(0, 0, backgroundWidth, backgroundHeight - GROUND_HEIGHT);
    // create a box around the screen - borders
    [space addBounds:spaceBounds thickness:10.0f elasticity:1.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:CHIPMUNKS_BORDER_TYPE];
    space.gravity = cpvmult(cpv(0.0, 1.0), 100.0f);
    
    
    //Collision handler for wind and border
    [space addCollisionHandler:self
                         typeA:[GameWind class] typeB:CHIPMUNKS_BORDER_TYPE
                         begin:@selector(beginCollision:space:)
                      preSolve:nil
                     postSolve:@selector(windCollidesBorder:space:)
                      separate:@selector(separateCollision:space:)];
    
    //Collision handler for wind and block
    [space addCollisionHandler:self
                         typeA:[GameWind class] typeB:[GameBlock class]
                         begin:@selector(beginCollision:space:)
                      preSolve:nil
                     postSolve:@selector(windCollidesBlock:space:)
                      separate:@selector(separateCollision:space:)];
    
    //Collision handler for wind and pig
    [space addCollisionHandler:self
                         typeA:[GameWind class] typeB:[GamePig class]
                         begin:@selector(beginCollision:space:)
                      preSolve:nil
                     postSolve:@selector(windCollidesPig:space:)
                      separate:@selector(separateCollision:space:)];
    
    //Collision handler for block and pig
    [space addCollisionHandler:self
                         typeA:[GameBlock class] typeB:[GamePig class]
                         begin:@selector(beginCollision:space:)
                      preSolve:nil
                     postSolve:@selector(blockCollidesPig:space:)
                      separate:@selector(separateCollision:space:)];
    
    
    //Collision handler for block and wolf
    [space addCollisionHandler:self
                         typeA:[GameBlock class] typeB:[GameWolf class]
                         begin:@selector(beginCollision:space:)
                      preSolve:nil
                     postSolve:@selector(blockCollidesWolf:space:)
                      separate:@selector(separateCollision:space:)];
    
    wolfSkillImgView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:WOLF_SKILL_LABEL_IMG], [UIImage imageNamed:WOLF_SKILL_LABEL_DEDUCT_IMG], nil];
    wolfSkillImgView.animationDuration = 1;
    wolfSkillImgView.animationRepeatCount = 1;
    
    windTypeSkillRequire.text = [NSString stringWithFormat:@"%dS", [GameWind getSkillRequiredOfType:0]];
    
    if (model.name) {
        levelTitle.text = model.name;
    }
    
    [self reset];
     
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // make the game loop using CADisplayLink
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    displayLink.frameInterval = 1;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    // add notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWolfSKill) 
                                                 name:@"updateWolfSkillOnGame"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showDialogNotEnoughSkill) 
                                                 name:@"showDialogNotEnoughSkillOnGame"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reset) 
                                                 name:@"resetGame"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backLevelList) 
                                                 name:@"backToLevelListFromPlayingGame"
                                               object:nil];
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    // remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"updateWolfSkillOnGame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"showDialogNotEnoughSkillOnGame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"resetGame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"backToLevelListFromPlayingGame" object:nil];
}


- (void)viewDidUnload {
    [self setBackButton:nil];
    [self setRefreshButton:nil];
    [self setScoreLabel:nil];
    [self setWolfSkillLabel:nil];
    [self setWolfSkillImgView:nil];
    [self setWindType0View:nil];
    [self setWindType1View:nil];
    [self setWindType2View:nil];
    [self setWindType3View:nil];
    [self setWindTypeSkillRequire:nil];
    [self setWindTypeSelectView:nil];
    [self setLevelTitle:nil];
    [self setMainView:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // only support Landscape
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)setScore:(int)newScore {
    // EFFECTS: set the new score and update on the view
    
    score = newScore;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
}

- (void)updateWolfSKill {
    // EFFECTS: update the skill of wolf on the view
    
    if (gameWolf) {
        [wolfSkillImgView startAnimating];
        wolfSkillLabel.text = [NSString stringWithFormat:@"%d", gameWolf.skill];
        
        // if the skill of wolf is not positive and the game is not in the ending process -> end game in 2 seconds.
        if (gameWolf.skill <= 0 && !isInEndGameProcess) {
            isInEndGameProcess = YES;
            // prevent touching guestures
            [dialog freezeScreen:self.view];
            [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(endGame)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
}


- (void)pigDied {
    // MODIFIES: reduce the remaining number of pig
    //           call endGame if there is no pig alive.
    
    remainPig--;
    if (remainPig <= 0 && !isInEndGameProcess) {
        isInEndGameProcess = YES;
        [dialog freezeScreen:self.view];
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(endGame)
                                       userInfo:nil
                                        repeats:NO];
    }
}


- (void)endGame {
    // EFFECTS: end game and show score.
    
    // win when all of pigs are killed.
    if (remainPig <= 0) {
        self.score = score + gameWolf.skill * SKILL_TO_SCORE;
        
        // if the score is a new high score, update to database
        if (score > model.highScore) {
            [[[GameDatabaseAccess alloc] init] updateHighScore:score levelId:model.levelId];
        }
        
        [dialog showEndGameDialog:self.view isWin:YES score:score highScore:model.highScore];
        
    // lose when wolf skills run out.
    } else {
        [gameWolf die];
        [dialog showEndGameDialog:self.view isWin:NO score:score highScore:model.highScore];
    }
}


- (void)showDialogNotEnoughSkill {
    // EFFECTS: display a dialog box to alert the wolf don't have enough skills.
    
    [dialog showMessageDiaglogWithImg:NOT_ENOUGH_SKILL_DIALOG_IMG superView:self.view];
}


- (void)back:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self backLevelList];
    }
}

- (void)backLevelList {
    // EFFECTS: back to the GameLevelMenueViewController.
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)reset {
    // EFFECTS: reset the game.
    
    self.score = 0;
    isInEndGameProcess = NO;
    remainPig = 0;
    
    // if it is not the first time loading, reset the type of wind to default, remove the old breathe bar
    if (gameWolf) {
        [gameWolf.power.view removeFromSuperview];
        windTypeSelectView.center = CGPointMake(windType0View.center.x, windTypeSelectView.center.y);
        windTypeSkillRequire.center = CGPointMake(windType0View.center.x, windTypeSkillRequire.center.y);
        windTypeSkillRequire.text = [NSString stringWithFormat:@"%dS", [GameWind getSkillRequiredOfType:0]];
    }
    
    //remove objects from view
    for (int i = [[gamearea subviews] count] - 1; i > 0; i--) {
        [[[gamearea subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    //remove objects from space
    for (int i = 0; i < objects.count; i++) {
        [self removeObjectFromSpace:[objects objectAtIndex:i]];
    }
    [objects removeAllObjects];
    
    
    // load game level details from database and add objects to view, space
    NSArray *gameModels = [[[GameDatabaseAccess alloc] init] getLevelDetails:model.levelId];
    GameObject *gameObject;
    for (int i = 0; i < gameModels.count; i++) {
        GameModel *gameModel = [gameModels objectAtIndex:i];
        if (gameModel.type == kGameObjectWolf) {
            gameWolf = [[GameWolf alloc] initWithModel:gameModel isInGameArea:YES delegate:self];
            gameWolf.skill = model.wolfSKill;
            gameObject = gameWolf;
        } else if (gameModel.type == kGameObjectPig) {
            remainPig++;
            gameObject = [[GamePig alloc] initWithModel:gameModel isInGameArea:YES delegate:self];    
        } else {
            gameObject = [[GameBlock alloc] initWithModel:gameModel isInGameArea:YES delegate:self];
        }
        [self addObject:gameObject];
        [gameObject setPhysicalEngine];
        [self addObjectToSpace:gameObject];
    }
    
    [self updateWolfSKill];
}

- (void)tapWindTypeView:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gameWolf) {
            int typeOfWind = 0;
            if (gesture.view == windType1View) {
                typeOfWind = 1;
            } else if (gesture.view == windType2View) {
                typeOfWind = 2;
            } else if (gesture.view == windType3View) {
                typeOfWind = 3;
            }
            
            if ([gameWolf setTypeWind:typeOfWind]) {
                windTypeSelectView.center = CGPointMake(gesture.view.center.x, windTypeSelectView.center.y);
                windTypeSkillRequire.center = CGPointMake(gesture.view.center.x, windTypeSkillRequire.center.y);
                windTypeSkillRequire.text = [NSString stringWithFormat:@"%dS", [GameWind getSkillRequiredOfType:typeOfWind]];
            } else {
                [self showDialogNotEnoughSkill];
            }
        }
    }
}

- (void)tapRefreshButton:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self reset];
    }
}


- (void)addObject:(GameObject *)object {
    
    [objects addObject:object];
}

- (void)removeObject:(GameObject *)object {
    // REQUIRES: Object is a subclass of GameObject.
    // EFFECTS: remove the object from static multable array objects
    
    [objects removeObject:object];
    
    // increase the score.
    if (object.model.type == kGameObjectBlock) {
        self.score += 10 * (object.model.subType + 1);
    } else if (object.model.type == kGameObjectPig) {
        self.score += 100;
        [self pigDied];
    }
}

- (void)addSubViewToGameArea:(UIImageView *)view {
    
    [gamearea addSubview:view];
}

- (void)addSubViewToMainView:(UIView *)view {
    
    [mainView addSubview:view];
}

- (void)addSubViewToGameArea:(UIImageView *)view belowSubview:(UIImageView *)belowView {
    [gamearea insertSubview:view belowSubview:belowView];
}

- (void)addObjectToSpace:(id)obj {
    [space add:obj];
}

- (void)removeObjectFromSpace:(id)obj {
    [space addPostStepRemoval:obj];
    //[space remove:obj];
}


- (id)getObjectFromBody:(ChipmunkBody *)body {
    // REQUIRES: shape is a shape of GameObject and in the space.
    // EFFECTS: return a GameObject which the shape belongs to.
    
    for (int i = 0; i < objects.count; i++) {
        GameObject *obj = [objects objectAtIndex:i];
        if ([[obj body] isEqual:body]) {
            return obj;
        }
    }
    return nil;
}

- (void)update {
    // EFFECTS: a game loop, update the position of objects in space based on the time since the last update.
    
    if (!space) {
        return;
    }
    
    cpFloat dt = displayLink.duration * displayLink.frameInterval;
    [space step:dt];
    for (int i = 0; i < objects.count; i++) {
        [[objects objectAtIndex:i] updatePosition];
    }
}


- (void)separateCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
}

- (bool)beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
    return TRUE;
}

- (void)windCollidesBlock:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
    // Collision handler for wind and block.
    
    // check if it's the first frame two objects have hit each other
    if(!cpArbiterIsFirstContact(arbiter)) 
        return;
     
    cpBody *windBody, *blockBody;
    cpArbiterGetBodies(arbiter, &windBody, &blockBody);
    
    if (!windBody ||!blockBody || !gameWolf.wind) {
        return;
    }
    cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
    GameBlock *block = [self getObjectFromBody:blockBody->data];
    if (gameWolf.wind.type >= block.model.subType) {
        // destroy block and the velocity of the wind is halved
        [block destroy];
        [windBody->data setVel:cpvmult([windBody->data vel], 0.5)];
    } else {
        // when the wind slightly touches the block, it shouldn't disappear.
        if (impulse > 150.0) {
            [gameWolf stopBreath];
        }
        // apply an impulse on the block
        [blockBody->data applyImpulse:cpArbiterTotalImpulse(arbiter) offset:cpv(0,0)];
    }
}

- (void)windCollidesBorder:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
    // Collision handler for wind and block.
    
    if(!cpArbiterIsFirstContact(arbiter)) 
        return;
    cpBody *windBody, *borderBody;
    cpArbiterGetBodies(arbiter, &windBody, &borderBody);
    
    if (!windBody || !borderBody || !gameWolf.wind) {
        return;
    }
    
    // the border is not the bottom one (ground)
    if (windBody->p.y < IPAD_LANDSCAPE_MAX_HEIGHT - GROUND_HEIGHT - WIND_RADIUS) {
        // the wind disappears
        [gameWolf stopBreath];
    }
}

- (void)windCollidesPig:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
    // Collision handler for wind and pig
    
    if(!cpArbiterIsFirstContact(arbiter)) 
        return;
    
    cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
    cpBody *windBody, *pigBody;
    cpArbiterGetBodies(arbiter, &windBody, &pigBody);
    
    if (!windBody || !pigBody || !gameWolf.wind) {
        return;
    }
    
    GamePig *pig = [self getObjectFromBody:pigBody->data];
    // reduce the heath of pig
    [pig reduceHeath:(impulse + gameWolf.wind.type * WIND_TYPE_TO_PIG_HEATH)];
    
    // when the wind slightly touches the pig, it shouldn't disappear
    if (impulse > 150.0) {
        [gameWolf stopBreath];
    }
    
}

- (void)blockCollidesPig:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
    // Collision handler for block and pig
    
    if(!cpArbiterIsFirstContact(arbiter)) 
        return;
    
    cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
    cpBody *blockBody, *pigBody;
    cpArbiterGetBodies(arbiter, &blockBody, &pigBody);
    
    if (!blockBody || !pigBody) {
        return;
    }
    
    GameBlock *block = [self getObjectFromBody:blockBody->data];
    GamePig *pig = [self getObjectFromBody:pigBody->data];
    if (pig && block) {
        // reduce the heath of the pig
       // [pig reduceHeath:(impulse + block.model.subType * BLOCK_TYPE_TO_PIG_HEATH)];
        [pig reduceHeath:impulse];
    }
}

- (void)blockCollidesWolf:(cpArbiter *)arbiter space:(ChipmunkSpace *)space { 
    // Collision handler for block and wolf
    
    if(!cpArbiterIsFirstContact(arbiter)) 
        return;
    
    cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
    cpBody *blockBody, *wolfBody;
    cpArbiterGetBodies(arbiter, &blockBody, &wolfBody);
    
    if (!blockBody || !wolfBody || impulse < 200) {
        return;
    }
    
    // the skill of wolf is reduced and remove the block from game (if the impulse >= 200)
    GameBlock *block = [self getObjectFromBody:blockBody->data];
    gameWolf.skill = gameWolf.skill - block.model.subType - 1;
    if (gameWolf.skill < 0) {
        gameWolf.skill = 0;
    }
    [block destroy];
    [self updateWolfSKill];
}

@end
