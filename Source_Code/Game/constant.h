//
//  constant.h
//  Game
//
//  Created by DINH TUAN NHU on 24/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//


/*
 * DATABASE TABLES:
 *  1. GameLevels (INTEGER id, TEXT name, INTEGER high_score, INTEGER wolf_skill, TEXT background)
 *  2. LevelDetails (INTEGER id, INTEGER level_id, INTEGER type, INTEGER sub_type,
 *                   FLOAT center_x, FLOAT center_y, FLOAT rotation, FLOAT scale) 
 */
#define DATABASE_NAME @"HUFF_PUFF.sqlite"

#define DEFAULT_BACKGROUND @"background.jpg"
#define BACKGROUND_IMGS [NSArray arrayWithObjects:@"background.jpg", @"background2.jpg", @"background3.jpg", @"background4.jpg", nil]
#define IPAD_LANDSCAPE_MAX_WIDTH 1024.0
#define IPAD_LANDSCAPE_MAX_HEIGHT 748.0
#define ON_SOUND_IMG @"sound_icon.png"
#define OFF_SOUND_IMG @"no_sound_icon.png"
#define MUSIC_INTRO_FILE_NAME @"intro"
#define MUSIC_INTRO_FILE_TYPE @"mp3"

#define GROUND_HEIGHT 120.0
#define CHIPMUNKS_BORDER_TYPE @"borderType"
#define SKILL_TO_SCORE 100
#define WIND_TYPE_TO_PIG_HEATH 10
#define BLOCK_TYPE_TO_PIG_HEATH 10


// Add level
// the gameobjects can not be placed outside the screen or under ground
#define MAX_X_COORDINATE 1602.0  
#define MIN_X_COORDINATE 0.0
#define MAX_Y_COORDINATE 628.0
#define MIN_Y_COORDINATE 0.0


// Dialog images
#define NOT_ENOUGH_SKILL_DIALOG_IMG @"notEnoughSkillError.png"
#define CONFIRM_DELETE_DIALOG_IMG @"confirmDelete.png"
#define SAVE_ERROR_IMG @"save_error.png"
#define SAVE_PROMPT_DIALOG_IMG @"save_prompt_dialog.png"
#define SAVE_PROMPT_ERROR_DIALOG_IMG @"save_prompt_dialog_error.png"
#define LEVEL_FAILED_IMG @"levelFail.png"
#define LEVEL_CLEARED_IMG @"levelCleared.png"
#define LEVEL_NEW_HIGH_SCORE_IMG @"newHighScore.png"

// Button
#define OK_BUTTON_IMG @"okButton.png"
#define CANCEL_BUTTON_IMG @"cancel.png"
#define DELETE_BUTTON_IMG @"deleteButton.png"
#define BACK_LEVEL_LIST_BUTTON @"backListLevel.png"
#define REFRESH_BUTTON @"refresh_button.png"


// Game pig
#define PIG_IMG @"pig.png"
#define PIG_CRY_IMG @"pig2.png"
#define PIG_DIE_IMG @"pig-die-smoke.png"
#define PALETTE_PIG_WIDTH 55
#define PALETTE_PIG_HEIGHT 55
#define GAMEAREA_PIG_WIDTH 80
#define GAMEAREA_PIG_HEIGHT 80
#define PIG_MASS 10.0
#define PIG_ELASTICITY 0.3
#define PIG_FRICTION 1.0
#define PIG_HEATH 1000.0


// GameWolf
#define WOLF_SKILL_LABEL_IMG @"wolf_skill.png"
#define WOLF_SKILL_LABEL_DEDUCT_IMG @"wolf_skill_deduct.png"
#define WOLF_BREATHE_ANIMATION_IMG @"wolfBlow.png"
#define WOLF_DIE_ANIMATION_IMG @"wolfdie.png"
#define PALETTE_WOLF_WIDTH 100
#define PALETTE_WOLF_HEIGHT 70
#define GAMEAREA_WOLF_WIDTH 225
#define GAMEAREA_WOLF_HEIGHT 150
#define WOLF_MASS 20.0
#define WOLF_ELASTICITY 0.0
#define WOLF_FRICTION 10.0


// Gameblock
#define images [NSArray arrayWithObjects:@"straw.png", @"wood.png", @"iron.png", @"stone.png", nil]
#define PALETTE_BLOCK_WIDTH 50
#define PALETTE_BLOCK_HEIGHT 50
#define GAMEAREA_BLOCK_WIDTH 30
#define GAMEAREA_BLOCK_HEIGHT 130
#define WIND_MASS 1.0
#define WIND_RADIUS 52
#define WIND_ELASTICITY 0.3
#define WIND_FRICTION 0.3

// GameLevel
#define LEVEL_IMG @"level.png"
#define LEVEL_EDIT_BUTTON @"editDrop.png"
#define LEVEL_VIEW_WIDTH 124.0
#define LEVEL_VIEW_HEIGHT 120.0
#define LEVEL_GAP_X 10.0
#define LEVEL_GAP_Y 10.0
#define NUMBER_LEVEL_VIEW_PER_ROW 6


// Game Arrow
#define ARROW_IMG @"direction-arrow2.png"
#define ARROW_SELECTED_IMG @"direction-arrow-selected2.png"
#define DEGREE_IMG @"direction-degree2.png"
#define MAX_DEGREE 2.06
#define MIN_DEGREE 0.35

// GamePower
#define POWER_HEIGHT 40.0
#define POWER_BAR_POSITION_X 850
#define POWER_BAR_POSITION_Y 670
#define POWER_ANIMATION_POSITION_X 15
#define POWER_ANIMATION_POSITION_Y 8.5
#define BREATHE_BAR_IMG @"powerBar.png"
#define POWER_ANIMATION_IMG @"empty-breath-bar.png"
#define POWER_MIN 10.0
#define POWER_MAX 125.0
#define POWER_CHANGE_STEP 3.0;

// Game Wind
#define WIND_FRAME_SIZE 200.0
#define WIND_IMGS [NSArray arrayWithObjects:@"wind0.png", @"wind1.png", @"wind2.png", @"wind3.png", nil]
#define WIND_LIFE_TIME 4.0
#define POWER_TO_IMPULSE_FORCE 20.0
#define WIND_SUCK_IMG @"windsuck.png"
#define WIND_SUCK_FRAME_WIDTH 150.0
#define WIND_SUCK_FRAME_HEIGHT 144.0


