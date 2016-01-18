//
//  Players.h
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Players : NSObject

@property (assign, nonatomic) BOOL isWhite;
@property (strong, nonatomic) NSMutableArray *arrayOfCheckers;
@property (strong, nonatomic) NSMutableDictionary *dictionaryOfCheckers;

- (instancetype)initWhite:(BOOL) isWhite;

- (NSMutableDictionary *) returnDictionaryOfColors;

@end
