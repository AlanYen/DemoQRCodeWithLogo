//
//  ViewController.m
//  DemoQRCodeWithLogo
//
//  Created by Alan.Yen on 2015/8/6.
//  Copyright (c) 2015年 17Life All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Content of QRCode
    NSMutableString *string = [NSMutableString string];
    for (NSInteger i = 0; i < 20; i++) {
        [string appendFormat:@"12345678-12345678 (%zd)\n", (i+1)];
    }
    
    // Generate QRCode image
    CIImage *qrCIImage = [self createQRForString:string];
    UIImage *qrImage = [[UIImage alloc] initWithCIImage:qrCIImage];
    
    // ImageView (400,400) vs Logo (80,80)
    CGFloat scale = (400.0f/qrImage.size.width);
    
    // Scale image to fix "blur problem" (模糊的問題)
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CIImage *scaledQRImage = [qrCIImage imageByApplyingTransform:transform];

    // Get image from label
    UIImage *logoImage = [self imageWithView:self.label];
    
    // Merge QRCode image and logo image
    UIImage *qrLogoImage = [self drawImage:[[UIImage alloc] initWithCIImage:scaledQRImage]
                                 withBadge:logoImage];
    self.imageView.image = qrLogoImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - [Processing Image]

- (CIImage*)createQRForString:(NSString*)qrString {
    
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

- (UIImage *)drawImage:(UIImage*)profileImage withBadge:(UIImage*)badge {
    
    UIGraphicsBeginImageContextWithOptions(profileImage.size, NO, profileImage.scale);
    [profileImage drawInRect:CGRectMake(0, 0, profileImage.size.width, profileImage.size.height)];
    [badge drawInRect:CGRectMake((profileImage.size.width - badge.size.width) * 0.5f,
                                 (profileImage.size.height - badge.size.height) * 0.5f,
                                 badge.size.width, badge.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage*)imageWithView:(UIView*)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
