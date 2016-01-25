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
    NSPoint firstTouchPos;
    NSPoint secondTouchPos;
    NSMutableDictionary *fieldDictionary;  // {1,1} - White/black (simple representation for field)
    NSMutableArray *arrayOfDiagonals;      // All diagonals of field
    NSInteger walkingDiagonal;
    Players *firstPlayer;
    Players *secondPlayer;
    Players *friendPlayer;
    Players *enemyPlayer;
}

@end

@implementation Engine

#pragma mark - Init Method

- (instancetype)initWithSide:(NSString *)str
{
    self = [super init];
    if (self) {
        _whichMove = str;
        _needRedIndicator = NO;
        firstTouchPos = secondTouchPos = NSMakePoint(100, 100);
    }
    return self;
}

#pragma mark - Class Methods

#pragma mark - Object Methods

- (NSMutableDictionary *) returnFirstLaunchFieldDictionary {
    
    fieldDictionary = [NSMutableDictionary dictionary];
    firstPlayer = [[Players alloc] initWhite:YES];
    secondPlayer = [[Players alloc] initWhite:NO];
    [fieldDictionary addEntriesFromDictionary:[firstPlayer returnDictionaryOfColors]];
    [fieldDictionary addEntriesFromDictionary:[secondPlayer returnDictionaryOfColors]];
    [self createArrayOfDiagonals];
    [self setCheckersToFieldDictionary];
    return fieldDictionary;
}

- (NSMutableDictionary *) makeTransformationWithPoint:(NSPoint) point {
    [self setPoints:point];
    if (youHaveTwoPoints) {
        [self whoIsEnemy];
        if ([self isMovePossible]) {
            if ([self makeMove]) {
                [self becameKing];
                [self changeSide];
            }
        };
        [self clearPoints];
    }
    [fieldDictionary removeAllObjects];
    [fieldDictionary addEntriesFromDictionary:[firstPlayer returnDictionaryOfColors]];
    [fieldDictionary addEntriesFromDictionary:[secondPlayer returnDictionaryOfColors]];
    return fieldDictionary;
}

- (void) setPoints:(NSPoint) p {
    if (firstTouchPos.x == 100) {
        if ([fieldDictionary objectForKey:NSStringFromPoint(p)]) {
            _needRedIndicator = YES;
            firstTouchPos = p;
        }
        youHaveTwoPoints = NO;
    } else
    if (secondTouchPos.x == 100) {
        _needRedIndicator = NO;
        secondTouchPos = p;
        youHaveTwoPoints = YES;
    }
}

- (void) clearPoints {
    firstTouchPos = secondTouchPos = NSMakePoint(100, 100);
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
            stepForX += step;
            stepForY++;
        }
    };

    for (int i = 0; i < 11; i++) {
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

- (void) setCheckersToFieldDictionary {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:firstPlayer.dictionaryOfCheckers, secondPlayer.dictionaryOfCheckers, nil];
    for (int i = 0; i < 2; i++) {
        for (NSString *key in array[i]) {
            Checkers *myCheck = [array[i] objectForKey:key];
            myCheck.diagonalPosition = [self returnNewPointOnDiagonalWithPoint:myCheck.position];
            NSLog(@"%@", NSStringFromPoint(myCheck.diagonalPosition));
        }
    }
}

- (void) whoIsEnemy {
    if ([self.whichMove isEqualToString:@"W"]) {
        friendPlayer = firstPlayer;
        enemyPlayer = secondPlayer;
    } else {
        friendPlayer = secondPlayer;
        enemyPlayer = firstPlayer;
    }
}

- (BOOL) isMovePossible {
    Checkers* currentCheck = [friendPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(firstTouchPos)];
    NSMutableArray *arrayOfCurrentDiagonal;
    
    for (int j = 0; j < 2; j++) {
        if (j == 0) {
            arrayOfCurrentDiagonal = [arrayOfDiagonals objectAtIndex:currentCheck.diagonalPosition.x];
        } else if (currentCheck.position.y != 100) {
            arrayOfCurrentDiagonal = [arrayOfDiagonals objectAtIndex:currentCheck.diagonalPosition.y];
        }
        if ([arrayOfCurrentDiagonal containsObject:[NSValue valueWithPoint:secondTouchPos]]) {
            
            if (labs((NSInteger)[arrayOfCurrentDiagonal indexOfObject:[NSValue valueWithPoint:secondTouchPos]] - (NSInteger)[arrayOfCurrentDiagonal indexOfObject:[NSValue valueWithPoint:firstTouchPos]]) == 1) {
                walkingDiagonal = [arrayOfDiagonals indexOfObject:arrayOfCurrentDiagonal];
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL) makeMove {
    if (![fieldDictionary objectForKey:NSStringFromPoint(secondTouchPos)]) {
        NSLog(@"nothing");
        Checkers *check = [friendPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(firstTouchPos)];
        if (!check.isDamka) {
            if ([_whichMove isEqualToString:@"W"]) {
                if ([arrayOfDiagonals[walkingDiagonal] indexOfObject:[NSValue valueWithPoint:secondTouchPos]] < [arrayOfDiagonals[walkingDiagonal] indexOfObject:[NSValue valueWithPoint:firstTouchPos]]) {
                    return NO;
                }
            } else if ([arrayOfDiagonals[walkingDiagonal] indexOfObject:[NSValue valueWithPoint:secondTouchPos]] > [arrayOfDiagonals[walkingDiagonal] indexOfObject:[NSValue valueWithPoint:firstTouchPos]]) {
                return NO;
            }
        }
        check.position = secondTouchPos;
        check.diagonalPosition = [self returnNewPointOnDiagonalWithPoint:secondTouchPos];
        [friendPlayer.dictionaryOfCheckers removeObjectForKey:NSStringFromPoint(firstTouchPos)];
        [friendPlayer.dictionaryOfCheckers setObject:check forKey:NSStringFromPoint(secondTouchPos)];
        return YES;
    } else if ([enemyPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(secondTouchPos)]) {
        NSLog(@"enemy");
        NSLog(@"%ld", walkingDiagonal);
        NSInteger diagPosFirst = 100;
        NSInteger diagPosSec = 100;
        NSInteger coef = 0;
        for (int i = 0; i < [arrayOfDiagonals[walkingDiagonal] count]; i++) {
            if ([arrayOfDiagonals[walkingDiagonal][i] pointValue].x == firstTouchPos.x && [arrayOfDiagonals[walkingDiagonal][i] pointValue].y == firstTouchPos.y) {
                diagPosFirst = i;
            }
            if ([arrayOfDiagonals[walkingDiagonal][i] pointValue].x == secondTouchPos.x && [arrayOfDiagonals[walkingDiagonal][i] pointValue].y == secondTouchPos.y) {
                diagPosSec = i;
            }
        }
        if (diagPosSec > diagPosFirst)  {
            if (diagPosSec != [arrayOfDiagonals[walkingDiagonal] count]-1) {
                coef = 1;
            }
        } else if (diagPosSec > 0) {
            coef = -1;
        }
        if (!coef) {
            return NO;
        }
        if (![fieldDictionary objectForKey:NSStringFromPoint([arrayOfDiagonals[walkingDiagonal][diagPosSec + coef] pointValue])]) {
            Checkers *check = [friendPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(firstTouchPos)];
            check.position = [arrayOfDiagonals[walkingDiagonal][diagPosSec + coef] pointValue];
            check.diagonalPosition = [self returnNewPointOnDiagonalWithPoint:check.position];
            [friendPlayer.dictionaryOfCheckers removeObjectForKey:NSStringFromPoint(firstTouchPos)];
            [friendPlayer.dictionaryOfCheckers setObject:check forKey:NSStringFromPoint(check.position)];
            [enemyPlayer.dictionaryOfCheckers removeObjectForKey:NSStringFromPoint(secondTouchPos)];
            return YES;
        } else {
            NSLog(@"cannot eat");
        }
    }
    return NO;
}

- (NSPoint) returnNewPointOnDiagonalWithPoint:(NSPoint) recievedPoint {
    NSPoint returnPoint = NSMakePoint(100, 100);
    for (NSMutableArray *array in arrayOfDiagonals) {
        for (id value in array) {
            NSPoint point = [value pointValue];
            if (point.x == recievedPoint.x && point.y == recievedPoint.y) {
                if (returnPoint.x == 100) {
                    returnPoint.x = [arrayOfDiagonals indexOfObject:array];
                } else {
                    returnPoint.y = [arrayOfDiagonals indexOfObject:array];
                }
            }
        }
    }
    return returnPoint;
}

- (void) changeSide {
    if ([_whichMove isEqualToString:@"W"]) {
        _whichMove = @"B";
    } else {
        _whichMove = @"W";
    }
}

- (void) becameKing {
    for (int j = 0; j < 4; j++) {
        if ([firstPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(NSMakePoint((j * 2) + 1, 7))]) {
            Checkers *checker = [firstPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(NSMakePoint((j * 2) + 1, 7))];
            checker.isDamka = YES;
            NSLog(@"Damka!");
        }
        if ([secondPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(NSMakePoint(j * 2, 0))]) {
            Checkers *checker = [secondPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(NSMakePoint(j * 2, 0))];
            checker.isDamka = YES;
            NSLog(@"Damka!");
        }
    }
}

@end