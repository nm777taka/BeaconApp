//
//  LocationItemsMainViewController.m
//  LocationItems
//
//  Created by TakahisaFuruta on 2014/05/23.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "LocationItemsMainViewController.h"

@interface LocationItemsMainViewController ()
- (IBAction)minorNumber:(id)sender;
- (IBAction)majorNumber:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *majorNumber;
@property (weak, nonatomic) IBOutlet UITextField *minorNumber;


@end

@implementation LocationItemsMainViewController {
    CBPeripheralManager *_peripheralManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.minorNumber.delegate = self;
    self.majorNumber.delegate = self;
    _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:DISPATCH_QUEUE_PRIORITY_DEFAULT options:0];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getBeaconID];
    [self beaconing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(LocationItemsFlipsideViewController *)controller
{
    [self beaconing:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - Beacon job
- (void)beaconing:(BOOL)flag
{
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"そのうち設定するよ"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc]
                              initWithProximityUUID:uuid
                              major:[self.majorNumber.text intValue]
                              minor:[self.minorNumber.text intValue]
                              identifier:@"idstr"];
    NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:nil];
    
    switch (flag) {
        case YES:
            [_peripheralManager startAdvertising:peripheralData];
            [[UIApplication sharedApplication]setIdleTimerDisabled:YES]; //iPhoneがスリープしないように
            break;
            
        case NO:
            [_peripheralManager stopAdvertising];
            [[UIApplication sharedApplication]setIdleTimerDisabled:NO];
            break;
            
        default:
            break;
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

#pragma mark - Major/Minor edit

- (IBAction)minorNumber:(id)sender {
    [self beaconing:NO];
    [self beaconing:YES];
    [self setBeaconID];
}

- (IBAction)majorNumber:(id)sender {
    [self beaconing:NO];
    [self beaconing:YES];
    [self setBeaconID];
}

- (void)setBeaconID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.majorNumber.text forKey:@"majorNumber"];
    [defaults setObject:self.minorNumber.text forKey:@"minorNumber"];
}

- (void)getBeaconID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *major = [defaults objectForKey:@"majorNumber"];
    if ([major length] > 0) {
        self.majorNumber.text = major;
    }
    
    NSString *minor = [defaults objectForKey:@"minorNumber"];
    if (minor.length > 0) {
        self.minorNumber.text = minor;
    }
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
