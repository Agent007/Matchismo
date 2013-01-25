#import "SUViewController.h"
#import "SUPlayingDeck.h"

@interface SUViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSUInteger flipsCount;
@property (strong, nonatomic) SUDeck *deck;

@end

@implementation SUViewController

#pragma mark - properties

- (void)setFlipsCount:(NSUInteger)flipsCount {
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"%d", _flipsCount];
}

- (SUDeck *)deck {
    if (!_deck) {
        _deck = [[SUPlayingDeck alloc] init];
    }
    return _deck;
}

#pragma mark - actions

- (IBAction)flipCard:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:[self.deck drawRandomCard].contents forState:UIControlStateSelected];
    }
    self.flipsCount++;
}

@end
