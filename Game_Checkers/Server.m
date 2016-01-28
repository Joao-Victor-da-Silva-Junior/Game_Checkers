//
//  Server.m
//  Game_Checkers
//
//  Created by Виктор on 27.01.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "Server.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define LEN 50

@implementation Server {
    int clilen;
    struct sockaddr_in servAddr, cliAddr;
}

- (instancetype)initServer
{
    self = [super init];
    if (self) {
        _socket = socket(AF_INET, SOCK_DGRAM, 0);
      //  struct sockaddr_in servAddr, cliAddr;
        servAddr.sin_family = AF_INET;
        servAddr.sin_port = htons(2000);
        servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    }
    return self;
}

- (instancetype)initClient
{
    self = [super init];
    if (self) {
        _socket = socket(AF_INET, SOCK_DGRAM, 0);
       // struct sockaddr_in servAddr;
        servAddr.sin_family = AF_INET;
        servAddr.sin_port = htons(2000);
        servAddr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
        
    }
    return self;
}

- (NSPoint) waitOutside {
    NSPoint aPoint;
    while (1) {
        clilen = sizeof(cliAddr);
        if (recvfrom(_socket, (__bridge void *)(_recievedString) , LEN, 0, (struct sockaddr *) &cliAddr, &clilen) < 0) {
            perror("Recv");
            close (_socket);
            exit(0);
        }
        aPoint = NSPointFromString(_recievedString);
        NSLog(@"%@", NSStringFromPoint(aPoint));
    }
    return aPoint;
}

- (void) sendToWithPoint:(NSPoint) aPoint {
    _recievedString = NSStringFromPoint(aPoint);
    while (1) {
        if (sendto(_socket, (__bridge const void *)(_recievedString), 10, 0, (struct sockaddr *) &servAddr, (sizeof(servAddr)) < 0)) {
            perror("Send");
            close (_socket);
            exit(1);
        }
        
    }
}
@end
