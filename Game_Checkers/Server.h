//
//  Server.h
//  Game_Checkers
//
//  Created by Виктор on 27.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

@interface Server : NSObject

@property (assign, nonatomic) int socket;
@property (strong, nonatomic) NSString *recievedString;

- (instancetype)initClient;

- (instancetype)initServer;


- (NSPoint) waitOutside;
- (void) sendToWithPoint:(NSPoint) aPoint;

@end
