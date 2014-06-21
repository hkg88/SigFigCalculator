//
//  SigFigCalculatorTests.m
//  SigFigCalculatorTests
//
//  Created by Kyle Gearhart on 12/12/21.
//  Copyright (c) 2012 Kyle Gearhart. All rights reserved.
//

#import "SigFigCalculatorTests.h"

enum{
    ADD = 1,
    SUBTRACT = 2,
    MULTIPLY = 3,
    DIVIDE = 4,
};

@implementation SigFigCalculatorTests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

//-----------------------
// SigFigCalculator Tests
//-----------------------

#pragma mark -- Addition Tests

// **********ADDITION***********

// Tests a basic addition problem with the result having to be rounded up
- (void)testCalculatorBasicAddWithRound
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"1.1"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3.25"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"4.4"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);

}

// Tests an addition problem with leading zeros and negated floats
- (void)testCalculatorAdditionLeadingZeroNegatedFloats
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"-0111.1134"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-0001.0000"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-112.1134"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
    
}

// Tests an addition problem with leading zeros and negated floats
- (void)testCalculatorAdditionLargeFloats
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"-123.123456789123456789123456789123456789"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-0001.000000000000000000000000000000000000"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-124.123456789123456789123456789123456789"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
    
}


// Tests a basic addition problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicAddWithNegativeAndRound
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"-1.1"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3.25"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"2.2"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic addition problem with two ints
- (void)testCalculatorBasicAddOfInts
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"2"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"125"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic addition problem with zero being one of the operands
- (void)testCalculatorBasicAddWithZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"123123.123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"123123"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests an addition with the use of floats with leading zeroes
- (void)testCalculatorBasicAddFloatsWithLeadingZeroes
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.0123"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"0.000900"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"0.0132"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests an addition with the use of a positive and negative float with leading zeroes
- (void)testCalculatorBasicAddFloatsWithLeadingZeroesPosNeg
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.0123"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-0.0011"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"0.0112"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests an addition with the use two negative floats
- (void)testCalculatorBasicAddFloatsWithLeadingZeroesTwoNegatives
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"-0.0123"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-0.0011"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:ADD];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-0.0134"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

#pragma mark -- Subtraction Tests

// **********SUBTRACTION***********

// Tests a basic subtraction problem with the result having to be rounded up
- (void)testCalculatorBasicSubtractWithRound
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"1.1"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3.25"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:SUBTRACT];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-2.2"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
    
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicSubtractWithNegativeAndRound
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"-1.1"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3.25"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:SUBTRACT];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-4.4"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicSubtractOfInts
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"2"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:SUBTRACT];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-121"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicSubtractWithZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"123123.123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:SUBTRACT];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-123123"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicSubtractWithLeadingZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"01.000"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"123123.123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:SUBTRACT];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"-123122.123"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicSubtractFloatWithLeadingZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.0012"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"0.0001"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:SUBTRACT];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"0.0011"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicSubtractFloatWithLeadingZeroNegative
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.0012"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-0.0001"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:SUBTRACT];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"0.0013"];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// **********MULTIPLICATION***********

#pragma mark -- Multiplication Tests

// Tests a basic multiplication with zero as an operand
- (void)testCalculatorBasicMultiplicationWithZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"123123.123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"0"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
  //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicMultiplicationWithZeroNegativeFloat
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-123123.123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"0"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicMultiplicationWithZeroFloatNegativeFloat
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.00"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-123123.123"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"000"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,3)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicMultiplicationTwoInts
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"22"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"70"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicMultiplicationOneIntOneFloat
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"2.2"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"7"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicMultiplicationTwoFloats
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"2.2"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3.0"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"6.6"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,3)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicMultiplicationTwoFloatsLeadingZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.0012"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"0.0001"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"0.0000001"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(result.length-1,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicMultiplicationTwoFloatsLeadingZeroNegative
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.012"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-0.01"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:MULTIPLY];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"-0.0001"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(result.length-1,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

#pragma mark -- Division Tests

// **********DIVISION***********

// Tests a basic division problem of two ints
- (void)testCalculatorDivisionTwoInts
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"6"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"3"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"2"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic division problem of two ints close in value
- (void)testCalculatorDivisionTwoCloseInts
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"39"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"35"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"1.1"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,3)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic division problem of two ints close in value
- (void)testCalculatorDivisionTwoCloserInts
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"36"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"35"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"1.0"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,3)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic division problem of two floats with the result having precision expressed in zeros
- (void)testCalculatorDivisionTwoCloserFloatsWithZeroPrecisions
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"3.75"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"1.25"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"3.00"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,4)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests division of zero by an int
- (void)testCalculatorDivisionZeroByAnInt
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"1213124"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"0"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a division of zero by a float
- (void)testCalculatorDivisionZeroByAFloat
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0000"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"123.4213"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"0000"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,4)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic division problem of two ints close in value
- (void)testCalculatorIntDivision
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"543215161234"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"5"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"100000000000"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic division problem of two ints close in value
- (void)testCalculatorDivisionByZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"543215161234"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"0"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    //NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"インフィニティ"];
    //NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    //STAssertEqualObjects(result, calculatedNumber, [NSString stringWithFormat:@"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result]);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicDivisionTwoFloatsLeadingZero
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.0012"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"0.0001"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"10"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

// Tests a basic subtraction problem with the result having to be rounded up and a negative number being an operand
- (void)testCalculatorBasicDivisionTwoFloatsLeadingZeroNegative
{
    SigFigCalculator *calc = [[SigFigCalculator alloc] init];
    Operand *firstOp = [[Operand alloc] initWithValue:@"0.0012"];
    Operand *secondOp = [[Operand alloc] initWithValue:@"-0.0001"];
    calc.firstOperand = firstOp;
    calc.secondOperand = secondOp;
    calc.currOperator = [NSNumber numberWithInt:DIVIDE];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"-10"];
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(1,1)];
    NSAttributedString *calculatedNumber = [calc calculateResult];
    //NSLog([NSString stringWithFormat:@"RESULT: %@\nEXPECTED: %@\n", [calculatedNumber description], [result description]]);
    XCTAssertEqualObjects(result, calculatedNumber, @"TEST FAILED : ACTUAL %@: EXPECTED : %@", calculatedNumber, result);
}

//--------------
// Operand Tests
//--------------

#pragma mark -- Operand Tests

// Tests that the Operand's default constructor initializes everything correctly
- (void)testOperandDefaultConstructor
{
    Operand *op = [[Operand alloc] init];
    XCTAssertEqualObjects(op.value, @"0", @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", op.value);
    XCTAssertEqual(op.precision, 0, @"TEST FAILED : ACTUAL : %d  EXPECTED : 0", op.precision);
    XCTAssertEqual(op.numSigFigs, 0, @"TEST FAILED : ACTUAL : %d  EXPECTED : 0", op.numSigFigs);
    XCTAssertEqual(op.containsDecimal, NO, @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", (op.containsDecimal) ? @"YES" : @"NO");
    XCTAssertEqual(op.isNegative, NO, @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", (op.isNegative) ? @"YES" : @"NO");
}

// Tests that the Operand's convenience constructor initializes everything correctly
- (void)testOperandConvenienceConstructor
{
    Operand *op = [[Operand alloc] initWithValue:@"912.321"];
    XCTAssertEqualObjects(op.value, @"912.321", @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", op.value);
    XCTAssertEqual(op.precision, 3, @"TEST FAILED : ACTUAL : %d  EXPECTED : 0", op.precision);
    XCTAssertEqual(op.numSigFigs, 6, @"TEST FAILED : ACTUAL : %d  EXPECTED : 0", op.numSigFigs);
    XCTAssertEqual(op.containsDecimal, YES, @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", (op.containsDecimal) ? @"YES" : @"NO");
    XCTAssertEqual(op.isNegative, NO, @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", (op.isNegative) ? @"YES" : @"NO");
}

// Tests that the Operand's convenience constructor initializes everything correctly if the number is negative
- (void)testOperandConvenienceConstructorNegativeNumber
{
    Operand *op = [[Operand alloc] initWithValue:@"-912.321"];
    XCTAssertEqualObjects(op.value, @"912.321", @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", op.value);
    XCTAssertEqual(op.precision, 3, @"TEST FAILED : ACTUAL : %d  EXPECTED : 0", op.precision);
    XCTAssertEqual(op.numSigFigs, 6, @"TEST FAILED : ACTUAL : %d  EXPECTED : 0", op.numSigFigs);
    XCTAssertEqual(op.containsDecimal, YES, @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", (op.containsDecimal) ? @"YES" : @"NO");
    XCTAssertEqual(op.isNegative, YES, @"TEST FAILED : ACTUAL : %@  EXPECTED : 0", (op.isNegative) ? @"YES" : @"NO");
}

#pragma mark -- Counter Tests

//--------------------
// SigFigCounter Tests
//--------------------

// Tests if the counter correctly counts multiple zeroed negated float
- (void)testCounterLeadingZeroBeforeDecimalNegatedFLoat
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 4;
    int actual = [counter countSigFigs:@"-00000.1104"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts multiple zeroed negated int
- (void)testCounterLeadingZerosBeforeFloat
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 7;
    int actual = [counter countSigFigs:@"-0000123.1104"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts multiple zeroed negated int
- (void)testCounterZeroNegatedInt
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 4;
    int actual = [counter countSigFigs:@"-0000"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts multiple zeroed int
- (void)testCounterZeroInt
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 4;
    int actual = [counter countSigFigs:@"0000"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts multiple zeroed negated int
- (void)testCounterZeroNegatedFloat
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 4;
    int actual = [counter countSigFigs:@"-00.00"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts a single zero
- (void)testCounterZero
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 1;
    int actual = [counter countSigFigs:@"0"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts multiple zeros
- (void)testCounterMultipleZeroes
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 8;
    int actual = [counter countSigFigs:@"0000.0000"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts zeros after the decimal
- (void)testCounterZerosAfterDecimal
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 6;
    int actual = [counter countSigFigs:@"123.000"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly counts zeros in the number
- (void)testCounterZerosInNumber
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 6;
    int actual = [counter countSigFigs:@"120001"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter correctly ignores zeros located before the number
- (void)testCounterZerosBeforeNumber
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 4;
    int actual = [counter countSigFigs:@"0001234"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter can handle a negative int
- (void)testCounterNegativeInt
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 4;
    int actual = [counter countSigFigs:@"-001234"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

// Tests if the counter can handle a negative float
- (void)testCounterNegativeFloat
{
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    int result = 5;
    int actual = [counter countSigFigs:@"-234.23"];
    XCTAssertEqual(actual, result, @"TEST FAILED : ACTUAL : %d  EXPECTED : %d", actual, result);
}

#pragma mark -- Converter Tests

//----------------------
// SigFigConverter Tests
//----------------------

// Tests if the converter correctly converts a negative 0 int value
- (void)testConverterNegativeZeroInt
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"0";
    NSString *actual = [[converter convertNumSigFigs:@"-000000" to:@"1"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly converts a negative 0 float value
- (void)testConverterNegativeZeroFloat
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"0";
    NSString *actual = [[converter convertNumSigFigs:@"-000.000" to:@"1"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly converts a few 0s into less
- (void)testConverterZeroIntLess
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"00";
    NSString *actual = [[converter convertNumSigFigs:@"000000" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly converts a few 0s into more
- (void)testConverterZeroIntMore
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"00000";
    NSString *actual = [[converter convertNumSigFigs:@"00" to:@"5"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly converts a negated string of zeros
- (void)testConverterNegatedZeroString
{
  SigFigConverter *converter = [[SigFigConverter alloc] init];
  NSString *result = @"00000";
  NSString *actual = [[converter convertNumSigFigs:@"-00" to:@"5"] string];
  XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly converts to 0 SigFigs
- (void)testConverterZeroSigFigs
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"0";
    NSString *actual = [[converter convertNumSigFigs:@"12321" to:@"0"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a float down
- (void)testConverterRoundDownFloat
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"1.0";
    NSString *actual = [[converter convertNumSigFigs:@"1.02857" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a float down
- (void)testConverterRoundDownFloatMoreZeros
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"1.0";
    NSString *actual = [[converter convertNumSigFigs:@"1.00002857" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a float down
- (void)testConverterRoundDownFloatMoreZerosOneNonzero
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"1.20";
    NSString *actual = [[converter convertNumSigFigs:@"1.20000123" to:@"3"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a float down
- (void)testConverterRoundDownFloattoInt
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"1";
    NSString *actual = [[converter convertNumSigFigs:@"1.000123" to:@"1"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a float up
- (void)testConverterRoundUpFloat
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"1.3";
    NSString *actual = [[converter convertNumSigFigs:@"1.25" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a float up and changes it to an int
- (void)testConverterRoundUpFloatToInt
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"2";
    NSString *actual = [[converter convertNumSigFigs:@"1.5" to:@"1"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds an int up
- (void)testConverterRoundUpInt
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"2800";
    NSString *actual = [[converter convertNumSigFigs:@"2794" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds an int up and adds an extra zero
- (void)testConverterRoundUpIntAndAddZero
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"10000";
    NSString *actual = [[converter convertNumSigFigs:@"9999" to:@"1"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds with a negative int as the number
- (void)testConverterRoundNegativeInt
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"-10000";
    NSString *actual = [[converter convertNumSigFigs:@"-9999" to:@"1"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a negative float
- (void)testConverterRoundNegativeFloat
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"-130";
    NSString *actual = [[converter convertNumSigFigs:@"-127.123" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a float beginning with zeroes
- (void)testConverterRoundFloatWithLeadingZeroes
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"0.013";
    NSString *actual = [[converter convertNumSigFigs:@"0.0125" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a negative float beginning with zeroes
- (void)testConverterRoundNegativeFloatWithLeadingZeroes
{
    SigFigConverter *converter = [[SigFigConverter alloc] init];
    NSString *result = @"-0.013";
    NSString *actual = [[converter convertNumSigFigs:@"-0.0125" to:@"2"] string];
    XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}

// Tests if the converter correctly rounds a negative integer
- (void)testConverterRoundNegativeInteger
{
  SigFigConverter *converter = [[SigFigConverter alloc] init];
  NSString *result = @"-12500";
  NSString *actual = [[converter convertNumSigFigs:@"-12485" to:@"3"] string];
  XCTAssertEqualObjects(actual, result, @"TEST FAILED : ACTUAL : %@  EXPECTED : %@", actual, result);
}
@end
