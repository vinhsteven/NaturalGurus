//
//  ViewController.m
//  Hello-World
//
//  Copyright (c) 2013 TokBox, Inc. All rights reserved.
//

#import "StreamingVideoViewController.h"
#import <OpenTok/OpenTok.h>

@interface StreamingVideoViewController ()
<OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate>

@end

@implementation StreamingVideoViewController {
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
}
static double widgetHeight = 100;
static double widgetWidth = 100;

// *** Fill the following variables using your own Project info  ***
// ***          https://dashboard.tokbox.com/projects            ***
//// Replace with your OpenTok API key
//static NSString* const kApiKey = @"45275422";
//// Replace with your generated session ID
//static NSString* const kSessionId = @"1_MX40NTI3NTQyMn5-MTQzNTc0NDAwMzEzMX5wUldlM0xRVDFGUlkraGt6eEJFVk1RK3B-fg";
//// Replace with your generated token
//static NSString* const kToken = @"T1==cGFydG5lcl9pZD00NTI3NTQyMiZzaWc9MjM4YmU2MWFiNTQ4NDg2OTE1YTY2M2EwNzBiODI5ZTM2NzA3NjJkMjpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5USTNOVFF5TW41LU1UUXpOVGMwTkRBd016RXpNWDV3VWxkbE0weFJWREZHVWxrcmFHdDZlRUpGVmsxUkszQi1mZyZjcmVhdGVfdGltZT0xNDM1NzQ0MDA4Jm5vbmNlPTAuNzA0MzA4MjY5Mzg0MDAxMiZleHBpcmVfdGltZT0xNDM4MzM1OTg2JmNvbm5lY3Rpb25fZGF0YT0=";

// Change to NO to subscribe to streams other than your own.
static bool subscribeToSelf = NO;

@synthesize kApiKey;
@synthesize kSessionId;
@synthesize kToken;

@synthesize parent;
@synthesize duration;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenSize = [UIScreen mainScreen].bounds.size;
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    btnEndCall = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEndCall setImage:[UIImage imageNamed:@"btnEndCall.png"] forState:UIControlStateNormal];
    btnEndCall.frame = CGRectMake(0, 0, 64, 64);
    btnEndCall.center = CGPointMake(screenSize.width/2, screenSize.height-50);
    [btnEndCall addTarget:self action:@selector(handleEndCalling) forControlEvents:UIControlEventTouchUpInside];
    
    btnEndCall.hidden = YES;
    
    lbTimer = [[UILabel alloc] initWithFrame:CGRectMake(0, screenSize.height-21, 100, 21)];
    lbTimer.backgroundColor = [UIColor whiteColor];
    lbTimer.textColor = [UIColor blackColor];
    lbTimer.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:14];
    lbTimer.textAlignment = NSTextAlignmentCenter;
    
    int hour = duration / 3600;
    int min  = duration / 60;
    int sec  = duration % 60;
    
    lbTimer.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
//    [self.view insertSubview:lbTimer atIndex:INT_MAX];
    
    btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(screenSize.width - 30, 30, 24, 24);
    [btnClose setImage:[UIImage imageNamed:@"btnClose.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.actualDuration = 0;
    
    // Step 1: As the view comes into the foreground, initialize a new instance
    // of OTSession and begin the connection process.
    _session = [[OTSession alloc] initWithApiKey:kApiKey
                                       sessionId:kSessionId
                                        delegate:self];
    [self doConnect];
}

- (void) closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updateTimer {
    self.actualDuration++;
    duration--;
    
    int hour = duration / 3600;
    int min  = duration / 60;
    int sec  = duration % 60;
    
    lbTimer.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
}

- (void) handleEndCalling {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    
    OTError *error = nil;
    [_session signalWithType:@"session_stop" string:nil connection:nil error:nil];
    if (error) {
        NSLog(@"signal error %@", error);
    }
    else {
        NSLog(@"signal sent");
    }
    
    //just client update data and just when they do it intentionlly, not by connection interrupt
    int userRole = [[ToolClass instance] getUserRole];
    if (userRole == isUser) {
        NSString *token = [[ToolClass instance] getUserToken];
        //update data to server
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.appointmentId],@"order_id",[NSNumber numberWithInt:self.actualDuration],@"duration",token,@"token", nil];
        [[ToolClass instance] finishAppointment:params withViewController:self];
    }
    else {
        [self finishAppointment];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return HIDE_STATUS_BAR;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UIUserInterfaceIdiomPhone == [[UIDevice currentDevice]
                                      userInterfaceIdiom])
    {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - OpenTok methods

/** 
 * Asynchronously begins the session connect process. Some time later, we will
 * expect a delegate method to call us back with the results of this action.
 */
- (void)doConnect
{
    OTError *error = nil;
    
    [_session connectWithToken:kToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Sets up an instance of OTPublisher to use with this session. OTPubilsher
 * binds to the device camera and microphone, and will provide A/V streams
 * to the OpenTok session.
 */
- (void)doPublish
{
    _publisher =
    [[OTPublisher alloc] initWithDelegate:self
                                     name:[[UIDevice currentDevice] name]];
   
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    
    [self.view addSubview:_publisher.view];
    [_publisher.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    [self.view insertSubview:btnClose atIndex:INT_MAX];
}

/**
 * Cleans up the publisher and its view. At this point, the publisher should not
 * be attached to the session any more.
 */
- (void)cleanupPublisher {
    [_publisher.view removeFromSuperview];
    _publisher = nil;
    // this is a good place to notify the end-user that publishing has stopped.
}

/**
 * Instantiates a subscriber for the given stream and asynchronously begins the
 * process to begin receiving A/V content for this stream. Unlike doPublish, 
 * this method does not add the subscriber to the view hierarchy. Instead, we 
 * add the subscriber only after it has connected and begins receiving data.
 */
- (void)doSubscribe:(OTStream*)stream
{
    _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Cleans the subscriber from the view hierarchy, if any.
 * NB: You do *not* have to call unsubscribe in your controller in response to
 * a streamDestroyed event. Any subscribers (or the publisher) for a stream will
 * be automatically removed from the session during cleanup of the stream.
 */
- (void)cleanupSubscriber
{
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
    
    //scale publisher view normal
    _publisher.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
}

# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    // Step 2: We have successfully connected, now instantiate a publisher and
    // begin pushing A/V streams into OpenTok.
    [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
    [NSString stringWithFormat:@"Session disconnected: (%@)",
     session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}


- (void)session:(OTSession*)mySession
  streamCreated:(OTStream *)stream
{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    
    // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
    // have seen on the OpenTok session.
    if (nil == _subscriber && !subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
        
        [self handleEndCalling];
    }
}

- (void)  session:(OTSession *)session
connectionCreated:(OTConnection *)connection
{
    NSLog(@"session connectionCreated (%@)", connection.connectionId);
}

- (void)    session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
    NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
    if ([_subscriber.stream.connection.connectionId
         isEqualToString:connection.connectionId])
    {
        [self cleanupSubscriber];
        
        [self handleEndCalling];
    }
}

- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
    NSLog(@"didFailWithError: (%@)", error);
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);
    assert(_subscriber == subscriber);
//    [_subscriber.view setFrame:CGRectMake(0, widgetHeight, widgetWidth,widgetHeight)];
//    [self.view addSubview:_subscriber.view];
    
    //set full screen for subscriber
    [_subscriber.view setFrame:CGRectMake(0, 0, screenSize.width,screenSize.height)];
    [self.view insertSubview:_subscriber.view belowSubview:_publisher.view];
    
    //scale publisher view smaller
    _publisher.view.frame = CGRectMake(0, 0, widgetWidth, widgetHeight);
    
    //show end call button
    [self.view insertSubview:btnEndCall atIndex:INT_MAX-1];
    btnEndCall.hidden = NO;
    
    //start count down
    [self.view insertSubview:lbTimer atIndex:INT_MAX];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    //remove btnClose
    [btnClose removeFromSuperview];
}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@",
          subscriber.stream.streamId,
          error);
}

# pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit *)publisher
    streamCreated:(OTStream *)stream
{
    // Step 3b: (if YES == subscribeToSelf): Our own publisher is now visible to
    // all participants in the OpenTok session. We will attempt to subscribe to
    // our own stream. Expect to see a slight delay in the subscriber video and
    // an echo of the audio coming from the device microphone.
    if (nil == _subscriber && subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)publisher:(OTPublisherKit*)publisher
  streamDestroyed:(OTStream *)stream
{
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
    
    [self cleanupPublisher];
    
    //process update data to server when expert finish it
    [self handleEndCalling];
}

- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
    NSLog(@"publisher didFailWithError %@", error);
    [self cleanupPublisher];
}

- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
	dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                         message:string
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] ;
        [alert show];
    });
}

- (void) finishAppointment {
    ((DetailAppointmentViewController*)parent).isFinishMeeting = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) dealloc {
    NSLog(@"StreamingVideo dealloc");
}

@end
