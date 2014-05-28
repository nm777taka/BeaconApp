//
//  LocationItemsFlipsideViewController.m
//  LocationItems
//
//  Created by TakahisaFuruta on 2014/05/23.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "LocationItemsFlipsideViewController.h"
#import "LocationItemsWebViewController.h"

#define CALIB_MAX 30


@interface LocationItemsFlipsideViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *calibButton;

@end

@implementation LocationItemsFlipsideViewController{
    
    CLLocationManager *_locationManager;
    NSUUID            *_uuid;
    CLBeaconRegion    *_region;
    NSMutableArray    *_beacons;
    BOOL              _showingWebView;
    NSNumber          *_webMajorNumber;
    NSNumber          *_webMinorNumber;
    
    //キャリブレーション
    NSMutableArray    *_calibBeacons; //収集するビーコン情報
    int               _calibCounter;  //収集するビーコンの数
    BOOL              _calibInProgress; //キャリブ中フラグ
    NSInteger         _measuredPower;   //キャリブ結果
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _uuid = [[NSUUID alloc]initWithUUIDString:@"3ACE8EC3-4F0E-4857-B2D8-18550DFDE39A"];
    //_uuid = [[NSUUID alloc]initWithUUIDBytes:0x3ACE8EC34F0E4857B2D818550DFDE39A];
    _region = [[CLBeaconRegion alloc]initWithProximityUUID:_uuid identifier:[_uuid UUIDString]];
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    _beacons = [NSMutableArray new];
    _showingWebView = NO;
    
    _calibBeacons = [NSMutableArray new];
    _calibInProgress = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [_locationManager startRangingBeaconsInRegion:_region];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (_showingWebView == NO) {
        [_locationManager stopRangingBeaconsInRegion:_region];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark - Beacon Job

//ビーコンが検出された時
//ビーコンとの距離が変化した時
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    [_beacons removeAllObjects];
    [_beacons addObjectsFromArray:beacons];
    
    //Beaconが取得できてない..?
    NSLog(@"beacons %@",beacons);
    
    
    NSLog(@"検出");
    
    //キャリブレーション
    if (_calibInProgress) {
        if (beacons.count == 1) {
            [_calibBeacons addObject:beacons[0]];
            _calibCounter--;
            if (_calibCounter <= 0) {
                [self calibCalc];
            }
            
            if (_calibCounter < -5) {
                _calibInProgress = NO;
                _calibButton.enabled = YES;
            }
        }
    }
    
    [self.tableView reloadData];
    
    int immediateCount = 0;
    int nearCount = 0;
    for (CLBeacon *beacon in _beacons) {
        if (beacon.proximity == CLProximityImmediate) {
            immediateCount++;
            //nearCount++;
            [self openWebPageMajor:beacon.major minor:beacon.minor];
        }
    }
    
    if (immediateCount == 0) {
        [self closeWebPage];
    }
}

#pragma  mark - Calibration
- (IBAction)calibration:(id)sender
{
    _calibButton.enabled = NO;
    _calibCounter = CALIB_MAX;
    _calibInProgress = YES;
}

- (void)calibCalc
{
    [_calibBeacons sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:YES]]];
    
    NSArray *sample =
    [_calibBeacons subarrayWithRange:NSMakeRange(CALIB_MAX*0.1, CALIB_MAX*0.8)];
    _measuredPower = [[sample valueForKeyPath:@"@avg.rssi"] integerValue];
    NSLog(@"power=%d",_measuredPower);
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _beacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    
    NSLog(@"cell for index");
    
    return cell;
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CLBeacon *beacon = [_beacons objectAtIndex:indexPath.row];
    NSString *prox;
    switch (beacon.proximity) {
        case CLProximityImmediate:
            prox = @"Immediate";
            break;
            
        case CLProximityNear:
            prox = @"Near";
            break;
        case CLProximityFar:
            prox = @"Far";
            break;
        case CLProximityUnknown:
            prox = @"Unknown";
            break;
            
        default:
            break;
    }
    
    //キャリブレーションパート
    if (_calibInProgress) {
        if (_calibCounter > 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Calibration %d",_calibCounter];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"Measured Power %d",_measuredPower];
        }
    } else {
        cell.textLabel.text = [beacon.proximityUUID UUIDString];
        NSLog(@"入った");
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Major:%@ , Minor:%@, Prox:%@ Acc: %.2fm RSSI:%d",
                                 beacon.major,beacon.minor,prox,beacon.accuracy,beacon.rssi     ];
}

#pragma mark - Web Job
- (void)openWebPageMajor:(NSNumber *)majorNumber minor:(NSNumber *)minorNumber
{
    if (_showingWebView == NO) {
        _webMajorNumber = majorNumber;
        _webMinorNumber = minorNumber;
        [self performSegueWithIdentifier:@"showWebPage" sender:self];
        _showingWebView = YES;
        NSLog(@"Show web page of %02d-%02d",[majorNumber intValue],[minorNumber intValue]);
    }
}

- (void)closeWebPage
{
    if (_showingWebView == YES) {
        if (![self isBeingDismissed]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }
    _showingWebView = NO;
    NSLog(@"Hide Web page");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWebPage"]) {
        
        LocationItemsWebViewController *nextViewController = [segue destinationViewController];
        nextViewController.majorNumber = _webMajorNumber;
        nextViewController.minorNumber = _webMinorNumber;
    }
}
@end
