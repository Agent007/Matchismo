#import "SUCard.h"
#import "Kiwi.h"

SPEC_BEGIN(SUCardSpec)
describe(@"SUCard", ^{
    __block SUCard *card;
    beforeEach(^{
        card = [[SUCard alloc] init];
    });
    it(@"has a string property named 'contents'", ^{
        card.contents = @"test";
        [[card.contents should] equal:@"test"];
    });
    it(@"returns a score of 0 without crashing when trying to match a nil array of other cards", ^{
        [[theValue([card match:nil]) should] equal:theValue(0)];
    });
});
SPEC_END
