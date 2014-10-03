//
//  ViewController.m
//  TicTacToe
//
//  Created by Bradley Walker on 10/2/14.
//  Copyright (c) 2014 BlackSummerVentures. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
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
@property NSMutableArray *totalPointsArray;
@property NSString *winner;
@property UIAlertView *alertOne;
@property UIAlertView *alertTwo;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    self.alertOne = [[UIAlertView alloc] initWithTitle:@"You Won!!" message:@"X is the Winner!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [self.alertOne addButtonWithTitle:@"New Game"];
    self.alertTwo = [[UIAlertView alloc] initWithTitle:@"You Won!!" message:@"O is the Winner!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [self.alertTwo addButtonWithTitle:@"New Game"];
    self.totalPointsArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    for (int i = 0; i < self.myArray.count; i++) {
        UILabel *labelMark = self.myArray[i];
        labelMark.text = @"";
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self newGame:self];
    }
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
    [self findWinner];
    
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

-(void) findWinner {
    NSString *squareOne = self.totalPointsArray[0];
    NSString *squareTwo = self.totalPointsArray[1];
    NSString *squareThree = self.totalPointsArray[2];
    NSString *squareFour = self.totalPointsArray[3];
    NSString *squareFive = self.totalPointsArray[4];
    NSString *squareSix = self.totalPointsArray[5];
    NSString *squareSeven = self.totalPointsArray[6];
    NSString *squareEight = self.totalPointsArray[7];
    NSString *squareNine = self.totalPointsArray[8];
    
    NSInteger rowOne = squareOne.integerValue + squareTwo.integerValue + squareThree.integerValue;
    NSInteger rowTwo = squareFour.integerValue + squareFive.integerValue + squareSix.integerValue;
    NSInteger rowThree = squareSeven.integerValue + squareEight.integerValue + squareNine.integerValue;
    
    NSInteger columnOne = squareOne.integerValue + squareFour.integerValue + squareSeven.integerValue;
    NSInteger columnTwo = squareTwo.integerValue + squareFive.integerValue + squareEight.integerValue;
    NSInteger columnThree = squareThree.integerValue + squareSix.integerValue + squareNine.integerValue;
    
    NSInteger diaganolOne = squareOne.integerValue + squareFive.integerValue + squareNine.integerValue;
    NSInteger diagonalTwo = squareThree.integerValue + squareFive.integerValue + squareSeven.integerValue;
    
    if (rowOne == -3) {
        self.winner = @"O";
        [self.alertTwo show];
            NSLog(@"Hello");
        }else if (rowOne == 3){
            self.winner = @"X";
            [self.alertOne show];
    }
    
    if (rowTwo == -3) {
        self.winner = @"O";
        [self.alertTwo show];
        NSLog(@"Hello");
    }else if (rowTwo == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    
    if (rowThree == -3) {
        self.winner = @"O";
        [self.alertTwo show];
        NSLog(@"Hello");
    }else if (rowThree == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    
    
    if (columnOne == -3) {
        self.winner = @"O";
        [self.alertTwo show];
        NSLog(@"Hello");
    }else if (columnOne== 3) {
        self.winner = @"X";
        [self.alertOne show];
    }
    if (columnTwo == -3) {
        self.winner = @"O";
        [self.alertTwo show];
        NSLog(@"Hello");
    }
    else if (columnTwo == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    
    
    if (columnThree == -3) {
        self.winner = @"O";
        [self.alertTwo show];
        NSLog(@"Hello");
    }
    else if (columnThree == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    if (diaganolOne == -3) {
        self.winner = @"O";
        [self.alertTwo show];
        NSLog(@"Hello");
    }
    else if (diaganolOne ==3){
        self.winner = @"X";
        [self.alertOne show];
        
    }
    if (diagonalTwo == -3) {
        self.winner = @"O";
        [self.alertTwo show];
        NSLog(@"Hello");
    }
    else if (diagonalTwo == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    
    NSLog(@"Row One: %ld", (long)rowOne);
    
    
}



- (void) findLabelUsingPoint:(CGPoint) point {
    
}

@end
