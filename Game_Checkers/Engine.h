//
//  Engine.h
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Engine : NSObject

@property (assign, nonatomic) NSString *whichMove;
@property (assign, nonatomic) BOOL needRedIndicator;

#pragma mark - Class Methods

- (instancetype)initWithSide:(NSString *) str;

#pragma mark - Object Methods

- (NSMutableDictionary *) makeTransformationWithPoint:(NSPoint) point;

- (NSMutableDictionary *) returnFirstLaunchFieldDictionary;

@end
