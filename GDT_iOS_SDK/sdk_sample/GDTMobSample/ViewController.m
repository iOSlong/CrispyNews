//
//  ViewController.m
//  GDTMobSample
//
//  Created by GaoChao on 13-10-31.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "BannerViewController.h"
#import "InterstitialViewController.h"
#import "NativeViewController.h"
#import "SplashViewController.h"

@interface ViewController ()

@property (nonatomic, retain)   UIStoryboard *storyBoard;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
 
    demoTitles = [[NSArray alloc] initWithObjects:@"Banner广告",@"插屏广告",@"原生广告",@"开屏广告", nil];
    _storyBoard = [UIStoryboard storyboardWithName:@"GDTStoryboard" bundle:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [demoTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.textLabel.text = demoTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self showBannerView];
            break;
        case 1:
            [self showInterstitialView];
            break;
        case 2:
            [self showNativeView];
            break;
        case 3:
            [self showSplashView];
        default:
            break;
    }
}

-(void)showBannerView
{
    UIViewController *viewcontroller = [_storyBoard instantiateViewControllerWithIdentifier:@"gdtbannerviewcontroller"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)showInterstitialView
{
    UIViewController *viewcontroller = [_storyBoard instantiateViewControllerWithIdentifier:@"gdtinterstitialviewcontroller"];
    
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)showNativeView
{
    UIViewController *viewcontroller = [_storyBoard instantiateViewControllerWithIdentifier:@"gdtnativeviewcontroller"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)showSplashView
{
    UIViewController *viewcontroller = [_storyBoard instantiateViewControllerWithIdentifier:@"gdtsplashviewcontroller"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

@end
