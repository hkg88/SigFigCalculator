#import "SFRulesViewController.h"
#import "SFBannerViewController.h"

@interface SFRulesViewController()

@property (strong, nonatomic) IBOutlet UITextView *rulesTextView;

@end

@implementation SFRulesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rulesTextView.alwaysBounceVertical = YES;
    
    // Define the UIText view's contents
    self.rulesTextView.text = NSLocalizedString(@"Significant Figures Rules\n\nRules for Counting Significant Figures\n\n1. Zeros appearing between nonzero digits are significant\n\n2. Zeros appearing in front of nonzero digits are not significant\n\n3. Zeros at the end of a number and to the right of a decimal are significant\n\n4. Zeros at the end of a number but to the left of a decimal are either significant because they have been measured, or insignificant in the case that they are just placeholders\n\n5. All digits in a number written in Scientific Notation are significant\n\nRules for Calculating Using Significant Figures\n\nAddition and Subtraction\n\n1. The result should have the same number of digits after the decimal as the least accurate operand\n\nEx. 12.52 + 23.2 = 35.7\n\nMultiplication and Division\n\n1. The resulting product or quotient must have the same number of significant figures as the operand with the least number of significant figures\n\nEx. 12 x 1.55 = 19", @"SigFig Rules Explanation");
    
    [self styleRulesStringText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(styleRulesStringText) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.rulesTextView.contentOffset = CGPointMake(0.0f, 0.0f);
}

- (void)styleRulesStringText
{
    NSString *rulesString = self.rulesTextView.text;
    NSMutableAttributedString *rulesAttributedString = [[NSMutableAttributedString alloc] initWithString:rulesString];
    
    UIFont *biggestTitleFont;
    UIFont *biggerTitleFont;
    UIFont *titleFont;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        biggestTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        biggerTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    } else {
        biggestTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        biggerTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
        titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    }
    
    [rulesAttributedString addAttribute:NSFontAttributeName
                                  value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                                  range:[rulesString rangeOfString:rulesString]];
    
    [rulesAttributedString addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor whiteColor]
                                  range:[rulesString rangeOfString:rulesString]];
    
    [rulesAttributedString addAttribute:NSFontAttributeName
                                  value:biggestTitleFont
                                  range:[rulesString rangeOfString:NSLocalizedString(@"Significant Figures Rules", @"")]];
    
    [rulesAttributedString addAttribute:NSFontAttributeName
                                  value:biggerTitleFont
                                  range:[rulesString rangeOfString:NSLocalizedString(@"Rules for Counting Significant Figures", @"")]];
    [rulesAttributedString addAttribute:NSFontAttributeName
                                  value:biggerTitleFont
                                  range:[rulesString rangeOfString:NSLocalizedString(@"Rules for Calculating Using Significant Figures", @"")]];
    
    [rulesAttributedString addAttribute:NSFontAttributeName
                                  value:titleFont
                                  range:[rulesString rangeOfString:NSLocalizedString(@"Addition and Subtraction", @"")]];
    [rulesAttributedString addAttribute:NSFontAttributeName
                                  value:titleFont
                                  range:[rulesString rangeOfString:NSLocalizedString(@"Multiplication and Division", @"")]];
    

    [self.rulesTextView setAttributedText:rulesAttributedString];
    
}

@end
