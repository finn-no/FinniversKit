//
//  Copyright © 2018 FINN AS. All rights reserved.
//

#import "AVAudioSession+Swift.h"

@implementation AVAudioSession (Swift)

- (BOOL)swift_setCategory:(AVAudioSessionCategory)category error:(NSError **)outError {
    return [self setCategory:category error:outError];
}

@end
