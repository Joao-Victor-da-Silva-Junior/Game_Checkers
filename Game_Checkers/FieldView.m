//
//  FieldView.m
//  Курсач Шашки
//
//  Created by Виктор on 12.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "FieldView.h"
#import "Checkers.h"

@implementation FieldView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor colorWithCalibratedRed:0.95f green:0.95f blue:0.95f alpha:1] set];
    NSRectFill([self bounds]);
    [self makeGameField];
    if (_isStartGame) {
        [self setFigures];
        if (_isChose) {
            if (((int)self.pointerPosition.x / 50 + (int)self.pointerPosition.y / 50) % 2 == 0) {
                [self setRedPointer];
            } else {
                [self setYellowPointer];
            }
        } else {
            [self setYellowPointer];
        }
    }
}

- (void) makeGameField {
    [[NSColor grayColor] set];
    NSInteger step = 0;
    NSInteger step2 = 0;
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if ((j + i) % 2 == 0) {
                NSRectFill(NSMakeRect(0 + step2, 0 + step, 50, 50));
            }
            step += 50;
        }
        step = 0;
        step2 += 50;
    }
}

- (void) setFigures {
    NSBezierPath *circlePath;
    
    for (NSString *key in self.dictionaryOfAllField) {
        if (![[self.dictionaryOfAllField objectForKey:key] isEqualToString:@"nil"]) {
            if ([[self.dictionaryOfAllField objectForKey:key] isEqualToString:@"White"]) {
                [[NSColor whiteColor] set];
            } else {
                [[NSColor blackColor] set];
            }
            circlePath = [NSBezierPath bezierPath];
            [circlePath appendBezierPathWithOvalInRect:NSMakeRect(5 + (50 * (int)NSPointFromString(key).x), 5 + (50 * (int)NSPointFromString(key).y), 40, 40)];
            [circlePath stroke];
            [circlePath fill];
        }
    }
  /*  for (Checkers *check in self.arrayOfAllCheckers) {
        if (check.isWhite) {
            [[NSColor whiteColor] set];
        } else {
            [[NSColor blackColor] set];
        }
        circlePath = [NSBezierPath bezierPath];
        [circlePath appendBezierPathWithOvalInRect:NSMakeRect(5 + (50 * check.position.x), 5 + (50 * check.position.y), 40, 40)];
        [circlePath stroke];
        [circlePath fill];
    }*/
}

- (void) setYellowPointer {
    NSBezierPath *pointer = [NSBezierPath bezierPath];
    [pointer appendBezierPathWithRect:NSMakeRect(_pointerPosition.x*50, _pointerPosition.y*50, 50, 50)];
    [[NSColor colorWithCalibratedRed:1.f green:1.f blue:0.f alpha:1.f] set];
    pointer.lineWidth = 4.f;
    [pointer stroke];
}
- (void) setRedPointer {
    NSBezierPath *pointer = [NSBezierPath bezierPath];
    [pointer appendBezierPathWithRect:NSMakeRect(_pointerPosition.x*50, _pointerPosition.y*50, 50, 50)];
    [[NSColor colorWithCalibratedRed:1.f green:0.f blue:0.f alpha:1.f] set];
    pointer.lineWidth = 4.f;
    [pointer stroke];
}
@end
