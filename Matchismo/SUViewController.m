#import "SUViewController.h"
#import "SUPlayingDeck.h"
#import "CardMatchingGame.h"

@interface SUViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSUInteger flipsCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@end

@implementation SUViewController

#pragma mark - properties

- (void)setFlipsCount:(NSUInteger)flipsCount {
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", _flipsCount];
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (CardMatchingGame *)game {
    if (!_game) {
        [self initializeNewGame];
    }
    return _game;
}

#pragma mark - actions

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipsCount++;
//    self.lastFlipResultLabel.text = self.game.lastFlipResultDescription;
    [self updateUI];
}

- (IBAction)restartGame {
    self.flipsCount = 0;
    [self initializeNewGame];
    [self updateUI];
}

- (void)initializeNewGame {
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[SUPlayingDeck alloc] init]];
}

- (void)updateUI {
    self.lastFlipResultLabel.text = self.game.lastFlipResultDescription;
    for (UIButton *cardButton in self.cardButtons) {
        SUCard *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents
                    forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
