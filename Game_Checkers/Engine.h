//
//  Engine.h
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Server;
@interface Engine : NSObject

@property (assign, nonatomic) NSString *whichMove;
@property (assign, nonatomic) BOOL needRedIndicator;
@property (assign, nonatomic) BOOL isMultiPleer;
@property (assign, nonatomic) BOOL wait;
@property (strong, nonatomic) Server *server;

#pragma mark - Class Methods

- (instancetype)initWithSide:(NSString *) str;

#pragma mark - Object Methods

- (NSMutableDictionary *) makeTransformationWithPoint:(NSPoint) point;

- (NSMutableDictionary *) returnFirstLaunchFieldDictionary;

@end
