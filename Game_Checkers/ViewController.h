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

- (IBAction)startButton:(id)sender;
- (IBAction)controlButton:(id)sender;
- (IBAction)chooseButton:(id)sender;

@end

