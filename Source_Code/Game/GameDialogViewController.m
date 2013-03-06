//
//  GameDialogViewController.m
//  Game
//
//  Created by DINH TUAN NHU on 24/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameDialogViewController.h"

@implementation GameDialogViewController
@synthesize text;
@synthesize view;
@synthesize dialogMessage;
@synthesize cancelButton;
@synthesize okButton;
@synthesize refreshButton;
@synthesize textField;
@synthesize wolfSkill;
@synthesize transparentLayer;
@synthesize intVal;
@synthesize levelListButton;
@synthesize label1;
@synthesize label2;

- (id)init{
    self = [super init];
    
    // cancel button
    UIImage *img = [UIImage imageNamed:CANCEL_BUTTON_IMG];
    cancelButton = [[UIImageView alloc] initWithImage:img];
    cancelButton.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    cancelButton.userInteractionEnabled = YES;
    [cancelButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel:)]];

    
    // ok button
    img = [UIImage imageNamed:OK_BUTTON_IMG];
    okButton = [[UIImageView alloc] initWithImage:img];
    okButton.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    okButton.userInteractionEnabled = YES;
    
    
    // refresh button
    img  = [UIImage imageNamed:REFRESH_BUTTON];
    refreshButton = [[UIImageView alloc] initWithImage:img];
    refreshButton.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    refreshButton.userInteractionEnabled = YES;

    // list level button
    img  = [UIImage imageNamed:BACK_LEVEL_LIST_BUTTON];
    levelListButton = [[UIImageView alloc] initWithImage:img];
    levelListButton.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    levelListButton.userInteractionEnabled = YES;
    
    
    return self;
}

- (void)freezeScreen:(UIView *)superView {
    
    if (view) {
        [view removeFromSuperview];
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPAD_LANDSCAPE_MAX_WIDTH, IPAD_LANDSCAPE_MAX_HEIGHT)];
    transparentLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPAD_LANDSCAPE_MAX_WIDTH, IPAD_LANDSCAPE_MAX_HEIGHT)];
    transparentLayer.backgroundColor = [UIColor blackColor];
    transparentLayer.alpha = 0.4;
    [view addSubview:transparentLayer];
    [superView addSubview:view];
}


- (void)displayDialogMessageImg:(NSString *)fileName{
    UIImage *img = [UIImage imageNamed:fileName];
    dialogMessage = [[UIImageView alloc] initWithImage:img];
    dialogMessage.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    dialogMessage.center = CGPointMake(IPAD_LANDSCAPE_MAX_WIDTH / 2, IPAD_LANDSCAPE_MAX_HEIGHT / 2);
    [view addSubview:dialogMessage];
}


- (void)showMessageDiaglogWithImg:(NSString *)fileName superView:(UIView *)superView {
    
    [self freezeScreen:superView];
    [self displayDialogMessageImg:fileName];
    
    // add tap gesture recognizer to ok button view
    okButton.center = CGPointMake(dialogMessage.center.x + dialogMessage.frame.size.width / 4, dialogMessage.center.y + dialogMessage.frame.size.height / 2);
    [okButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel:)]];
    [view addSubview:okButton];
}

- (void)showConfirmDeleteLevel:(UIView *)superView {
    
    [self freezeScreen:superView];
    [self displayDialogMessageImg:CONFIRM_DELETE_DIALOG_IMG];
    
    // change okButton position and add tap gesture recognizer to ok button view
    okButton.center = CGPointMake(dialogMessage.center.x + dialogMessage.frame.size.width / 4, dialogMessage.center.y + dialogMessage.frame.size.height / 2);
    [okButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOkButtonOnDeleteConfirm:)]];
    [view addSubview:okButton];
    
    // change cancelButton position
    cancelButton.center = CGPointMake(dialogMessage.center.x - dialogMessage.frame.size.width / 4, dialogMessage.center.y + dialogMessage.frame.size.height / 2);
    [view addSubview:cancelButton];
}

- (void)showEndGameDialog:(UIView *)superView isWin:(BOOL)isWin score:(int)score highScore:(int)highScore {
    
    NSString *messageImg;
    if (isWin) {
        if (score <= highScore) {
            messageImg = LEVEL_CLEARED_IMG;
        } else {
            messageImg = LEVEL_NEW_HIGH_SCORE_IMG;
            highScore = score;
        }
    } else {
       messageImg = LEVEL_FAILED_IMG;
    }
    
    [self showMessageDiaglogWithImg:messageImg superView:superView];
    [okButton removeFromSuperview];
    
    // change refreshButton position, add tap gesture recognizer to refreshButton button view
    refreshButton.center = CGPointMake(dialogMessage.center.x, dialogMessage.center.y + dialogMessage.frame.size.height / 2);
    [refreshButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRefreshButtonOnLevelFailDialog:)]];
    [view addSubview:refreshButton];

    // change levelListButton position, add tap gesture recognizer to levelListButton button view
    levelListButton.center = CGPointMake(dialogMessage.center.x - dialogMessage.frame.size.width / 3, dialogMessage.center.y + dialogMessage.frame.size.height / 2);
    [levelListButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLevelListButtonOnLevelFailDialog:)]];
    [view addSubview:levelListButton];
    
    
    // high score
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(dialogMessage.center.x + dialogMessage.frame.size.width / 5.5, dialogMessage.center.y - dialogMessage.frame.size.height / 3.5, 92, 21)];
    label1.text = [NSString stringWithFormat:@"%d", highScore];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont boldSystemFontOfSize:30];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = UITextAlignmentCenter;
    [view addSubview:label1];
    
    // if win, show score
    if (isWin) {
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(dialogMessage.center.x - dialogMessage.frame.size.width / 4.3, dialogMessage.center.y + dialogMessage.frame.size.height / 4.3, 92, 21)];
        
        label2.text = [NSString stringWithFormat:@"%d", score];
        label2.backgroundColor = [UIColor clearColor];
        label2.font = [UIFont boldSystemFontOfSize:30];
        label2.textColor = [UIColor whiteColor];
        label2.textAlignment = UITextAlignmentCenter;
        [view addSubview:label2];
    }
}



- (void)tapRefreshButtonOnLevelFailDialog:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetGame" object:self];
    }
}

- (void)tapLevelListButtonOnLevelFailDialog:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backToLevelListFromPlayingGame" object:self];
    }
}

- (void)showSavePromptDialog:(UIView *)superView {
    
    [self freezeScreen:superView];
    [self displayDialogMessageImg:SAVE_PROMPT_DIALOG_IMG];
    
    // change oktButton position, add tap gesture recognizer to okButton button view
    okButton.center = CGPointMake(dialogMessage.center.x + dialogMessage.frame.size.width / 4, dialogMessage.center.y + dialogMessage.frame.size.height / 2);
    [okButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOkButtonOnSavePrompt:)]];
    [view addSubview:okButton];
    
    // change cancelButton position
     cancelButton.center = CGPointMake(dialogMessage.center.x - dialogMessage.frame.size.width / 4, dialogMessage.center.y + dialogMessage.frame.size.height / 2);
    [view addSubview:cancelButton];
    
    // add text field for users to input level name
    textField = [[UITextField alloc] initWithFrame:CGRectMake(410, 325, 360, 32)];
    textField.text = text;
    textField.adjustsFontSizeToFitWidth = TRUE;
    [view addSubview:textField];
    
    // add slider for users to input the skill of wolf
    wolfSkill = [[UISlider alloc] initWithFrame:CGRectMake(405, 380, 360, 32)];
    wolfSkill.continuous = NO;
    wolfSkill.minimumValue = 5;
    wolfSkill.maximumValue = 100;
    wolfSkill.value = intVal;
    [view addSubview:wolfSkill];

}

- (void)cancel:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [view removeFromSuperview];
    }
}

- (void)tapOkButtonOnSavePrompt:(UITapGestureRecognizer *)gesture {

    if (gesture.state == UIGestureRecognizerStateEnded) {
        text = textField.text;
        intVal = (int)wolfSkill.value;
        if (text.length == 0) {
            dialogMessage.image = [UIImage imageNamed:SAVE_PROMPT_ERROR_DIALOG_IMG];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"saveNewGameLevelDesign" object:nil];
            [view removeFromSuperview];
            
        }
    }
}

- (void)tapOkButtonOnDeleteConfirm:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteLevel" object:nil];
    }
}

- (void)viewDidUnload {
    [self setDialogMessage:nil];
    [self setOkButton:nil];
    [self setView:nil];
    [self setTextField:nil];
    [self setWolfSkill:nil];
    [super viewDidUnload];
}
@end
