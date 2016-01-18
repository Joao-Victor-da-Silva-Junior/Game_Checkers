//
//  Engine.h
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Engine : NSObject

@property (assign, nonatomic) NSString *whichMove;

#pragma mark - Class Methods

+ (BOOL) indicatorSetterOnCoordinate:(NSPoint) point
                 withFieldDictionary:(NSMutableDictionary *) dictionary
                       andPlayerMove:(NSString *) move;

+ (NSMutableDictionary *) makeMoveWithFirstTouch:(NSPoint) firstPoint
                                     SecondTouch:(NSPoint) secondPoint
                                      playerMove:(NSString *) move
                              andFieldDictionary:(NSMutableDictionary *) fieldDictionary;


#pragma mark - Object Methods

- (NSMutableDictionary *) makeTransformationWithPoint:(NSPoint) point;

- (NSMutableDictionary *) returnFirstLaunchFieldDictionary;

@end
