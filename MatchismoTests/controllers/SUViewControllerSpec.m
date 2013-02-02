#import "SUViewController.h"
#import "Kiwi.h"

@interface SUViewController (Testing)

@property (nonatomic) NSUInteger flipsCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelectionControl;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

- (IBAction)flipCard:(UIButton *)sender;
- (IBAction)restartGame;

@end

SPEC_BEGIN(SUViewControllerSpec)
describe(@"SUViewController", ^{
    __block SUViewController *controller;
    describe(@"flipCard:", ^{
        it(@"resets & replays history to the latest flip in order for the history slider to correctly animate the game sequence", ^{
            controller = [[SUViewController alloc] init];
            [[controller should] receive:@selector(resetAndReplayHistoryUpToButExcludingIndex:)];
            [controller flipCard:any()];
        });
    });
    describe(@"restartGame", ^{
        __block UISegmentedControl *gameSelector;
        __block UISlider *historySlider;
        beforeAll(^{
            controller = [[SUViewController alloc] init];
            controller.flipsCount = 1;
            gameSelector = [[UISegmentedControl alloc] init];
            controller.gameSelectionControl = gameSelector;
            historySlider = [[UISlider alloc] init];
            controller.historySlider = historySlider;
            [controller restartGame];
        });
        it(@"sets flip count to 0", ^{
            [[theValue(controller.flipsCount) should] equal:theValue(0)];
        });
        it(@"re-enables game selection control", ^{
            [[theValue(controller.gameSelectionControl.enabled) should] beYes];
        });
        it(@"disables & resets history slider to 0", ^{
            [[theValue(controller.historySlider.enabled) should] beNo];
            [[theValue(controller.historySlider.value) should] equal:theValue(0.0)];
        });
    });
});
SPEC_END
