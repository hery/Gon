//
//  ViewController.m
//  Gon
//
//  Created by Hery on 1/7/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ClockViewController.h"

@interface ClockViewController ()

@end

@implementation ClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBaribeau)];
    [self.view addGestureRecognizer:tap];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    // NSLog(@"XS to FB? %@", [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ? @"YES!" : @"Nope.");
    
    accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{ACFacebookAppIdKey: @"626629124053464",
                              ACFacebookPermissionsKey: @[@"read_mailbox", @"email"],
                              };
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
            facebookAccount = [accounts lastObject];
        } else {
            NSLog(@"Couldn't access Facebook account. Error: %@", [error localizedDescription]);
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *wakeUpTime = [userDefault objectForKey:@"wakeUpTime"];
    if (wakeUpTime) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *hour = [calendar components:NSHourCalendarUnit fromDate:wakeUpTime];
        NSDateComponents *minute = [calendar components:NSMinuteCalendarUnit fromDate:wakeUpTime];
        
        _clockTimeLabel.text = [NSString stringWithFormat:@"%i:%i", [hour hour], [minute minute]];
    } else {
        _clockTimeLabel.text = @"Time not set.";
    }
    
    // Nice background music
    NSString *trackPath = [[NSBundle mainBundle] pathForResource:@"tina" ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:trackPath];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    audioPlayer = newPlayer;
    [audioPlayer setVolume:0.5f];
    [audioPlayer play] ? NSLog(@"Playing.") : NSLog(@"Can't play.");
    audioPlayer.delegate = self;
    status = @"tina";
    
    // Facebook and Email notifications
    // Fetch Facebook notifications
    NSString *utteranceString = @"Good morning Hery! ";
    utteranceString = [utteranceString stringByAppendingString:self.getFacebookMessages];
//    AVSpeechUtterance *goodMorning = [[AVSpeechUtterance alloc] initWithString:utteranceString];
//    goodMorning.rate = 0.2f;
//    goodMorning.preUtteranceDelay = 3.0f;
//    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//    [synth speakUtterance:goodMorning];
}

- (void)playBaribeau
{
    [audioPlayer stop];
    if ([status isEqualToString:@"tina"]) {
        NSString *trackPath = [[NSBundle mainBundle] pathForResource:@"things" ofType:@"mp3"];
        NSURL *trackURL = [[NSURL alloc] initWithString:trackPath];
        AVAudioPlayer *baribeauPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:nil];
        audioPlayer = baribeauPlayer;
        [audioPlayer setVolume:1.0f];
        [audioPlayer play] ? NSLog(@"Playing.") : NSLog(@"Can't play.");
        status = @"baribeau";
    }
}

- (NSString *)getFacebookMessages
{
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/inbox"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
    request.account = facebookAccount;
    NSLog(@"Sending request.");
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
        for (NSDictionary *thread in [jsonResponse objectForKey:@"data"]) {
            NSString *unreadString = [thread objectForKey:@"unread"];
            int unread = [unreadString integerValue];
            if (unread > 0) {
                NSDictionary *comments = [thread objectForKey:@"comments"];
                NSArray *data = [comments objectForKey:@"data"];
                // process messages in reverse order
                for (int i=[data count]-1; i>=[data count]-unread; i--) {
                    NSDictionary *messageDictionary = [data objectAtIndex:i];
                    NSString *messageString = [messageDictionary objectForKey:@"message"];
                    NSDictionary *senderDictionary = [messageDictionary objectForKey:@"from"];
                    NSString *senderNameString = [senderDictionary objectForKey:@"name"];
                    NSLog(@"From %@: %@", senderNameString, messageString);
                }
                // NSLog(@"%@", thread);
            }
        }
    }];
    return @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
