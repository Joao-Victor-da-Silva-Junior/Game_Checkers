//
//  FieldView.h
//  Курсач Шашки
//
//  Created by Виктор on 12.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FieldView : NSView

@property (assign, nonatomic) BOOL isStartGame;
@property (assign, nonatomic) BOOL isChose;
@property (assign, nonatomic) BOOL needRedIndicator;
@property (assign, nonatomic) NSPoint pointerPosition;
@property (strong, nonatomic) NSMutableDictionary *dictionaryOfAllField;

@end
