//
//  Engine.h
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Engine : NSObject

+ (BOOL) indicatorSetterOnCoordinate:(NSPoint) point
                 withFieldDictionary:(NSMutableDictionary *) dictionary
                       andPlayerMove:(NSString *) move;

+ (NSMutableDictionary *) makeMoveWithFirstTouch:(NSPoint) firstPoint
                                     SecondTouch:(NSPoint) secondPoint
                                      playerMove:(NSString *) move
                              andFieldDictionary:(NSMutableDictionary *) fieldDictionary;

@end
