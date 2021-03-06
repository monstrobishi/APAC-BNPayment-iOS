//
//  Settings.m
//  DoNow
//
//  Created by Oskar Henriksson on 11/05/2016.
//  Copyright © 2016 Bambora. All rights reserved.
//

#import "AppSettings.h"
#import <BNPayment/BNPayment.h>

@interface AppSettings ()
@property (nonatomic) NSInteger runMode;
@property (nonatomic) NSInteger numberOfCardsSaved;
@end

#define kRunModeUndefined 0
#define kRunModeDev 1
#define kRunModeUAT 2
#define kRunModeProd 3
#define kRunModeDefault kRunModeDev


#define kMaxCard (20)

static NSString *const DonationAmountKey = @"donationAmount";
static NSString *const ProfileNameKey = @"profileName";
static NSString *const FavoriteCardKey = @"FavoriteCard";
static NSString *const OfflineModeKey = @"OfflineMode";
static NSString *const TouchIDModeKey = @"TouchIDMode";
static NSString *const HPPModeKey = @"HPPMode";
static NSString *const velocityModeKey = @"velocityMode";
static NSString *const numberOfCardsSavedKey = @"numberOfCardsSaved";
static NSString *const payOnceModeKey = @"payOnceMode";
static NSString *const ScanVisualCuesHiddenKey = @"ScanVisualCuesHidden";
static NSString *const ScanCardHolderNameKey = @"ScanCardHolderName";


@implementation AppSettings {
   
}

+ (AppSettings *)sharedInstance {
    static AppSettings *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AppSettings alloc] init];
        _sharedInstance.runMode = kRunModeUndefined;
        _sharedInstance.numberOfCardsSaved = [_sharedInstance restoreNumberOfCardSaved];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSString *)username {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:ProfileNameKey];
    return userName ? userName : @"Mattias Johansson";
}

- (void)setUsername:(NSString *)string {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:string forKey:ProfileNameKey];
}

- (void)updateDonatedAmount:(NSInteger)amount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger donationAmount = [userDefaults integerForKey:DonationAmountKey];
    [userDefaults setInteger:donationAmount+amount forKey:DonationAmountKey];
}

- (NSInteger)donatedAmount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:DonationAmountKey];
}

- (NSInteger)selectedCardIndex {
    return 0;
}


    //
    
    - (void)setOfflineMode:(BOOL)offlineMode {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:offlineMode forKey:OfflineModeKey];
    }
    
- (BOOL)offlineMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:OfflineModeKey];
}

    
- (void)setTouchIDMode:(BOOL)touchIDMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:touchIDMode forKey:TouchIDModeKey];
}

- (BOOL)touchIDMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:TouchIDModeKey];
}

- (void)setHPPMode:(BOOL)hppMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:hppMode forKey:HPPModeKey];
    [userDefault synchronize];
}

- (BOOL)HPPMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:HPPModeKey];
}

- (void)setVelocityMode:(BOOL)velocityMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:velocityMode forKey:velocityModeKey];
    [userDefault synchronize];
}

- (BOOL)velocityMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:velocityModeKey];
}

- (void)persistNumberOfCardSaved:(NSInteger) cardNumber {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:cardNumber forKey:numberOfCardsSavedKey];
    [userDefault synchronize];
}

- (NSInteger) restoreNumberOfCardSaved {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger n = [userDefault integerForKey:numberOfCardsSavedKey];
    return n;
}

-(BOOL) maxSavedCardReached
{
    BOOL b1 = (self.numberOfCardsSaved >= ((NSInteger) kMaxCard));
    return b1;
}

-(void) incrementNumberOfSavedCard;
{
    self.numberOfCardsSaved = self.numberOfCardsSaved + 1;
    [self persistNumberOfCardSaved:self.numberOfCardsSaved];
}

-(void) decrementNumberOfSavedCard;
{
    self.numberOfCardsSaved = self.numberOfCardsSaved - 1;
    [self persistNumberOfCardSaved:self.numberOfCardsSaved];
}

- (void)setPayOnceMode:(BOOL)velocityMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:velocityMode forKey:payOnceModeKey];
    [userDefault synchronize];
}

- (BOOL)payOnceMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:payOnceModeKey];
}

- (BOOL)scanVisualCues {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return ![userDefault boolForKey:ScanVisualCuesHiddenKey];
}

- (void)setScanVisualCues:(BOOL)scanVisualCues {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:!scanVisualCues forKey:ScanVisualCuesHiddenKey];
    [userDefault synchronize];
}

- (BOOL)scanCardHolderName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:ScanCardHolderNameKey];
}

- (void)setScanCardHolderName:(BOOL)scanCardHolderName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:scanCardHolderName forKey:ScanCardHolderNameKey];
    [userDefault synchronize];
}

- (NSInteger) getRunMode {
    if (_runMode == kRunModeUndefined){
      _runMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"runMode"];
    }
    if (_runMode == kRunModeUndefined){
        _runMode = kRunModeDefault;
    }
    return _runMode;
}

- (NSInteger) getRunModeByName:(NSString*) name {
    NSDictionary<NSString*, NSNumber*> *map = @{
                                                       @"Dev":@(kRunModeDev),
                                                       @"UAT":@(kRunModeUAT),
                                                       @"Prod":@(kRunModeProd)};
    if ([[map allKeys] containsObject:name]){
        return [NSNumber numberWithInt:[map objectForKey:name]];
    }
    return kRunModeUndefined;
}

- (NSString*) getRunModeNameByLevel:(NSNumber*) level {
    NSDictionary< NSNumber*, NSString*> *map = @{
                                                @(kRunModeDev): @"Dev",
                                                @(kRunModeUAT): @"UAT",
                                                @(kRunModeProd): @"Prod"};
    if ([[map allKeys] containsObject:level]){
        return [map objectForKey:level];
    }
    return @"?";
}



- (void) setRunMode:(NSInteger) newRunMode {
    if (newRunMode <= kRunModeProd && newRunMode >= kRunModeDev){
        [[NSUserDefaults standardUserDefaults] setInteger:newRunMode forKey:@"runMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _runMode = newRunMode;
    }
}


- (NSString *)getRunModeUrl {
    NSInteger i = [self getRunMode];
    NSNumber* runMode= [NSNumber numberWithInt:i];
    NSDictionary<NSNumber*,NSString*> *runModeUrls = @{
                                                       @(1):@"https://devsandbox.ippayments.com.au/rapi/",
                                                       @(2):@"https://uat.ippayments.com.au/rapi/",
                                                       @(3):@"https://www.ippayments.com.au/rapi/"};
    NSString* url = runModeUrls[runMode];
    return url;
}


- (NSString *)getTestUrl {
    return @"";
}

- (NSString *)getTestToken {
    return @"";
}

- (NSString *)getProdUrl {
    return @"";
}

- (NSString *)getProdToken {
    return @"";
}

- (BNAuthorizedCreditCard *)selectedCard {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger selectedIndex = [userDefault integerForKey:FavoriteCardKey];
    NSArray *cards = [[BNPaymentHandler sharedInstance] authorizedCards];
    
    if(selectedIndex < cards.count) {
        return cards[selectedIndex];
    }
    
    return nil;
}

    
- (BNPaymentParams *) createMockPaymentParameters{
    
    BNPaymentParams *mockObject = [BNPaymentParams new];
    mockObject.paymentIdentifier = [NSString stringWithFormat:@"%u", arc4random_uniform(INT_MAX)];
    mockObject.currency = @"AUD";
    NSDictionary * data = @{
                            @"Username": @"bn-secure.rest.api.dev",
                            @"Password": @"MobileIsGr8",
                            @"TokenisationAlgorithmId": @2,
                            @"CustomerStorageNumber": @"",
                            @"AccountNumber": @"2345678",
                            @"MerchantNumber": @"",
                            @"CustNumber": @"58748579",
                            @"TrnType": @1,
                            @"CustRef" : @"test-ud-002",
                            @"UserDefined": @{
                                    @"reference1": @"abc123"
                                    }
                            };
    
    
    mockObject.amount = @100;
    mockObject.token = @"58133813560350721";
    mockObject.comment = @"Mocked comment";
    [mockObject setPaymentJsonData: data];
    
    
    return mockObject;
}
@end
