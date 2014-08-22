//
//  QRCodeScannerViewController.m
//  private_share
//
//  Created by Zhao yang on 6/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "QRCodeScannerViewController.h"

CGFloat const kScannerViewWidth = 260.f;
NSInteger const kIndicatorViewTag = 10012;

typedef NS_ENUM(NSUInteger, MoveDirection) {
    MoveDirectionDown,
    MoveDirectionUp
};

@interface QRCodeScannerViewController ()

@end

@implementation QRCodeScannerViewController {
    ZBarReaderView *readerView;
    UIImageView *scannerFrame;
    UIImageView *scannerLine;
    MoveDirection moveDirection;
    
    UIView *lockView;
}

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"qr_code_scanner", @"");
    
    readerView = [[ZBarReaderView alloc] init];
    readerView.frame = self.view.bounds;
    readerView.readerDelegate = self;
    
    //close flash light
    readerView.torchMode = 0;
    readerView.tracksSymbols = NO;
    
    UIButton *btnFlashLight = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 30, 30)];
    [btnFlashLight setBackgroundImage:[UIImage imageNamed:@"btn_flash_light"] forState:UIControlStateNormal];
    [btnFlashLight addTarget:self action:@selector(btnFlashLightPressed:) forControlEvents:UIControlEventTouchUpInside];
    [readerView addSubview:btnFlashLight];
    
    UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 24, 30, 30)];
    [btnInfo setBackgroundImage:[UIImage imageNamed:@"btn_info"] forState:UIControlStateNormal];
    // [btnInfo addTarget:self action:@selector(btnFlashLightPressed:) forControlEvents:UIControlEventTouchUpInside];
    [readerView addSubview:btnInfo];
    
    //sanner region
    CGFloat scannerShowFrameWidth = kScannerViewWidth - 90;
    CGRect rectForScannerView = CGRectMake((readerView.center.x - scannerShowFrameWidth / 2), 100, scannerShowFrameWidth, scannerShowFrameWidth);
    
    //set scanner frame
    scannerFrame = [[UIImageView alloc] initWithFrame:rectForScannerView];
    scannerFrame.image = [UIImage imageNamed:@"bg_scanner_view"];
    [readerView addSubview:scannerFrame];
    
    scannerLine = [[UIImageView alloc] initWithFrame:CGRectMake(rectForScannerView.origin.x, rectForScannerView.origin.y, scannerShowFrameWidth, 10)];
    scannerLine.image = [UIImage imageNamed:@"line_scanner"];
    [readerView addSubview:scannerLine];
    
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 235, 21)];
    lblTips.text = NSLocalizedString(@"qr_code_tips", @"");
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.backgroundColor = [UIColor clearColor];
    lblTips.textColor = [UIColor lightTextColor];
    lblTips.font = [UIFont systemFontOfSize:15.f];
    lblTips.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, scannerFrame.center.y + 140);
    [readerView addSubview:lblTips];
    
    //set scanner region
    readerView.scanCrop = [self regionRectForScanner:CGRectMake((readerView.center.x - kScannerViewWidth / 2), (readerView.center.y - kScannerViewWidth / 2), kScannerViewWidth, kScannerViewWidth) readerViewBounds:readerView.bounds];
    [self.view addSubview:readerView];
    
    [readerView start];
    [self startScannerAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark events

- (void)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnFlashLightPressed:(id)sender {
    if(readerView == nil) return;
    if(readerView.torchMode == 0) {
        readerView.torchMode = 1;
    } else if(readerView.torchMode == 1) {
        readerView.torchMode = 0;
    }
}

#pragma mark -
#pragma mark scanner view

- (void)movingScannerLine:(NSTimer *)timer {
    CGFloat yMin = scannerFrame.frame.origin.y;
    CGFloat yMax = scannerFrame.frame.origin.y + (kScannerViewWidth - 90) - 7;
    CGFloat y = scannerLine.frame.origin.y;
    
    if(y >= yMax) {
        moveDirection = MoveDirectionUp;
    } else if(y <= yMin) {
        moveDirection = MoveDirectionDown;
    }
    
    if(moveDirection == MoveDirectionDown) {
        scannerLine.center = CGPointMake(scannerLine.center.x, scannerLine.center.y+1);
    } else {
        scannerLine.center = CGPointMake(scannerLine.center.x, scannerLine.center.y-1);
    }
}

- (void)lockView {
    if(lockView == nil) {
        lockView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        lockView.backgroundColor = [UIColor blackColor];
        lockView.alpha = 0.8f;
        
        UIView  *processingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
        processingView.center = CGPointMake(scannerFrame.center.x + 16, scannerFrame.center.y + 65);
        processingView.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 0, 44, 44)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.backgroundColor = [UIColor clearColor];
        indicator.tag = kIndicatorViewTag;
        [processingView addSubview:indicator];
        
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(70, 7, 140, 30)];
        lblMessage.textColor = [UIColor lightTextColor];
        lblMessage.font = [UIFont boldSystemFontOfSize:18.f];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.text = NSLocalizedString(@"processing", @"");
        [processingView addSubview:lblMessage];
        
        [lockView addSubview:processingView];
    }
    scannerLine.hidden = YES;
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[lockView viewWithTag:kIndicatorViewTag];
    if(indicator != nil) {
        [indicator startAnimating];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:lockView];
}

- (void)unlockViewAndRestart:(BOOL)restart {
    if(lockView != nil) {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[lockView viewWithTag:kIndicatorViewTag];
        if(indicator != nil) {
            [indicator stopAnimating];
        }
        [lockView removeFromSuperview];
        if(restart) {
            scannerLine.hidden = NO;
            [readerView start];
        }
    }
}

- (void)startScannerAnimating {
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(movingScannerLine:) userInfo:nil repeats:YES];
}

#pragma mark -
#pragma mark QR Code calc

-(CGRect)regionRectForScanner:(CGRect)scannerView readerViewBounds:(CGRect)readerView_ {
    CGFloat x, y, width, height;
    x = scannerView.origin.x / readerView_.size.width;
    y = scannerView.origin.y / readerView_.size.height;
    width = scannerView.size.width / readerView_.size.width;
    height = scannerView.size.height / readerView_.size.height;
    return CGRectMake(x, y, width, height);
}

#pragma mark -
#pragma mark zbar delegate

- (void)readerView:(ZBarReaderView *)readerView_ didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    NSString *result = @"";
    for (ZBarSymbol *symbol in symbols) {
        result = symbol.data;
        break;
    }
    
    [readerView_ stop];
#ifdef DEBUG
    NSLog(@"[QR Code Scanner] Result: %@", result);
#endif
    
    [self lockView];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(QRCodeScanner:didScanSuccess:)]) {
        [self.delegate QRCodeScanner:self didScanSuccess:result];
    }
}

- (void)readerViewDidStart:(ZBarReaderView *)readerView {
}

- (void)readerView:(ZBarReaderView *)readerView didStopWithError:(NSError *)error {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(QRCodeScanner:didScanFailureWithError:)]) {
        [self.delegate QRCodeScanner:self didScanFailureWithError:error];
    }
}

@end
