//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioSession (Swift)

- (BOOL)swift_setCategory:(AVAudioSessionCategory)category error:(NSError **)outError NS_SWIFT_NAME(swift_setCategory(_:)) __attribute__((deprecated("Remove when everyone is using Xcode 10.2 or above")));

@end

NS_ASSUME_NONNULL_END
