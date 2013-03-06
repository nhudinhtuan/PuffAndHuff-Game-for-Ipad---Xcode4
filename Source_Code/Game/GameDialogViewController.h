//
//  GameDialogViewController.h
//  Game
//
//  Created by DINH TUAN NHU on 24/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constant.h"

@interface GameDialogViewController : UIViewController {
    NSString *text;
    int intVal;
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *transparentLayer;
@property (strong, nonatomic) IBOutlet UIImageView *dialogMessage;
@property (strong, nonatomic) IBOutlet UIImageView *cancelButton;
@property (strong, nonatomic) IBOutlet UIImageView *okButton;
@property (strong, nonatomic) IBOutlet UIImageView *refreshButton;
@property (strong, nonatomic) IBOutlet UIImageView *levelListButton;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UISlider *wolfSkill;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;

@property (readwrite, nonatomic) int intVal;
@property (strong, nonatomic) NSString *text;

- (void)showMessageDiaglogWithImg:(NSString *)fileName superView:(UIView *)superView;
- (void)showConfirmDeleteLevel:(UIView *)superView;
- (void)showSavePromptDialog:(UIView *)superView;
- (void)showEndGameDialog:(UIView *)superView isWin:(BOOL)isWin score:(int)score highScore:(int)highScore;
- (void)freezeScreen:(UIView *)superView;
@end
