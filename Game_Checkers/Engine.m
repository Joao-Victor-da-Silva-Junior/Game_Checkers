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
    BOOL needEat;
    BOOL continueEat;
    NSPoint firstTouchPos;
    NSPoint secondTouchPos;
    NSMutableDictionary *fieldDictionary;  // {1,1} - White/black (simple representation for field)
    NSMutableArray *arrayOfDiagonals;      // All diagonals of field
    NSInteger walkingDiagonal;
    Players *firstPlayer;
    Players *secondPlayer;
    Players *friendPlayer; // friend/enemy for better representation, for Engine doesn't matter, who is who (Second or First player)
    Players *enemyPlayer;  //
}

@end

@implementation Engine

#pragma mark - Init Method

- (instancetype)initWithSide:(NSString *)str {
    
    self = [super init];
    if (self) {
        _whichMove = str;
        _needRedIndicator = NO;
        needEat = NO;
        continueEat = NO;
        _wait = NO;
        firstTouchPos = secondTouchPos = NSMakePoint(100, 100);
    }
    return self;
}

#pragma mark - Main Methods

- (NSMutableDictionary *) returnFirstLaunchFieldDictionary {
    
    fieldDictionary = [NSMutableDictionary dictionary];
    firstPlayer = [[Players alloc] initWhite:YES];
    secondPlayer = [[Players alloc] initWhite:NO];
    [self updateFieldDictionary];
    [self createArrayOfDiagonals];
    [self setCheckersToFieldDictionary];
    return fieldDictionary;
} //Create Players, dictionary of field

- (NSMutableDictionary *) makeTransformationWithPoint:(NSPoint) point {
    [self setPoints:point];
    if (youHaveTwoPoints) {
        [self whoIsEnemy];
        if ([self isMovePossible]) {
            if ([self makeMove]) {
                [self becameKing];
                if (!continueEat) {
                    if (_wait) {
                        _wait = NO;
                    } else {
                        [self changeSide];
                    }
                }
            }
        }
        
        [self clearPoints];
    }
    [self updateFieldDictionary];
    return fieldDictionary;
}

#pragma mark - Moving Methods

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
    
    arrayOfDiagonals = [NSMutableArray arrayWithCapacity:13];
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

    for (int i = 0; i < 13; i++) {
        if (i < 4) {
            valueX = 0;
            valueY = 6;
            creator(valueX, valueY - (2 * i), i);
        } else if (i < 7) {
            valueX = 2;
            valueY = 0;
            creator(valueX + (2 * (i - 4)), valueY, i);
        } else if (i < 10) {
            step = -1;
            valueX = 2;
            valueY = 0;
            creator(valueX + (2 * (i - 7)), valueY, i);
        } else {
            valueX = 7;
            valueY = 1;
            creator(valueX, valueY + 2 * (i - 10), i);
        }
        NSLog(@"%@", arrayOfDiagonals[i]);
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
        } else if (currentCheck.diagonalPosition.y != 100) {
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
        if (needEat || continueEat) {
            return NO;
        }
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
        [self updateFieldDictionary];
        needEat = [self fullScan];
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
            [self updateFieldDictionary];
            continueEat = [self scanFieldWithPoint:check.position withConditionAfter:@"Eat"];
            needEat = [self fullScan];
            return YES;
        } else {
            return NO;
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
        }
        if ([secondPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(NSMakePoint(j * 2, 0))]) {
            Checkers *checker = [secondPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(NSMakePoint(j * 2, 0))];
            checker.isDamka = YES;
        }
    }
}

#pragma mark - Scan Methods

- (BOOL) scanFieldWithPoint:(NSPoint) point withConditionAfter:(NSString *) str {
    NSInteger coef;
    NSRange range;
    if ([str isEqualToString:@"Eat"]) {
        coef = -1;
    } else {
        coef = 2;
    }
    Checkers *myCheck = [friendPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint(point)];
    NSMutableArray *searchingArray;
    NSInteger currentIndex = 100;
    if (myCheck.diagonalPosition.x == 100) {
        return NO;
    }
    for (int i = 0; i < 4; i++) {
        if (i < 2) {
            searchingArray = [arrayOfDiagonals objectAtIndex:(int)myCheck.diagonalPosition.x];
            currentIndex = [searchingArray indexOfObject:[NSValue valueWithPoint:myCheck.position]];
        } else if (myCheck.diagonalPosition.y != 100) {
            searchingArray = [arrayOfDiagonals objectAtIndex:(int)myCheck.diagonalPosition.y];
            currentIndex = [searchingArray indexOfObject:[NSValue valueWithPoint:myCheck.position]];
        }
        if (i % 2) {
            currentIndex++;
            if (currentIndex - coef < 0) {
                range = NSMakeRange(currentIndex, 1000);
            } else {
                range = NSMakeRange(currentIndex, currentIndex - coef);
            }
            NSLog(@"%@", NSStringFromRange(range));
        } else {
            currentIndex--;
            if (currentIndex < 0) {
                range = NSMakeRange(1000, currentIndex + coef);
            } else {
                range = NSMakeRange(currentIndex, currentIndex + coef);
            }
            NSLog(@"%@", NSStringFromRange(range));
        }
        
        if (NSRangeContainsRange(NSMakeRange(0, [searchingArray count]), range)) {
            if ([enemyPlayer.dictionaryOfCheckers objectForKey:NSStringFromPoint([searchingArray[range.location] pointValue])]) {
                if (![fieldDictionary objectForKey:NSStringFromPoint([searchingArray[range.length] pointValue])]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (BOOL) fullScan {
    
    __weak NSMutableDictionary *weakEnemyDict = enemyPlayer.dictionaryOfCheckers;
    __weak NSMutableDictionary *weakFriendDict = friendPlayer.dictionaryOfCheckers;
    __weak NSMutableDictionary *weakFieldDictionary = fieldDictionary;
    
    BOOL (^mustEat)(NSMutableArray*, int, int) = ^(NSMutableArray *array, int index, int coef) {
        
        if ([weakEnemyDict objectForKey:NSStringFromPoint([array[index] pointValue])]) {
            if ([weakFriendDict objectForKey:NSStringFromPoint([array[index + coef] pointValue])]) {
                if (![weakFieldDictionary objectForKey:NSStringFromPoint([array[index + 2*coef] pointValue])]) {
                    return YES;
                }
            }
        }
        return NO;
    };
    for (NSMutableArray *diagonalArray in arrayOfDiagonals) {
        for (int j = 0; j < [diagonalArray count] - 2; j++) {
            if (mustEat(diagonalArray, j, 1)) {
                return YES;
            }
        }
        for (int j = (int)[diagonalArray count]-1; j >= 2; j--) {
            if (mustEat(diagonalArray, j, -1)) {
                return YES;
            }
        }
    }
    return NO;
}

- (void) updateFieldDictionary {
    [fieldDictionary removeAllObjects];
    [fieldDictionary addEntriesFromDictionary:[firstPlayer returnDictionaryOfColors]];
    [fieldDictionary addEntriesFromDictionary:[secondPlayer returnDictionaryOfColors]];
}

bool NSRangeContainsRange (NSRange range1, NSRange range2) {
    BOOL retval = NO;
    if (range2.location < range1.length && range2.length < range1.length) {
        retval = YES;;
    }
    return retval;
}

- (BOOL) waiting {
    while (1) {
    }
    return YES;
}

@end