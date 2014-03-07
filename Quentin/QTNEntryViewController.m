//
// Created by Florian Bürger on 19/02/14.
// Copyright (c) 2014 keslcod. All rights reserved.
//

#import "QTNEntryViewController.h"
#import "QTNEntryView.h"
#import "NSURL+QTNParameters.h"
#import "QTNURLKeys.h"
#import <EventKit/EventKit.h>

@interface QTNEntryViewController ()
@property (nonatomic, strong) EKEventStore *eventStore;
@end

@implementation QTNEntryViewController

- (void)loadView
{
    [super loadView];
    QTNEntryView *view = [[QTNEntryView alloc] initWithFrame:self.view.bounds];
    view.autoresizingMask = self.view.autoresizingMask;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Quick Entry";

    [self askForEventStoreAccess];
}

- (void)askForEventStoreAccess
{
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                    completion:^(BOOL granted, NSError *error) {
    NSLog(@"Granted: %@", granted ? @"YES" : @"NO");
    QTNEntryView *view = (QTNEntryView *) self.view;
    if (!granted) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [view showError:NSLocalizedString(
        @"You have to grant access to your Reminders.\nPlease go to "
            "Settings > Privacy > Reminders and enable Quentin",
        nil)];
      });
    } else {
      [view showSuccess:@"Nice. Now you can create Reminders using the URL scheme"];
    }
                                    }];
}

- (void)processURL:(NSURL *)url
{
    NSDictionary *parameters = [url parameters];
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];

    NSString *names = parameters[QTNParameterName];
    NSArray *components = [names componentsSeparatedByString:@","];

    for (NSString *name in components) {
        if ([name length] > 0) {
            reminder.title = name;
            NSLog(@"Reminder.name=%@", name);
        }

        NSString *notes = parameters[QTNParameterNotes];
        if ([notes length] > 0) {
            reminder.notes = notes;
            NSLog(@"Reminder.notes=%@", notes);
        }

        NSString *list = parameters[QTNParameterList];
        EKCalendar *calendar = [self findCalendarMatchingName:list];
        reminder.calendar = calendar;
        NSLog(@"Reminder.calendar=%@", calendar);

        // TODO: Date, location, prio
    }

    NSString *xSource = parameters[XCallBackParameterSource];

    NSError *error = nil;
    if (![self.eventStore saveReminder:reminder
                                commit:YES
                                 error:&error]) {
        NSLog(@"ERROR while saving reminder %@:%@", reminder, error);

        NSString *xErrorString = parameters[XCallBackParameterError];
        NSURL *xError = [NSURL URLWithString:xErrorString];

        NSLog(@"Going back to x-callback source %@ using x-callback url %@", xSource, xErrorString);
        [self redirectToURL:xError];

    } else {
        NSLog(@"Saved %@ successfully.", reminder);

        NSString *xSuccessString = parameters[XCallbackParameterSuccess];
        NSURL *xSuccess = [NSURL URLWithString:xSuccessString];

        NSLog(@"Going back to x-callback source %@ using x-callback url %@", xSource, xSuccessString);
        [self redirectToURL:xSuccess];
    }
}

- (void)redirectToURL:(NSURL *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    });
}

- (EKCalendar *)findCalendarMatchingName:(NSString *)name
{
    __block EKCalendar *calendar;
    if ([name length] > 0) {
        NSArray *possibleCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        [possibleCalendars enumerateObjectsUsingBlock:^(EKCalendar *possibleMatch, NSUInteger idx, BOOL *stop) {
            if ([possibleMatch.title isEqualToString:name]) {
                calendar = possibleMatch;
                *stop = YES;
            }
        }];
    }

    if (!calendar) {
        EKCalendar *defaultCalendar = [self.eventStore defaultCalendarForNewReminders];
        calendar = defaultCalendar;
    }

    return calendar;
}

@end
