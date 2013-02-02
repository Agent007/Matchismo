#import "SUDeck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSString *lastFlipResultDescription;
@property (nonatomic) NSUInteger numberOfCardsToMatch;

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(SUDeck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (SUCard *)cardAtIndex:(NSUInteger)index;

/**
 *
 * Reset score, last flip description & card states, but re-use card deck.
 *
 */
- (void)clearHistory;

@end
