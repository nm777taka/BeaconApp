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
@property LIBeaconMonitoringStatus monitoringStatus;
@property BOOL monitoringEnabled;
@property BOOL isMonitoring;

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
        
        self.regions = [NSMutableArray new];
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

#pragma mark - CLLocationManagerDelegate(Responding to Region Events)
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
}

- (NSString *)regionStateString:(CLRegionState)state
{
    switch (state) {
        case CLRegionStateInside:
            return @"Inside";
            break;
        case CLRegionStateOutside:
            return @"Outside";
            break;
        case CLRegionStateUnknown:
            return @"Unknown";
            break;
            
        default:
            break;
    }
    return @"";
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"didDetermineState:%@(%@)",[self regionStateString:state],region.identifier);
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        switch (state) {
            case CLRegionStateInside:
                //なんかする
                break;
            case CLRegionStateOutside:
            case CLRegionStateUnknown:
                //なんかする
                break;
                
            default:
                break;
        }
    }
}

//デバイス設定変更次のリージョン監視設定失敗対策
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion:%@(%@)",region.identifier,error);
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        //lookupMethod呼ぶ
    }
}

#pragma mark -- モニタリング --
- (BOOL)isMonitoringCapable
{
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        return NO;
    }
    //Bluetoothがオンになっていない
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        return NO;
    }
    
    //位置情報サービス関連
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        
        return NO;
    }
    
    return YES;
}
- (void)startMonitoring
{
    self.monitoringEnabled = YES;
    [self startMonitoringAllRegion];
}

- (void)stopMonitoring
{
    self.monitoringEnabled = NO;
    
}

- (void)startMonitoringAllRegion
{
    if (!self.monitoringEnabled) {
        return;
    }
    if (![self isMonitoringCapable]) {
        return;
    }
    if (self.isMonitoring) {
        return;
    }
    
    NSLog(@"Start Monitoring");
    for (LIBeaconRegion *region in self.regions) {
        [self startMonitoringRegion:region];
    }
    self.isMonitoring = YES;
    //モニタリングの状態をアップデート
}

- (void)startMonitoringRegion:(LIBeaconRegion*)region
{
    [self.locationManager startMonitoringForRegion:region];
    region.isMonitoring = YES;
}

- (void)stopMonitoringAllRegion
{
    if (!self.isMonitoring) {
        return;
    }
    NSLog(@"Stop monitoring");
    for (LIBeaconRegion *region in self.regions) {
        [self stopMonitoringRegion:region];
    }
}

- (void)stopMonitoringRegion:(LIBeaconRegion *)region
{
    [self.locationManager stopMonitoringForRegion:region];
    //レンジングを止める
    region.isMonitoring = NO;
    if (region.hasEntered) {
        region.hasEntered = NO;
        
        //デリゲート
    }
}

@end
