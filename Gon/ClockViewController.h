//
//  ViewController.h
//  Gon
//
//  Created by Hery on 1/7/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ClockViewController : UIViewController <AVAudioPlayerDelegate> {
    NSString *status;
    AVAudioPlayer *audioPlayer;
    ACAccountStore *accountStore;
    ACAccount *facebookAccount;
    AVSpeechSynthesizer *synthesizer;
}

@property (weak, nonatomic) IBOutlet UILabel *clockTimeLabel;

- (NSString *)getFacebookMessages;

@end
