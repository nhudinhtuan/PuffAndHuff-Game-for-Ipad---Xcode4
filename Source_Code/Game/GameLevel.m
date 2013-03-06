//
//  GameLevel.m
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameLevel.h"

@implementation GameLevel
@synthesize model;
@synthesize view;
@synthesize editButton;


- (id)initWithModel:(GameLevelModel *)levelModel position:(int)position {
    // EFFECTS: Constructs a new GameLevelLevel
    
    self = [super init];
    model = levelModel;
    
    UIImage *img = [UIImage imageNamed:LEVEL_IMG];
    view = [[UIImageView alloc] initWithImage:img];
    view.frame = CGRectMake((LEVEL_VIEW_WIDTH + LEVEL_GAP_X) * (position % NUMBER_LEVEL_VIEW_PER_ROW) + 5, (LEVEL_VIEW_HEIGHT + LEVEL_GAP_Y) * (position / NUMBER_LEVEL_VIEW_PER_ROW), LEVEL_VIEW_WIDTH, LEVEL_VIEW_HEIGHT);
    view.contentMode = UIViewContentModeCenter;
   
    
    // create editButton view and add the tap guesture recognizer
    img = [UIImage imageNamed:LEVEL_EDIT_BUTTON];
    editButton = [[UIImageView alloc] initWithImage:img];
    editButton.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    editButton.userInteractionEnabled = YES;
    [editButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(edit:)]];
    [view addSubview:editButton];
    
    // create a label to show the name of game level
    UILabel *levelLabel  = [[UILabel alloc] initWithFrame:CGRectMake(img.size.width / 2, 8, 81, 81)];
    levelLabel.text = model.name;
    levelLabel.textAlignment =  UITextAlignmentCenter;
    levelLabel.backgroundColor =[UIColor clearColor];
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(30.0)];
    [view addSubview:levelLabel];
    
     // create a label to show the high score of game level
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(img.size.width / 2, 89, 81, 21)];
    pointLabel.text = [NSString stringWithFormat:@"%d", model.highScore];
    pointLabel.textAlignment =  UITextAlignmentCenter;
    pointLabel.backgroundColor =[UIColor clearColor];
    pointLabel.textColor = [UIColor whiteColor];
    pointLabel.font = [UIFont fontWithName:@"Arial" size:(12.0)];
    [view addSubview:pointLabel];
    
     // add tap gesture recognizer to view
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)]];
    
    return self;
}


- (void)play:(UITapGestureRecognizer *)gesture {	
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playGame" object:self.model];
    }
}

- (void)edit:(UITapGestureRecognizer *)gesture {	
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editGame" object:self.model];
    }
}
@end
