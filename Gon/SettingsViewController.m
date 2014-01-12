//
//  SettingsViewController.m
//  Gon
//
//  Created by Hery on 1/7/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applySettings:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[_wakeUpTime date] forKey:@"wakeUpTime"];
    
    UILocalNotification *wakeUpNotification = [[UILocalNotification alloc] init];
    wakeUpNotification.fireDate = [_wakeUpTime date];
    wakeUpNotification.timeZone = [NSTimeZone defaultTimeZone];
    wakeUpNotification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Wake up!", nil)];
    wakeUpNotification.applicationIconBadgeNumber = 0;
    wakeUpNotification.alertAction = NSLocalizedString(@"Go!", nil);
    wakeUpNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:wakeUpNotification];
    NSLog(@"%@", wakeUpNotification.fireDate);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
