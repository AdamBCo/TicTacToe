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
@property NSInteger robotON;
@property NSInteger robotBrain;

@property NSMutableArray *myArray;
@property NSMutableArray *totalPointsArray;
@property NSString *winner;
@property (strong, nonatomic) IBOutlet UILabel *draggableLabel;
@property NSInteger *timerValue;
@property (weak, nonatomic) IBOutlet UILabel *gameTimerLabel;

@property NSTimer *titleTimer;
@property NSTimer *totalTimer;


@property NSInteger randomNumber;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self determineDragableLabelValue];
    
    self.robotON = 0;
    
    self.title = @"Tic Tac Toe";
    self.gameTimerLabel.text = @"10";
    
    //Create array of squares
    self.myArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    
    //An array of points for all the square labels on the board.
    NSArray *pointsArray = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    self.totalPointsArray = [[NSMutableArray alloc] initWithArray:pointsArray];
    
    //Clear all label text
    for (int i = 0; i < self.myArray.count; i++) {
        UILabel *labelMark = self.myArray[i];
        labelMark.text = @"";
    }
    
    [self wouldYouLikeToPlayAlertView];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.originalCenter = self.draggableLabel.center;
}

-(void)alertViewRobot{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Play the Computer" message:@"Would you like to play the computer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    alert.tag = 0;
    [alert show];
    
}

-(void)alertViewNoMoves
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Winner" message:@"It looks like no one one this game!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"New Game"];
    alert.tag = 1;
    [alert show];
}


-(void)alertViewXWinner
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won!!" message:@"X is the Winner!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"New Game"];
    alert.tag = 1;
    [alert show];
}

-(void)alertViewOWinner
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won!!" message:@"O is the Winner!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"New Game"];
    alert.tag = 1;
    [alert show];
}

-(void)wouldYouLikeToPlayAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tic Tac Toe" message:@"Would you like to play Tic Tac Toe?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    alert.tag = 1;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0)
    {
        if (buttonIndex == 1) {
            self.robotON = 1;
        } else if (buttonIndex == 2)
            self.robotON = 0;
    } else if (alertView.tag == 1){
        if (buttonIndex == 1) {
            [self setGameDefaults];
        }
    }
}





- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.view];
    [tapGesture setNumberOfTapsRequired:1];
    for (int i = 0; i < self.myArray.count; i++) {
        UILabel *label = self.myArray[i];
        CGRect labelFrameRect = CGRectFromString(NSStringFromCGRect(label.frame));
        if (CGRectContainsPoint(labelFrameRect, point)) {
            UILabel *labelMark = self.myArray[i];
            if ([labelMark.text  isEqualToString: @""]) {
                if (self.playerNumber % 2 == 0) {
                    labelMark.text = @"O";
                    self.playerNumber++;
                    self.gameTimerLabel.text = @"10";
                } else {
                    labelMark.text = @"X";
                    self.playerNumber++;
                }
            }
        }
    }
    if (self.robotON == 1) {
        [self letsPlayARobot];
    }
    [self whoWon];
    [self determineDragableLabelValue];
    
}


- (IBAction)newGame:(id)sender {
    [self setGameDefaults];
}



-(void)setGameDefaults {
    NSLog(@"New Game Created");
    self.playerNumber = 1;
    [self determineDragableLabelValue];
    //Turns all squares to green colors
    for (int i = 0; i < self.myArray.count; i++) {
        UILabel *labelMark = self.myArray[i];
        labelMark.text = @"";
    }
    for (int i = 0; i < self.myArray.count; i++){
        [self.totalPointsArray insertObject:@"" atIndex:i];
    }
    self.gameTimerLabel.text = @"10";
    [self.winner isEqualToString:@""];
    self.gameTimerLabel.text = @"10";
    [self.titleTimer invalidate];
    [self titleTimers];
    
}

- (void)whoWon{
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
    [self findWinner];
}

-(void)findWinnerTimer{
    float count_down = 0.1;
    self.totalTimer = [NSTimer scheduledTimerWithTimeInterval: count_down target: self
                                                        selector: @selector(findWinner) userInfo: nil repeats: YES];
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
    

    if (rowOne == -3 || rowTwo == -3 || rowThree == -3 || columnOne == -3 || columnTwo == -3 || columnThree == -3 || diaganolOne == -3 || diagonalTwo == -3 ) {
        self.winner = @"O";
        self.playerNumber = 1;
        [self alertViewOWinner];
        [self.titleTimer invalidate];
        NSLog(@"The winner is O");
    }else if (rowOne == 3 || rowTwo == 3 || rowThree == 3 || columnOne == 3 || columnTwo == 3 || columnThree == 3 || diaganolOne == 3 || diagonalTwo == 3 ){
        self.winner = @"X";
        self.playerNumber = 1;
        [self alertViewXWinner];
        [self.titleTimer invalidate];
        NSLog(@"The Winner is X");
    }
    
    if (![self.totalPointsArray containsObject:@""]) {
        if (self.playerNumber >= 10) {
            self.playerNumber = 1;
            NSLog(@" Player Number is : %ld", (long)self.playerNumber);
            [self.titleTimer invalidate];
            [self alertViewNoMoves];
        }
    }

    [self determineDragableLabelValue];
    
}


- (IBAction)draggableLabel:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint point = [panGesture locationInView:self.view];
    self.draggableLabel.center = point;

    for (int i = 0; i < self.myArray.count; i++) {
        
        UILabel *labelMarkTwo = self.myArray[i];
        CGRect labelFrameRect = CGRectFromString(NSStringFromCGRect(labelMarkTwo.frame));
        
        if ([labelMarkTwo.text  isEqualToString: @""]) {
            if (CGRectContainsPoint(labelFrameRect, point) && panGesture.state == UIGestureRecognizerStateEnded) {
                if (self.playerNumber % 2 == 0) {
                    labelMarkTwo.text = @"O";
                    self.playerNumber++;
                    self.gameTimerLabel.text = @"10";
                } else {
                    labelMarkTwo.text = @"X";
                    self.playerNumber++;
                    self.gameTimerLabel.text = @"10";
                }
            }
        }
    }
    if (self.robotON == 1) {
        [self letsPlayARobot];
    }
    [self whoWon];
    [self findWinner];
    
}


-(void) determineDragableLabelValue {
    if (self.playerNumber % 2 == 0) {
        self.draggableLabel.text = @"O";
    } else {
        self.draggableLabel.text = @"X";
    }
}


-(void)titleTimers{
    float count_down = 1.0;
    self.titleTimer = [NSTimer scheduledTimerWithTimeInterval: count_down target: self
                                                     selector: @selector(modifyTitle) userInfo: nil repeats: YES];
}
-(void)modifyTitle{
    if (self.gameTimerLabel.text.integerValue > 1) {
        NSInteger time = self.gameTimerLabel.text.integerValue;
        time--;
        self.gameTimerLabel.text = [NSString stringWithFormat:@"%ld",(long)time];
    } else {
        self.gameTimerLabel.text = @"10";
        self.playerNumber++;
        if (self.robotON == 1) {
            [self letsPlayARobot];
        }
    }
}
- (IBAction)robotOnButton:(id)sender {
    [self alertViewRobot];
}

-(void)letsPlayARobot{
    if (self.playerNumber == 2 || self.playerNumber == 4 || self.playerNumber == 6 || self.playerNumber == 8){
        [self smarterTry];
    } else if (self.playerNumber == 10){
    
    [self findWinner];
    self.randomNumber = arc4random()%9;
    UILabel *labelMark = self.myArray[self.randomNumber];
    if (self.playerNumber < 9) {
    if (self.robotON == 1 && self.playerNumber % 2 == 0) {
        int help = 0;
        while ( help == 0) {
            if ([labelMark.text isEqualToString: @""]) {
                labelMark.text = @"O";
                help = 1;
                NSLog(@"Done");
            }
            self.randomNumber = arc4random()%9;
            labelMark = self.myArray[self.randomNumber];
        }
        self.playerNumber++;
        self.gameTimerLabel.text = @"10";
        NSLog(@"Robot is playing");
        NSLog(@"PlayerNumber: %ld", (long)self.playerNumber);
        NSLog(@"RobotBrain: %ld", (long)self.robotBrain);
    }
    }

    }
}



-(void)smarterTry{

            UILabel *labelMarkOne = self.myArray[0];
            UILabel *labelMarkTwo = self.myArray[1];
            UILabel *labelMarkThree = self.myArray[2];
            UILabel *labelMarkFour = self.myArray[3];
            UILabel *labelMarkFive = self.myArray[4];
            UILabel *labelMarkSix = self.myArray[5];
            UILabel *labelMarkSeven = self.myArray[6];
            UILabel *labelMarkEight = self.myArray[7];
            UILabel *labelMarkNine = self.myArray[8];
        if ((self.playerNumber == 2)){
            if (([labelMarkFive.text isEqualToString:@""])){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if ([labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }
        }
    
        if ((self.playerNumber == 4 || self.playerNumber == 6 || self.playerNumber == 8)){
            if (([labelMarkTwo.text isEqualToString: @"O"] && [labelMarkFive.text isEqualToString:@"O"] && [labelMarkEight.text isEqualToString:@""])){

                labelMarkEight.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            } else if([labelMarkFour.text isEqualToString: @"O"] && [labelMarkFive.text isEqualToString:@"O"] && [labelMarkSix.text isEqualToString:@""]){
                labelMarkSix.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
                
            } else if([labelMarkSeven.text isEqualToString: @"X"] && [labelMarkNine.text isEqualToString:@"X"] && [labelMarkEight.text isEqualToString:@""]){
                labelMarkEight.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
                
            } else if([labelMarkThree.text isEqualToString: @"O"] && [labelMarkNine.text isEqualToString:@"O"] && [labelMarkSix.text isEqualToString:@""]){
                labelMarkSix.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
                
            }else if([labelMarkFour.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkTwo.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
                
            }else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkFour.text isEqualToString:@"X"] && [labelMarkOne.text isEqualToString:@""]){
                labelMarkOne.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkOne.text isEqualToString: @"X"] && [labelMarkFour.text isEqualToString:@"X"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"X"] && [labelMarkFour.text isEqualToString:@"X"] && [labelMarkOne.text isEqualToString:@""]){
                labelMarkOne.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkNine.text isEqualToString:@""]){
                labelMarkNine.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"X"] && [labelMarkTwo.text isEqualToString:@"X"] && [labelMarkOne.text isEqualToString:@""]){
                labelMarkOne.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkOne.text isEqualToString: @"X"] && [labelMarkTwo.text isEqualToString:@"X"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkOne.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkNine.text isEqualToString:@""]){
                labelMarkNine.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkOne.text isEqualToString:@""]){
                labelMarkOne.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            } else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            } else if([labelMarkOne.text isEqualToString: @"X"] && [labelMarkThree.text isEqualToString:@"X"] && [labelMarkTwo.text isEqualToString:@""]){
                labelMarkTwo.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            } else if([labelMarkOne.text isEqualToString: @"O"] && [labelMarkTwo.text isEqualToString:@"O"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFive.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"O"] && [labelMarkFour.text isEqualToString:@""]){
                labelMarkFour.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFive.text isEqualToString: @"O"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkTwo.text isEqualToString:@""]){
                labelMarkTwo.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"O"] && [labelMarkFive.text isEqualToString:@"O"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"O"] && [labelMarkFive.text isEqualToString:@"O"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"O"] && [labelMarkEight.text isEqualToString:@"O"] && [labelMarkNine.text isEqualToString:@""]){
                labelMarkNine.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkNine.text isEqualToString: @"O"] && [labelMarkEight.text isEqualToString:@"O"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkEight.text isEqualToString: @"O"] && [labelMarkTwo.text isEqualToString:@"O"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFour.text isEqualToString: @"O"] && [labelMarkSix.text isEqualToString:@"O"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkTwo.text isEqualToString: @"O"] && [labelMarkFive.text isEqualToString:@"O"] && [labelMarkEight.text isEqualToString:@""]){
                labelMarkEight.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkOne.text isEqualToString: @"O"] && [labelMarkFour.text isEqualToString:@"O"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkOne.text isEqualToString: @"O"] && [labelMarkThree.text isEqualToString:@"O"] && [labelMarkTwo.text isEqualToString:@""]){
                labelMarkTwo.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"O"] && [labelMarkOne.text isEqualToString:@"O"] && [labelMarkFour.text isEqualToString:@""]){
                labelMarkFour.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"O"] && [labelMarkSix.text isEqualToString:@"O"] && [labelMarkNine.text isEqualToString:@""]){
                labelMarkNine.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"O"] && [labelMarkNine.text isEqualToString:@"O"] && [labelMarkSix.text isEqualToString:@""]){
                labelMarkSix.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSix.text isEqualToString: @"O"] && [labelMarkNine.text isEqualToString:@"O"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            } else if (([labelMarkTwo.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkEight.text isEqualToString:@""])){
                labelMarkEight.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            } else if([labelMarkFour.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkSix.text isEqualToString:@""]){
                labelMarkSix.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFive.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkFour.text isEqualToString:@""]){
                labelMarkFour.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFive.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkTwo.text isEqualToString:@""]){
                labelMarkTwo.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkNine.text isEqualToString:@""]){
                labelMarkNine.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkEight.text isEqualToString: @"X"] && [labelMarkTwo.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFour.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkTwo.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkEight.text isEqualToString:@""]){
                labelMarkEight.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkOne.text isEqualToString: @"X"] && [labelMarkFour.text isEqualToString:@"X"] && [labelMarkSeven.text isEqualToString:@""]){
                labelMarkSeven.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSeven.text isEqualToString: @"X"] && [labelMarkOne.text isEqualToString:@"X"] && [labelMarkFour.text isEqualToString:@""]){
                labelMarkFour.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkNine.text isEqualToString:@""]){
                labelMarkNine.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"X"] && [labelMarkNine.text isEqualToString:@"X"] && [labelMarkSix.text isEqualToString:@""]){
                labelMarkSix.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkSix.text isEqualToString: @"X"] && [labelMarkNine.text isEqualToString:@"X"] && [labelMarkThree.text isEqualToString:@""]){
                labelMarkThree.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkOne.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkFive.text isEqualToString:@"X"] && [labelMarkOne.text isEqualToString:@""]){
                labelMarkOne.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFour.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkTwo.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkThree.text isEqualToString: @"X"] && [labelMarkTwo.text isEqualToString:@"X"] && [labelMarkOne.text isEqualToString:@"O"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkNine.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkSeven.text isEqualToString:@"O"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFour.text isEqualToString: @"X"] && [labelMarkTwo.text isEqualToString:@"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkTwo.text isEqualToString: @"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkFour.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkSix.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else if([labelMarkTwo.text isEqualToString: @"X"] && [labelMarkEight.text isEqualToString:@"X"] && [labelMarkFour.text isEqualToString:@"X"] && [labelMarkFive.text isEqualToString:@""]){
                labelMarkFive.text = @"O";
                self.gameTimerLabel.text = @"10";
                self.playerNumber++;
                NSLog(@"Done");
            }else{
                self.randomNumber = arc4random()%9;
                UILabel *labelMark = self.myArray[self.randomNumber];
                if (self.playerNumber < 9) {
                    if (self.robotON == 1 && self.playerNumber % 2 == 0) {
                        int help = 0;
                        while ( help == 0) {
                            if ([labelMark.text isEqualToString: @""]) {
                                labelMark.text = @"O";
                                help = 1;
                                NSLog(@"Done");
                            }
                            self.randomNumber = arc4random()%9;
                            labelMark = self.myArray[self.randomNumber];
                        }
                        self.playerNumber++;
                        self.gameTimerLabel.text = @"10";
                        NSLog(@"Robot is playing");
                        NSLog(@"PlayerNumber: %ld", (long)self.playerNumber);
                        NSLog(@"RobotBrain: %ld", (long)self.robotBrain);
                    }
                }
            }
        }
    [self whoWon];
    [self determineDragableLabelValue];
    
}
@end