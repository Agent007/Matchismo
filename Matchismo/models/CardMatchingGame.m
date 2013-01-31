#import "CardMatchingGame.h"

static const NSInteger MATCH_BONUS = 4, MISMATCH_PENALTY = 2, FLIP_COST = 1;

@interface CardMatchingGame ()

@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSString *lastFlipResultDescription;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [NSMutableArray array];
    }
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(SUDeck *)deck {
    if (self = [super init]) {
        for (NSUInteger i = 0; i < cardCount; i++) {
            SUCard *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (SUCard *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    SUCard *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            self.lastFlipResultDescription = [NSString stringWithFormat:@"Flipped up %@", card];
            
            // check for other card(s) that may be a match
            for (SUCard *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    NSInteger matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.isUnplayable = YES;
                        card.isUnplayable = YES;
                        NSInteger points = matchScore * MATCH_BONUS;
                        self.score += points;
                        self.lastFlipResultDescription = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card, otherCard, points];
                    } else { // no match
                        otherCard.isFaceUp = NO; // hide previously shown card(s)
                        self.score -= MISMATCH_PENALTY;
                        self.lastFlipResultDescription = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!", card, otherCard, MISMATCH_PENALTY];
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        card.isFaceUp = !card.isFaceUp;
    }
}

@end
