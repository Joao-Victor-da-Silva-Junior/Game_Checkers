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


- (instancetype)initWhite:(BOOL) isWhite {
    
    self = [super init];
    if (self) {
        _isWhite = isWhite;
        _dictionaryOfCheckers = [NSMutableDictionary dictionaryWithCapacity:12];
        NSPoint range;
        if (isWhite) {
            range = NSMakePoint(0, 3);
        } else {
            range = NSMakePoint(5, 8);
        }
        for (int i = 0; i < 8; i++) {
            for (int j = (int) range.x; j < (int) range.y ; j++) {
                if ((i + j) % 2 == 0) {
                    Checkers *checker = [[Checkers alloc] init];
                    checker.isWhite = isWhite;
                    checker.position = NSMakePoint(i, j);
                    [_arrayOfCheckers addObject:checker];
                    [_dictionaryOfCheckers setObject:checker forKey:NSStringFromPoint(checker.position)];
                }
            }
        }

    }
    return self;
}

- (NSMutableDictionary *) returnDictionaryOfColors {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in self.dictionaryOfCheckers) {
        Checkers *check = [self.dictionaryOfCheckers objectForKey:key];
        if (check.isDamka) {
            [returnDictionary setObject:self.isWhite? @"WhiteD":@"BlackD" forKey:key];
        } else {
            [returnDictionary setObject:self.isWhite? @"White":@"Black" forKey:key];
        }
    }
    return returnDictionary;
}

@end
