#import "FieldView.h"

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
            if ([[self.dictionaryOfAllField objectForKey:key] containsString:@"White"]) {
                [[NSColor whiteColor] set];
            } else {
                [[NSColor blackColor] set];
            }
            circlePath = [NSBezierPath bezierPath];
            [circlePath appendBezierPathWithOvalInRect:NSMakeRect(5 + (50 * (int)NSPointFromString(key).x), 5 + (50 * (int)NSPointFromString(key).y), 40, 40)];
            [circlePath stroke];
            [circlePath fill];
            if ([[self.dictionaryOfAllField objectForKey:key] containsString:@"D"]) {
                NSBezierPath *kingPath = [NSBezierPath bezierPath];
                if ([[self.dictionaryOfAllField objectForKey:key] containsString:@"White"]) {
                    [[NSColor blackColor] set];
                } else {
                    [[NSColor whiteColor] set];
                }
                [kingPath appendBezierPathWithOvalInRect:NSMakeRect(20 + (50 * (int)NSPointFromString(key).x), 20 + (50 * (int)NSPointFromString(key).y), 10, 10)];
                [kingPath stroke];
                [kingPath fill];
            }
        }
    }
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
