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
@property (strong, nonatomic) NSMutableArray *history;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

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
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[SUPlayingDeck alloc] init]];
        _game.numberOfCardsToMatch = [self selectedNumberOfCardsToMatch];
    }
    return _game;
}

- (NSMutableArray *)history {
    if (!_history) {
        _history = NSMutableArray.array;
    }
    return _history;
}

#pragma mark - actions

- (void)flipCardWithoutAddingToHistory:(NSUInteger)cardButtonIndex {
    [self.game flipCardAtIndex:cardButtonIndex];
    self.flipsCount++;
}

- (IBAction)flipCard:(UIButton *)sender {
    self.gameSelectionControl.enabled = NO; // disable game selector when starting
    self.historySlider.enabled = YES; // re-enable in case flip happens after sliding through game history
    self.historySlider.value = 1.0; // jump to the 'present' on each new flip
    self.lastFlipResultLabel.alpha = 1.0; // re-enable label
    
    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.history addObject:[NSNumber numberWithInteger:cardButtonIndex]];
    [self resetAndReplayHistoryUpToButExcludingIndex:self.history.count];
}

- (IBAction)restartGame {
    self.gameSelectionControl.enabled = YES;
    self.historySlider.value = 0.0;
    self.historySlider.enabled = NO;
    self.flipsCount = 0;
    [self.history removeAllObjects];
    self.game = nil;
    [self updateUI];
}

- (IBAction)selectGame:(UISegmentedControl *)sender {
    self.game.numberOfCardsToMatch = [self selectedNumberOfCardsToMatch];
}

- (void)resetAndReplayHistoryUpToButExcludingIndex:(NSUInteger)index {
    self.flipsCount = 0;
    [self.game clearHistory];
    for (NSUInteger i = 0; i < index; i++) {
        NSNumber *cardIndexNumber = self.history[i];
        [self flipCardWithoutAddingToHistory:cardIndexNumber.integerValue];
    }
    [self updateUI];
}

- (IBAction)traverseHistory:(UISlider *)sender {
    self.lastFlipResultLabel.alpha = 0.5; // indicate that this is a past result
    
    NSUInteger currentIndex = llroundf(sender.value * self.history.count);
    
    // reset and then replay history up to current slider point
    [self resetAndReplayHistoryUpToButExcludingIndex:currentIndex];
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
        
        // show or hide card button 'face-down' image (a.k.a. card back image)
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        UIImage *cardImage = (cardButton.selected) ? nil : [UIImage imageNamed:@"cardBack.jpg"];
        [cardButton setImage:cardImage forState:UIControlStateNormal];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
