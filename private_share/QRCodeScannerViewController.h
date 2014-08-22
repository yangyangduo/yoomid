//
//  QRCodeScannerViewController.h
//  private_share
//
//  Created by Zhao yang on 6/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ZBarReaderView.h"
#import "BaseViewController.h"

@protocol QRCodeScannerDelegate;

@interface QRCodeScannerViewController : BaseViewController<ZBarReaderViewDelegate>

@property(nonatomic, weak) id<QRCodeScannerDelegate> delegate;

- (void)unlockViewAndRestart:(BOOL)restart;

@end

@protocol QRCodeScannerDelegate <NSObject>

/*
 * if need to close scanner view
 * should be call method below first
 * [scanner unlockViewAndRestart:NO]
 */
- (void)QRCodeScanner:(QRCodeScannerViewController *)QRCodeScanner didScanSuccess:(NSString *)result;
- (void)QRCodeScanner:(QRCodeScannerViewController *)QRCodeScanner didScanFailureWithError:(NSError *)error;

@end


