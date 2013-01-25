@interface SUCard : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic) BOOL isFaceUp;
@property (nonatomic) BOOL isUnplayable;

- (NSInteger)match:(NSArray *)otherCards;

@end
