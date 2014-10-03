//
//  ViewController.m
//  TicTacToe
//
//  Created by Bradley Walker on 10/2/14.
//  Copyright (c) 2014 BlackSummerVentures. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelOne;
@property (strong, nonatomic) IBOutlet UILabel *labelTwo;
@property (strong, nonatomic) IBOutlet UILabel *labelThree;
@property (strong, nonatomic) IBOutlet UILabel *labelFour;
@property (strong, nonatomic) IBOutlet UILabel *labelFive;
@property (strong, nonatomic) IBOutlet UILabel *labelSix;
@property (strong, nonatomic) IBOutlet UILabel *labelSeven;
@property (strong, nonatomic) IBOutlet UILabel *labelEight;
@property (strong, nonatomic) IBOutlet UILabel *labelNine;
@property (strong, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property CGPoint originalCenter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.view];
    NSLog(@"X location: %f", point.x);
    NSLog(@"Y Location: %f",point.y);
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
    NSArray *labelsArray = [NSArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    
    for (int i = 0; i < labelsArray.count; i++) {
        UILabel *label = labelsArray[i];
        NSString *labelFrameString = NSStringFromCGRect(label.frame);
        CGRect labelFrameRect = CGRectFromString(labelFrameString);
        NSLog(@"%@",labelFrameString);
        
        if (CGRectContainsPoint(labelFrameRect, point)) {
            UILabel *labelMark = labelsArray[i];
            labelMark.backgroundColor = [UIColor redColor];
            labelMark.text = @"X";
        }
    }
    
}

- (void) findLabelUsingPoint:(CGPoint) point {
    
}

@end
