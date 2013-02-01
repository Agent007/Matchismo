#import "SUPlayingCard.h"

static const NSInteger MATCH_SUIT_POINTS = 1, MATCH_RANK_POINTS = 4;

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

#pragma mark - overridden method(s)

- (NSInteger)match:(NSArray *)otherCards {
    NSInteger score = 0;
    BOOL noMismatchedSuit = YES;
    BOOL noMismatchedRank = YES;
    for (SUPlayingCard *otherCard in otherCards) {
        noMismatchedSuit &= [otherCard.suit isEqualToString:self.suit];
        noMismatchedRank &= (otherCard.rank == self.rank);
    }
    if (noMismatchedRank) {
        score = MATCH_RANK_POINTS;
    } else if (noMismatchedSuit) {
        score = MATCH_SUIT_POINTS;
    }
    return score;
}

@end
