//
//  Engine.m
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "Engine.h"

@interface Engine () {
    
    NSPoint firstTouchPosition;
    NSPoint secondTouchPosition;
}

@end

@implementation Engine

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
    
    
   // NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:fieldDictionary];
  //  NSLog(@"First Point: %@", NSStringFromPoint(firstPoint));
  //  NSLog(@"Second Point: %@", NSStringFromPoint(secondPoint));
  //  NSLog(@"Moving is %@", move);
    
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
                if (![[fieldDictionary objectForKey:NSStringFromPoint(secondPoint)] isEqualToString:@"nil"]) {
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
    
    /*if (firstPoint.x == secondPoint.x + 1 || firstPoint.x == secondPoint.x - 1) {
        if (difference == 1) {
            if ([move isEqualToString:@"White"]) {
                NSLog(@"change White");
                [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(firstPoint)];
                [fieldDictionary setObject:@"White" forKey:NSStringFromPoint(secondPoint)];
            } else {
                NSLog(@"change Black");
                [fieldDictionary setObject:@"nil" forKey:NSStringFromPoint(firstPoint)];
                [fieldDictionary setObject:@"Black" forKey:NSStringFromPoint(secondPoint)];
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }*/
    
    return fieldDictionary;
}

@end