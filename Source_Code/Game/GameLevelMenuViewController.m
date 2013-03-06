//
//  GameLevelMenuViewController.m
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameLevelMenuViewController.h"

@implementation GameLevelMenuViewController
@synthesize background;
@synthesize levelFrameView;
@synthesize backButton;
@synthesize addLevelButton;
@synthesize levelArea;
@synthesize listOfLevels;

- (void)viewDidLoad {
    
    selectedLevel = 0;
    listOfLevels = [[NSMutableArray alloc] init];
    levelFrameView.layer.cornerRadius = 30.0; 
    
    // add swipe gesture recognizer (2 fingures - right direction) to background 
    background.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    swipe.numberOfTouchesRequired = 2;
    [background addGestureRecognizer:swipe];
    
    // add tap gesture recognizer to backButton view
    backButton.userInteractionEnabled = YES;
    [backButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    // add tap gesture recognizer to addLevelButton view
    addLevelButton.userInteractionEnabled = YES;
    [addLevelButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addLevel:)]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // add notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playGame:) 
                                                 name:@"playGame"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editGame:) 
                                                 name:@"editGame"
                                               object:nil];
    
    // reload the game levels when the view appears
    [listOfLevels removeAllObjects];
    NSArray *levelModels = [[[GameDatabaseAccess alloc] init] getListOfLevels];
    for (int i = 0; i < levelModels.count; i++) {
        GameLevel *level = [[GameLevel alloc] initWithModel:[levelModels objectAtIndex:i] position:i];
        [levelArea addSubview:level.view];
        [listOfLevels addObject:level];
    }
    [levelArea setContentSize:CGSizeMake(800, (listOfLevels.count / NUMBER_LEVEL_VIEW_PER_ROW + 1) * (LEVEL_VIEW_HEIGHT + LEVEL_GAP_Y))];
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    // remove all subviews of levelArea
    for (int i = [[levelArea subviews] count] - 1; i >= 0; i-- ) {
        [[[levelArea subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    // remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"playGame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"editGame" object:nil];
}

- (void)viewDidUnload {
    
    [self setBackground:nil];
    [self setLevelFrameView:nil];
    [self setBackButton:nil];
    [self setAddLevelButton:nil];
    [self setLevelArea:nil];
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

- (void)addLevel:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
       [self performSegueWithIdentifier:@"NewGameLevel" sender:self];
    }
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight){
       [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)playGame:(NSNotification *) notification {
    selectedLevel = [notification object];
    [self performSegueWithIdentifier:@"PlayGameSegue" sender:self];
}

- (void)editGame:(NSNotification *) notification {
    selectedLevel = [notification object];
    [self performSegueWithIdentifier:@"EditGameLevel" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // add the information for the GamePlayViewController before transition
    if([segue.identifier isEqualToString:@"PlayGameSegue"] || [segue.identifier isEqualToString:@"EditGameLevel"]) {
        [segue.destinationViewController setModel:selectedLevel];
    }
}

@end
