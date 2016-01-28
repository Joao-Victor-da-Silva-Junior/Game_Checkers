//
//  ViewController.h
//  Game_Checkers
//
//  Created by Виктор on 15.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FieldView;
@interface ViewController : NSViewController

@property (weak, nonatomic) IBOutlet FieldView *field;
@property (weak, nonatomic) IBOutlet NSTextField *messageField;
@property (weak, nonatomic) IBOutlet NSSegmentedControl *sideControl;
@property (weak, nonatomic) IBOutlet NSSegmentedControl *connectionControl;
@property (weak, nonatomic) IBOutlet NSSegmentedControl *playControl;

- (IBAction)startButton:(id)sender;
- (IBAction)controlButton:(id)sender;
- (IBAction)chooseButton:(id)sender;

@end

