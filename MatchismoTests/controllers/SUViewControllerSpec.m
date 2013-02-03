#import "SUViewController.h"
#import "Kiwi.h"

@interface SUViewController (Testing)

@property (nonatomic) NSUInteger flipsCount;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelectionControl;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

- (IBAction)flipCard:(UIButton *)sender;
- (IBAction)restartGame;
- (IBAction)traverseHistory:(UISlider *)sender;

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
        __block UISegmentedControl *gameSelectorDummy;
        __block UISlider *historySliderDummy;
        beforeAll(^{
            controller = [[SUViewController alloc] init];
            controller.flipsCount = 1;
            gameSelectorDummy = [[UISegmentedControl alloc] init];
            controller.gameSelectionControl = gameSelectorDummy;
            historySliderDummy = [[UISlider alloc] init];
            controller.historySlider = historySliderDummy;
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
    describe(@"traverseHistory:", ^{
        it(@"should restore the alpha of the last flip result label to 1.0 when the slider is at the most recent flip (i.e., even if the slider's value isn't 1.0)", ^{
            controller = [[SUViewController alloc] init];
            UILabel *dummyLabel = [[UILabel alloc] init];
            controller.lastFlipResultLabel = dummyLabel;
            
            NSMutableArray *mockHistory = [NSMutableArray nullMock];
            [controller stub:@selector(history) andReturn:mockHistory];
            [[mockHistory stubAndReturn:theValue(1)] count];
            
            UISlider *dummySlider = [[UISlider alloc] init];
            dummySlider.value = 0.5;
            [controller traverseHistory:dummySlider];
            
            [[theValue(controller.lastFlipResultLabel.alpha) should] equal:theValue(1.0)];
        });
    });
});
SPEC_END
