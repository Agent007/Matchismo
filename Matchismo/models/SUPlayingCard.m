#import "SUPlayingCard.h"

@implementation SUPlayingCard

#pragma mark - implementing properties defined in superclass

- (NSString *)contents {
    return [SUPlayingCard.rankStrings[self.rank] stringByAppendingString:self.suit];
}

#pragma mark - properties

@synthesize suit = _suit;

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit {
    if ([SUPlayingCard.validSuits containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= SUPlayingCard.maxRank) {
        _rank = rank;
    }
}

#pragma mark - class methods

+ (NSArray *)validSuits {
    return @[@"♠", @"♥", @"♣", @"♦"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return SUPlayingCard.rankStrings.count - 1;
}

@end
