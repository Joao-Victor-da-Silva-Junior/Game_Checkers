//
//  Checkers.h
//  Курсач Шашки
//
//  Created by Виктор on 13.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checkers : NSObject

@property (assign, nonatomic) NSPoint position;

@property (assign, nonatomic) BOOL isWhite;
@property (assign, nonatomic) BOOL isDamka;

@end
