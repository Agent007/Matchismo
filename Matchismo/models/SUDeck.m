#import "SUDeck.h"

@interface SUDeck ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation SUDeck

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [NSMutableArray array];
    }
    return _cards;
}

- (void)addCard:(SUCard *)card atTop:(BOOL)atTop {
    /* the lecture video has the below logic, but you may prefer to think of the deck as a stack and treat index 0 as the bottom instead */
    atTop ? [self.cards insertObject:card atIndex:0] : [self.cards addObject:card];
}

- (SUCard *)drawRandomCard {
    NSUInteger randomIndex = arc4random() % self.cards.count;
    SUCard *randomCard = self.cards[randomIndex];
    [self.cards removeObjectAtIndex:randomIndex];
    return randomCard;
}

@end
