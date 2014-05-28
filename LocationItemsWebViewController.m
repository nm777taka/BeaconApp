//
//  LocationItemsWebViewController.m
//  LocationItems
//
//  Created by TakahisaFuruta on 2014/05/23.
//  Copyright (c) 2014年 TakahisaFuruta. All rights reserved.
//

#import "LocationItemsWebViewController.h"

@interface LocationItemsWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation LocationItemsWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma  mark - ViewLifeCylcle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSString *urlString = [NSString stringWithFormat:@"http://newtonworks.sakura.ne.jp/wp/LocationItems/%02d-%02d",[self.majorNumber intValue],[self.minorNumber intValue]];
//    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    //imageViewに画像を表示する
    self.imageView.image = [UIImage imageNamed:@"Nana-Mizuki-LINKAGE-lyrics.jpg"];
    self.label.text = @"会いたかったよ！";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
