#import "SUPlayingDeck.h"
#import "SUPlayingCard.h"

@implementation SUPlayingDeck

- (id)init {
    if (self = [super init]) {
        for (NSString *suit in SUPlayingCard.validSuits) {
            for (NSUInteger rank = 1; rank <= SUPlayingCard.maxRank; rank++) {
                SUPlayingCard *card = [[SUPlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card atTop:YES];
            }
        }
    }
    return self;
}

@end
