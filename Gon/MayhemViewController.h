//
//  MayhemViewController.h
//  Gon
//
//  Created by Hery on 1/7/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MayhemViewController : UIViewController <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
}

@end
