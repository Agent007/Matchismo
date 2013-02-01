#import "SUViewController.h"
#import "SUPlayingDeck.h"
#import "CardMatchingGame.h"

enum CardGame {
    TwoCardGame,
    ThreeCardGame
};

@interface SUViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSUInteger flipsCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelectionControl;

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
    self.gameSelectionControl.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipsCount++;
    [self updateUI];
}

- (IBAction)restartGame {
    self.gameSelectionControl.enabled = YES;
    self.flipsCount = 0;
    [self initializeNewGame];
    [self updateUI];
}

- (IBAction)selectGame:(UISegmentedControl *)sender {
    self.game.numberOfCardsToMatch = [self selectedNumberOfCardsToMatch];
}

- (void)initializeNewGame {
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[SUPlayingDeck alloc] init]];
    self.game.numberOfCardsToMatch = [self selectedNumberOfCardsToMatch];
}

- (NSUInteger)selectedNumberOfCardsToMatch {
    switch (self.gameSelectionControl.selectedSegmentIndex) {
        case TwoCardGame:
            return 2;
        case ThreeCardGame:
            return 3;
        default:
            return 2;
    }
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
        
        // show or hide card button 'face-down' image
        if (!cardButton.selected) {
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
            [cardButton setImage:[UIImage imageNamed:@"cardBack.jpg"]
                        forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
