//
//  ViewController.m
//  Game_Checkers
//
//  Created by Виктор on 15.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "ViewController.h"
#import "FieldView.h"
#import "Players.h"
#import "Checkers.h"
#import "Engine.h"
#import "Server.h"

typedef enum {
    moveIsWhite,
    moveIsBlack
} Move;

@interface ViewController () {
    BOOL firstTouch;
    BOOL secondTouch;
    NSPoint oldPosition;
    Engine *myEngine;
    Players *myPlayer;
    Players *opponentPlayer;
    Move whichMove;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.field.pointerPosition = NSMakePoint(0, 0);
    self.field.dictionaryOfAllField = [NSMutableDictionary dictionaryWithCapacity:32];
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if ((i + j) % 2 == 0) {
                [self.field.dictionaryOfAllField setObject:@"nil" forKey:NSStringFromPoint(NSMakePoint(i, j))];
            }
        }
    }
    firstTouch = NO;
    secondTouch = NO;
    whichMove = moveIsWhite;
    self.messageField.stringValue = @"Welcome To Checkers!";
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
}

- (IBAction)startButton:(id)sender {
    if (!_sideControl.selectedSegment) {
        myEngine = [[Engine alloc] initWithSide:@"W"];
        self.messageField.stringValue = @"you choose white";
        if (_playControl.selectedSegment) {
            myEngine.server = [[Server alloc] initClient];
            myEngine.isMultiPleer = YES;
        }
    } else {
        myEngine = [[Engine alloc] initWithSide:@"B"];
        self.messageField.stringValue = @"you choose black";
        if (_playControl.selectedSegment) {
            myEngine.server = [[Server alloc] initServer];
            myEngine.isMultiPleer = YES;
            myEngine.wait = YES;
        }
    }
    self.field.dictionaryOfAllField = [myEngine returnFirstLaunchFieldDictionary];
    self.field.isStartGame = YES;
    
    [self.field setNeedsDisplay:YES];
}

- (IBAction)controlButton:(id)sender {
    switch ([sender tag]) {
        case 0:
            if (self.field.pointerPosition.y < 350) {
                self.field.pointerPosition = NSMakePoint(self.field.pointerPosition.x, self.field.pointerPosition.y + 1);
            }
            break;
        case 1:
            if (self.field.pointerPosition.x < 350) {
                self.field.pointerPosition = NSMakePoint(self.field.pointerPosition.x + 1, self.field.pointerPosition.y);
            }
            
            break;
        case 2:
            if (self.field.pointerPosition.y > 0) {
                self.field.pointerPosition = NSMakePoint(self.field.pointerPosition.x, self.field.pointerPosition.y - 1);
            }
            break;
        case 3:
            if (self.field.pointerPosition.x > 0) {
                self.field.pointerPosition = NSMakePoint(self.field.pointerPosition.x - 1, self.field.pointerPosition.y);
            }
            break;
        default:
            break;
    }
    [self.field setNeedsDisplay:YES];
}

- (IBAction)chooseButton:(id)sender {
    if (myEngine.wait) {
        
    }
    [myEngine makeTransformationWithPoint:self.field.pointerPosition];
    self.field.isChose = myEngine.needRedIndicator;
    
    if ([myEngine.whichMove isEqualToString:@"W"]) {
        self.messageField.stringValue = @"White, attack!";
    } else {
        self.messageField.stringValue = @"Black, attack!";
    }
    [self.field setNeedsDisplay:YES];
}

@end
