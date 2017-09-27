//
//  PKViewController.m
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import "PKViewController.h"

@interface PKViewController ()

@end

@implementation PKViewController {
    NSString *_resultString;
}

#pragma mark - Actions
- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"; // (http|https)://
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

-(IBAction)copyIT:(id)sender {
    
    if ([_resultString length] == 0 || ![_resultString length]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Empty result cannot be copied" delegate:nil cancelButtonTitle:@"Okay :(" otherButtonTitles:nil, nil] show];
    } else {
        [UIPasteboard generalPasteboard].URL = [NSURL URLWithString:_resultString];
    }
}

-(IBAction)shortIT:(id)sender {
    
    [self.textField resignFirstResponder];
    if ([[self.textField text] length] == 0 || [self.textField text] == nil) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Empty URL cannot shorten" delegate:nil cancelButtonTitle:@"Understood!" otherButtonTitles:nil, nil] show];
    } else {
        
        if (![self validateUrl:[self.textField text]]) {
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Invalid URL" delegate:nil cancelButtonTitle:@"Understood!" otherButtonTitles:nil, nil] show];
        } else {
            
            PKShortener *shortner = [[PKShortener alloc] init];
            [shortner setURL:self.textField.text];
            shortner.delegate = self;
        }
    }
}

#pragma mark - PKShortner Delegate
-(void)shortenerResult:(NSString *)result
{
    _resultString = result;
    self.textView.text = _resultString;
    NSLog(@"Result - %@", result);
}

#pragma mark - UIView Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
