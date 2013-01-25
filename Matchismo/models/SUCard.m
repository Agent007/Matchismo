#import "SUCard.h"

@implementation SUCard

- (NSInteger)match:(NSArray *)otherCards {
    NSInteger score = 0;
    for (SUCard *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
