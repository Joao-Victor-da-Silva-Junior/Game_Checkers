//
//  Players.m
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "Players.h"
#import "Checkers.h"

@implementation Players

- (instancetype)initMe {
    self = [super init];
    if (self) {
        _arrayOfCheckers = [NSMutableArray arrayWithCapacity:12];
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 3; j++) {
                if ((i + j) % 2 == 0) {
                    Checkers *checker = [[Checkers alloc] init];
                    checker.isWhite = YES;
                    checker.position = NSMakePoint(i, j);
                    [_arrayOfCheckers addObject:checker];
                }
            }
        }
    }
    return self;
}

- (instancetype)initOpponent {
    self = [super init];
    if (self) {
        _arrayOfCheckers = [NSMutableArray arrayWithCapacity:12];
        for (int i = 0; i < 8; i++) {
            for (int j = 5; j < 8; j++) {
                if ((i + j) % 2 == 0) {
                    Checkers *checker = [[Checkers alloc] init];
                    checker.isWhite = NO;
                    checker.position = NSMakePoint(i, j);
                    [_arrayOfCheckers addObject:checker];
                }
            }
        }

    }
    return self;
}

@end
