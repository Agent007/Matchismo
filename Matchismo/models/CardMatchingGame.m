#import "CardMatchingGame.h"

static const NSInteger MATCH_BONUS = 4, MISMATCH_PENALTY = 2, FLIP_COST = 1;

@interface CardMatchingGame ()

@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSMutableArray *cards;

/* Since the match score is calculated in each call to flipCardAtIndex, it is 
 most convenient to provide a property for the description of the last flip that 
 view controllers can use to display. The code to generate this string belongs 
 in the model anyway since it is related to the state of the underlying data.
 */
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
            NSMutableArray *otherCards = [NSMutableArray array];
            for (SUCard *otherCard in self.cards) {
                if ((otherCards.count < self.numberOfCardsToMatch) && otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                }
            }
            if (otherCards.count == (self.numberOfCardsToMatch - 1)) {
                NSInteger matchScore = [card match:otherCards];
                NSString *otherCardsString = [otherCards componentsJoinedByString:@" & "];
                if (matchScore) {
                    for (SUCard *otherCard in otherCards) {
                        otherCard.isUnplayable = YES;
                    }
                    card.isUnplayable = YES;
                    NSInteger points = matchScore * MATCH_BONUS * self.numberOfCardsToMatch;
                    self.score += points;
                    self.lastFlipResultDescription = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card, otherCardsString, points];
                } else { // no match
                    // hide previously shown card(s)
                    for (SUCard *otherCard in otherCards) {
                        otherCard.isFaceUp = NO;
                    }
                    NSInteger penalty = MISMATCH_PENALTY * self.numberOfCardsToMatch;
                    self.score -= penalty;
                    self.lastFlipResultDescription = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!", card, otherCardsString, penalty];
                }
            }
            self.score -= FLIP_COST;
        }
        card.isFaceUp = !card.isFaceUp;
    }
}

@end
