//
//  LIBeacon.m
//  LocationItems
//
//  Created by 古田貴久 on 2014/05/30.
//  Copyright (c) 2014年 古田貴久. All rights reserved.
//

#import "LIBeacon.h"

@interface LIBeacon()

@property CBPeripheralManager *peripheralManager;
@property CLLocationManager *locationManager;

@end

@implementation LIBeacon

static LIBeacon* _sharedInstance = nil;


+ (LIBeacon *)sharedManager
{
    if (!_sharedInstance) {
        _sharedInstance = [LIBeacon new];
    }
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        
        self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

#pragma mark CBPeripheralManagerDelegate
- (NSString *)peripheralStateString:(CBPeripheralManagerState)state
{
    switch (state) {
        case CBPeripheralManagerStatePoweredOn:
            return @"On";
            break;
            
        case CBPeripheralManagerStatePoweredOff:
            return @"Off";
            break;
            
        case CBPeripheralManagerStateResetting:
            return @"Resetting";
            break;
        
        case CBPeripheralManagerStateUnknown:
            return @"Unknow";
            break;
        case CBPeripheralManagerStateUnauthorized:
            return @"Unauthorized";
            break;
            
        case CBPeripheralManagerStateUnsupported:
            return @"Unsupported";
            break;
            
        default:
            break;
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManagerDidUpdateState: %@",[self peripheralStateString:peripheral.state]);
}

#pragma mark - CLLocatonManagerDelegate (Responding to Authorization Changes)

- (NSString *)locationAuthorizationStatusString:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            return @"Authorized";
            break;
            
        case kCLAuthorizationStatusDenied:
            return @"Denied";
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            return @"Not Determined";
            break;
            
        case kCLAuthorizationStatusRestricted:
            return @"Restricted";
            break;
            
        default:
            break;
    }
    
    return @"";
}

//位置情報サービスの設定が変更されると呼ばれる

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus:%@",[self locationAuthorizationStatusString:status]);
}

@end
