//
//  Checkers.m
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "Checkers.h"

@implementation Checkers


- (instancetype)init
{
    self = [super init];
    if (self) {
        _diagonalPosition = NSMakePoint(100, 100);
    }
    return self;
}
@end
