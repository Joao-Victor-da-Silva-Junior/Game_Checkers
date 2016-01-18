//
//  Engine.m
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "Engine.h"
#import "FieldView.h"
#import "Checkers.h"
#import "Players.h"

@interface Engine () {
    BOOL youHaveTwoPoints;
    NSPoint firstTouchPosition;
    NSPoint secondTouchPosition;
    NSMutableDictionary *fieldDictionary;
    NSMutableArray *arrayOfDiagonals;
    Players *myPlayer;
    Players *opponentPlayer;
}

@end

@implementation Engine

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _whichMove = @"White";
        firstTouchPosition = secondTouchPosition = NSMakePoint(100, 100);
    }
    return self;
}

#pragma mark - Class Methods

+ (BOOL) indicatorSetterOnCoordinate:(NSPoint) point
                 withFieldDictionary:(NSMutableDictionary *) dictionary
                       andPlayerMove:(NSString *) move {
    if ([[dictionary objectForKey:NSStringFromPoint(point)] isEqualToString:move]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSMutableDictionary *) makeMoveWithFirstTouch:(NSPoint) firstPoint
                                     SecondTouch:(NSPoint) secondPoint
                                      playerMove:(NSString *) move
                              andFieldDictionary:(NSMutableDictionary *) fieldDictionary {
    
    CGFloat difference = fabs(firstPoint.y - secondPoint.y);
    NSUInteger direction;
    if ([move isEqualToString:@"White"]) {
        difference = secondPoint.y - firstPoint.y;
        direction = 1;
    } else {
        difference = firstPoint.y - secondPoint.y;
        direction = -1;
    }
    
    if ([[fieldDictionary objectForKey:NSStringFromPoint(firstPoint)] isEqualToString:move]) {
        NSLog(@"correct choose");
        if ((firstPoint.x == secondPoint.x + 1 || firstPoint.x == secondPoint.x - 1) && difference == 1) {
            NSLog(@"possible move");
            if (![[fieldDictionary objectForKey:NSStringFromPoint(secondPoint)] isEqualToString:move]) {
                NSLog(@"nil or enemy check");
                if (fieldDictionary [NSStringFromPoint(secondPoint)] != nil) {
                    NSLog(@"ENEMY!!");
                    if (secondPoint.x < 7 && secondPoint.x > 0 && secondPoint.y > 0 && secondPoint.y < 7) {
                        NSLog(@"can eat");
                        NSPoint newPoint;
                        if (firstPoint.x > secondPoint.x) {
                            newPoint.x = secondPoint.x - 1;
                        } else {
                            newPoint.x = secondPoint.x + 1;
                        }
                        if (firstPoint.y > secondPoint.y) {
                            newPoint.y = secondPoint.y - 1;
                            NSLog(@"Black eat white");
                            [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(firstPoint)];
                            [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(secondPoint)];
                            [fieldDictionary setObject:@"Black" forKey:NSStringFromPoint(newPoint)];
                        } else {
                            NSLog(@"white eat black");
                            newPoint.y = secondPoint.y + 1;
                            [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(firstPoint)];
                            [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(secondPoint)];
                            [fieldDictionary setObject:@"White" forKey:NSStringFromPoint(newPoint)];
                        }
                    } else {
                        NSLog(@"cannot eat");
                        return nil;
                    }
                } else {
                    NSLog(@"nothing, make move");
                    if ([move isEqualToString:@"White"]) {
                        NSLog(@"change White");
                        [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(firstPoint)];
                        [fieldDictionary setObject:@"White" forKey:NSStringFromPoint(secondPoint)];
                    } else {
                        NSLog(@"change Black");
                        [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(firstPoint)];
                        [fieldDictionary setObject:@"Black" forKey:NSStringFromPoint(secondPoint)];
                    }
                }
            } else {
                NSLog(@"your check");
                return nil;
            }
        } else {
            NSLog(@"unpossible move");
            return nil;
        }
    } else {
        NSLog(@"uncorrect choose");
        return nil;
    }
    
    return fieldDictionary;
}

#pragma mark - Object Methods

- (NSMutableDictionary *) returnFirstLaunchFieldDictionary {
    
    fieldDictionary = [NSMutableDictionary dictionary];
    myPlayer = [[Players alloc] initWhite:YES];
    opponentPlayer = [[Players alloc] initWhite:NO];
    [fieldDictionary addEntriesFromDictionary:[myPlayer returnDictionaryOfColors]];
    [fieldDictionary addEntriesFromDictionary:[opponentPlayer returnDictionaryOfColors]];
    [self createArrayOfDiagonals];
    
    return fieldDictionary;
}

- (NSMutableDictionary *) makeTransformationWithPoint:(NSPoint) point {
    [self setPoints:point];
    if (youHaveTwoPoints) {
        NSLog(@"TWO POINTS");
        [self clearPoints];
    }
    
    
    return fieldDictionary;
}

- (void) setPoints:(NSPoint) p {
    if (firstTouchPosition.x == 100) {
        firstTouchPosition = p;
        youHaveTwoPoints = NO;
    } else
    if (secondTouchPosition.x == 100) {
        secondTouchPosition = p;
        youHaveTwoPoints = YES;
    }
}

- (void) clearPoints {
    firstTouchPosition = secondTouchPosition = NSMakePoint(100, 100);
}


- (void) createArrayOfDiagonals {
    arrayOfDiagonals = [NSMutableArray arrayWithCapacity:11];
    
    __block NSInteger step = 1;
    NSInteger valueX = 0;
    NSInteger valueY = 4;
    void (^creator)(NSInteger, NSInteger, int) = ^(NSInteger stepForX, NSInteger stepForY, int i) {
        while (stepForX < 8 && stepForY < 8 && stepForX >= 0 && stepForY >= 0) {
            if ([arrayOfDiagonals count] == i) {
                [arrayOfDiagonals addObject:[NSMutableArray array]];
            }
            [[arrayOfDiagonals objectAtIndex:i] addObject:[NSValue valueWithPoint:NSMakePoint(stepForX, stepForY)]];
            NSLog(@"%@",NSStringFromPoint(NSMakePoint(stepForX, stepForY)));
            stepForX += step;
            stepForY++;
            i++;
        }
    };

    for (int i = 0; i < 11; i++) {
        NSLog(@"next");
        if (i < 3) {
            valueX = 0;
            valueY = 4;
            creator(valueX, valueY - (2 * i), i);
        } else if (i < 5) {
            valueX = 2;
            valueY = 0;
            creator(valueX + (2 * (i - 3)), valueY, i);
        } else if (i < 8) {
            step = -1;
            valueX = 2;
            valueY = 0;
            creator(valueX + (2 * (i - 5)), valueY, i);
        } else {
            valueX = 7;
            valueY = 1;
            creator(valueX, valueY + 2 * (i - 8), i);
        }
    }
}








@end