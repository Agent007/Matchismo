#import "SUPlayingCard.h"
#import "Kiwi.h"

enum Suits {
    Spades,
    Hearts
};

SPEC_BEGIN(SUPlayingCardSpec)
describe(@"SUPlayingCard", ^{
    __block SUPlayingCard *card;
    beforeEach(^{
        card = [[SUPlayingCard alloc] init];
    });
    it(@"only matches cards that are all the same suit or all the same rank", ^{
        SUPlayingCard *fourOfSpades = [[SUPlayingCard alloc] init];
        fourOfSpades.suit = SUPlayingCard.validSuits[Spades];
        fourOfSpades.rank = 4;
        
        SUPlayingCard *threeOfHearts = [[SUPlayingCard alloc] init];
        threeOfHearts.suit = SUPlayingCard.validSuits[Hearts];
        threeOfHearts.rank = 3;
        
        SUPlayingCard *threeOfSpades = [[SUPlayingCard alloc] init];
        threeOfSpades.suit = SUPlayingCard.validSuits[Spades];
        threeOfSpades.rank = 3;
        
        NSUInteger matchScore = [fourOfSpades match:@[threeOfHearts, threeOfSpades]];
        [[theValue(matchScore) should] equal:theValue(0)];
    });
});
SPEC_END
