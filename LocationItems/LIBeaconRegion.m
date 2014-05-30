//
//  LIBeaconRegion.m
//  LocationItems
//
//  Created by 古田貴久 on 2014/05/30.
//  Copyright (c) 2014年 古田貴久. All rights reserved.
//

#import "LIBeaconRegion.h"



@implementation LIBeaconRegion

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)clearFlags
{
    self.rangingEnabled = NO;
    self.isMonitoring = NO;
    self.hasEntered = NO;
    self.isRanging = NO;
    self.failCount = 0;
    self.beacons = nil;
}

@end
