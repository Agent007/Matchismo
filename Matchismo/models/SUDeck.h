#import "SUCard.h"

/**
 *
 * Deck of cards.
 *
 */
@interface SUDeck : NSObject

- (void)addCard:(SUCard *)card atTop:(BOOL)atTop;

- (SUCard *)drawRandomCard;

@end
