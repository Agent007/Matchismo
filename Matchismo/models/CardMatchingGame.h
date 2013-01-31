#import "SUDeck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSString *lastFlipResultDescription;

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(SUDeck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (SUCard *)cardAtIndex:(NSUInteger)index;

@end
