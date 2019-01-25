//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioSession (Swift)

- (BOOL)swift_setCategory:(AVAudioSessionCategory)category error:(NSError **)outError NS_SWIFT_NAME(setCategory(_:));

@end

NS_ASSUME_NONNULL_END
