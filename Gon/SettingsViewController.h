//
//  SettingsViewController.h
//  Gon
//
//  Created by Hery on 1/7/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *wakeUpTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *voiceDelay;

- (IBAction)applySettings:(id)sender;

@end
