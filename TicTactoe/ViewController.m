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
@property NSInteger playerNumber;
@property NSMutableArray *myArray;
@property NSInteger numberOfX;
@property NSMutableArray *totalPointsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfX = 0;
    self.labelOne.text = @"";
    self.myArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    self.totalPointsArray = [[NSMutableArray alloc] initWithCapacity:9];
    
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.view];
    NSLog(@"X location: %f", point.x);
    NSLog(@"Y Location: %f",point.y);
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
    ///////////
    //NSLog(@"%@\n",self.totalPointsArray);

    
    NSMutableArray *labelsArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    
    for (int i = 0; i < labelsArray.count; i++) {
        UILabel *label = labelsArray[i];
        NSString *labelFrameString = NSStringFromCGRect(label.frame);
        CGRect labelFrameRect = CGRectFromString(labelFrameString);
        //NSLog(@"%@",labelFrameString);
        
        if (CGRectContainsPoint(labelFrameRect, point)) {
            UILabel *labelMark = labelsArray[i];
        
        if (self.playerNumber % 2 == 0) {
            labelMark.backgroundColor = [UIColor redColor];
            labelMark.text = @"O";
            self.playerNumber++;
            NSLog(@"Player One");
        } else {
            labelMark.backgroundColor = [UIColor blueColor];
            labelMark.text = @"X";
            NSLog(@"Player Two");
            self.playerNumber++;
        }
            
            
        }
    }
    
    [self determineWinner];
    
}


- (IBAction)newGame:(id)sender {
    self.playerNumber = 0;
    
    NSMutableArray *labelsArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    
    //Turns all squares to green colors
    for (int i = 0; i < labelsArray.count; i++) {
        UILabel *labelMark = labelsArray[i];
        labelMark.backgroundColor = [UIColor greenColor];
        labelMark.text = @"";
        self.playerNumber++;
    }
    [self determineWinner];
    
    for (int i = 0; i < self.myArray.count; i++){
        [self.totalPointsArray insertObject:@"" atIndex:i];
    }
    NSLog(@"%@",self.totalPointsArray);
    NSLog(@"New Game Created");

}

- (void)determineWinner {
    
    NSString *point;
    //for (UILabel *label in self.myArray)
    NSMutableArray *pointsArray = [[NSMutableArray alloc] initWithCapacity:9];
    for (int i = 0; i < self.myArray.count; i++){
        UILabel *labelMark = self.myArray[i];
        if ([labelMark.text isEqualToString: @"X"]){
                point = @"1";
                [pointsArray insertObject:point atIndex:i];
                self.numberOfX--;
            } else if ([labelMark.text isEqualToString:@"O"]){
                point = @"-1";
                [pointsArray insertObject:point atIndex:i];
            } else {
                point = @"0";
                [pointsArray insertObject:point atIndex:i];
            }
    }
    self.totalPointsArray = pointsArray;
    NSLog(@"%@\n",self.totalPointsArray);
}



- (void) findLabelUsingPoint:(CGPoint) point {
    
}

@end
