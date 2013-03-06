//
//  GameAddLevelViewController.m
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameAddLevelViewController.h"

@implementation GameAddLevelViewController
@synthesize model;
@synthesize dialog;
@synthesize gamearea;
@synthesize background;
@synthesize backButton;
@synthesize palette;
@synthesize resetButton;
@synthesize saveButton;
@synthesize deleteButton;
@synthesize BG1_button;
@synthesize BG2_button;
@synthesize BG3_button;
@synthesize BG4_button;
@synthesize objects;
@synthesize gameWolf;


- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (!model) {
        model = [[GameLevelModel alloc] initWithKey:0 name:@"" highScore:0 wolfSkill:0 background:DEFAULT_BACKGROUND];
    }
    
    
    //load the images into UIImage objects
    UIImage *bgImage = [UIImage imageNamed:model.background];
    
    // Get the width and height of the two images
    CGFloat backgroundWidth = bgImage.size.width;
    CGFloat backgroundHeight = bgImage.size.height;
    
    //place each of them in an UIImageView
    background = [[UIImageView alloc] initWithImage:bgImage];
    
    
    //the frame property holds the position and size of the views
    //the CGRectMake methods arguments are : x position, y position, width,
    //height
    background.frame = CGRectMake(0, 0, backgroundWidth, backgroundHeight);
    
    //add these views as subviews of the gamearea.
    [gamearea addSubview:background];
    
    //set the content size so that gamearea is scrollable
    //otherwise it defaults to the current window size
    [gamearea setContentSize:CGSizeMake(backgroundWidth, backgroundHeight)];
    gamearea.canCancelContentTouches = NO;
    
    //init dialog
    dialog = [[GameDialogViewController alloc] init];
    dialog.intVal = model.wolfSKill;
    dialog.text = model.name;
    
    //------Game Objects initialization------//
    objects = [[NSMutableArray alloc] init];
    
    // add tap gesture recognizer to backButton view
    backButton.userInteractionEnabled = YES;
    [backButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    // add tap gesture recognizer to resetButton view
    resetButton.userInteractionEnabled = YES;
    [resetButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetRecoginer:)]];
    
    // add tap gesture recognizer to saveButton view
    saveButton.userInteractionEnabled = YES;
    [saveButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSaveButton:)]];
    
    // add tap gesture recognizer to background button
    [BG1_button addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundTypeButton:)]];
    [BG2_button addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundTypeButton:)]];
    [BG3_button addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundTypeButton:)]];
    [BG4_button addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundTypeButton:)]];
    
    
    if (model.levelId) {
        // add tap gesture recognizer to saveButton view
        deleteButton.userInteractionEnabled = YES;
        [deleteButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDeleteButton:)]];
    } else {
        [deleteButton removeFromSuperview];
        deleteButton = nil;
    }
    
     
    [self reset];
}


- (void)viewWillAppear:(BOOL)animated {
    
    // add notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(save) 
                                                 name:@"saveNewGameLevelDesign"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteLevel) 
                                                 name:@"deleteLevel"
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"saveNewGameLevelDesign" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"deleteLevel" object:nil];
}

- (void)viewDidUnload {
    
    [self setBackButton:nil];
    [self setPalette:nil];
    [self setResetButton:nil];
    [self setSaveButton:nil];
    [self setDeleteButton:nil];
    [self setBG1_button:nil];
    [self setBG2_button:nil];
    [self setBG3_button:nil];
    [self setBG4_button:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // only support Landscape
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)back:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)resetRecoginer:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self reset];
    }
}

- (void)tapSaveButton:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        BOOL hasPigInGameArea = NO;
        BOOL hasWolfInGameArea = NO;
        for (int i = 0; i < objects.count; i++) {
            GameObject *object = [objects objectAtIndex:i];
            if ([object isKindOfClass:[GameWolf class]] && object.isInGame) {
                hasWolfInGameArea = YES;
            } else if ([object isKindOfClass:[GamePig class]] && object.isInGame) {
                hasPigInGameArea = YES;
            }
        }
        if (hasPigInGameArea && hasWolfInGameArea) {
            [dialog showSavePromptDialog:self.view];
        } else {
            [dialog showMessageDiaglogWithImg:SAVE_ERROR_IMG superView:self.view];
        }
    }
}

- (void)tapDeleteButton:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded && model.levelId) {
        [dialog showConfirmDeleteLevel:self.view];
    }
}

- (void)tapBackgroundTypeButton:(UITapGestureRecognizer *)gesture {
    BG1_button.alpha = 0.4;
    BG2_button.alpha = 0.4;
    BG3_button.alpha = 0.4;
    BG4_button.alpha = 0.4;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.view == BG1_button) {
            model.background = [BACKGROUND_IMGS objectAtIndex:0];
            BG1_button.alpha = 1;
        } else if (gesture.view == BG2_button) {
            model.background = [BACKGROUND_IMGS objectAtIndex:1];
            BG2_button.alpha = 1;
        } else if (gesture.view == BG3_button) {
            model.background = [BACKGROUND_IMGS objectAtIndex:2];
            BG3_button.alpha = 1;
        } else {
            model.background = [BACKGROUND_IMGS objectAtIndex:3];
            BG4_button.alpha = 1;
        }
        background.image = [UIImage imageNamed:model.background];
    }
}


- (void)save {
    
    NSMutableArray *gameModels = [[NSMutableArray alloc] init];
    for (int i = 0; i < objects.count; i++) {
        GameObject *obj = [objects objectAtIndex:i];
        if (obj.isInGame) {
            [gameModels addObject:[obj model]];
        }
    }
    
    model.name = dialog.text ;
    model.wolfSKill = dialog.intVal;
    [[[GameDatabaseAccess alloc] init] updateLevelWithLevelModel:model gameModels:gameModels];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)deleteLevel {
    
     [[[GameDatabaseAccess alloc] init] deleteLevel:model.levelId];
     [[self navigationController] popViewControllerAnimated:YES];
}

- (void)reset {
    
    for (int i = [[palette subviews] count] - 1; i >= 0; i-- ) {
        [[[palette subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    for (int i = [[gamearea subviews] count] - 1; i > 0; i-- ) {
        [[[gamearea subviews] objectAtIndex:i] removeFromSuperview];
    }
    [objects removeAllObjects];
    if (model.levelId) {
        // load game level details from database and add objects to view, space.
        NSArray *gameModels = [[[GameDatabaseAccess alloc] init] getLevelDetails:model.levelId];
        for (int i = 0; i < gameModels.count; i++) {
            GameModel *gameModel = [gameModels objectAtIndex:i];
            if (gameModel.type == kGameObjectWolf) {
                [self addObject:[[GameWolf alloc] initWithModel:gameModel isInGameArea:YES delegate:self]];
            } else if (gameModel.type == kGameObjectPig) {
                [self addObject:[[GamePig alloc] initWithModel:gameModel isInGameArea:YES delegate:self]];    
            } else {
                [self addObject:[[GameBlock alloc] initWithModel:gameModel isInGameArea:YES delegate:self]];
            }
        }
    } else {
        // add the pig on palette
        GameWolf *wolf = [[GameWolf alloc] initWithIsInGameArea:NO subType:0 delegate:self];
        [self addObject:wolf];
    }
    GamePig *pig = [[GamePig alloc] initWithIsInGameArea:NO subType:0 delegate:self];
    [self addObject:pig];
    GameBlock *block = [[GameBlock alloc] initWithIsInGameArea:NO subType:0 delegate:self];
    [self addObject:block];
}

- (void)addObject:(GameObject *)object {
    // REQUIRES: Object is a subclass of GameObject
    // EFFECTS: add the object to static multable array objects
    
    [objects addObject:object];
}


- (void)removeObject:(GameObject *)object {
    // REQUIRES: Object is a subclass of GameObject
    // EFFECTS: remove the object from static multable array objects
    
    [objects removeObject:object];
}

- (void)addSubViewToGameArea:(UIImageView *)view {
    
    [gamearea addSubview:view];
}

- (void)addSubViewToGameArea:(UIImageView *)view belowSubview:(UIImageView *)belowView {
    
    [gamearea insertSubview:view belowSubview:belowView];
}

- (void)addSubViewToPalette:(UIImageView *)view {
    
    [palette addSubview:view];
}

- (CGPoint)converPointFromPaletteToGameArea:(CGPoint)point {
    return [palette convertPoint:point toView:gamearea];
}

@end
