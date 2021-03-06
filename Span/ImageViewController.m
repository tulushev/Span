//
//  ImageViewController.m
//  Span
//
//  Created by Eugene Tulushev on 11/04/16.
//  Copyright © 2016 Eugene Tulushev. All rights reserved.
//

#import "Constants.h"
#import <GlitchKit/UIImage+GKGlitch.h>
#import "ImageViewController.h"
#import "IntroViewController.h"
@import MobileCoreServices;

NSString * const LogoSmallImageName = @"Logo_small";
NSString * const ButtonStopImageName = @"Button_Stop";
NSString * const PhotoPath = @"photo.png";
NSString * const GlitchDateKey = @"GlitchDate";

@interface ImageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIButton *buttonExport;
@property (nonatomic, strong) UIButton *buttonPhoto;
@property (nonatomic, strong) UIImage *photo;

@end


@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *backgroundColor = [UIColor colorWithRed:RedComponent
                                               green:GreenComponent
                                                blue:BlueComponent
                                               alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    
    
    self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LogoSmallImageName]];
    [self.view addSubview:self.logo];
    
    self.buttonPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonPhoto.backgroundColor = [UIColor blackColor];
    self.buttonPhoto.adjustsImageWhenHighlighted = NO;
    self.buttonPhoto.adjustsImageWhenDisabled = NO;
    [self loadPhoto];
    if (self.photo == nil) {
        [self addButtonImageTarget:YES];
    } else {
        [self.buttonPhoto setImage:self.photo forState:UIControlStateNormal];
    }
    [self.view addSubview:self.buttonPhoto];
    
    UIImage *buttonImage = [UIImage imageNamed:ButtonStopImageName];
    self.buttonExport = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.photo != nil) {
        [self addButtonExportTarget:YES];
    }
    [self.buttonExport setImage:buttonImage
                 forState:UIControlStateNormal];
    [self.view addSubview:self.buttonExport];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGSize viewSize = self.view.bounds.size;
    
    CGFloat logoFactorHeight = 0.1;
    self.logo.center = CGPointMake(self.view.center.x, (CGFloat)round(viewSize.height * logoFactorHeight));
    
    self.buttonPhoto.frame = CGRectMake(0.0, 0.0, viewSize.width, viewSize.width);
    self.buttonPhoto.center = self.view.center;
    
    CGFloat buttonFactorHeight = 0.89;
    UIImage *buttonImage = [UIImage imageNamed:ButtonStopImageName];
    self.buttonExport.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    self.buttonExport.center = CGPointMake(self.view.center.x, (CGFloat)round(viewSize.height * buttonFactorHeight));
    
    if (self.withIntro) {
        [self presentWalkthrough];
    }
}

#pragma mark - Walkthrough

- (void)presentWalkthrough {
    IntroViewController *intro = [[IntroViewController alloc] init];
    [self presentViewController:intro animated:YES completion:^{
        self.withIntro = NO;
    }];
}

#pragma mark - Buttons

- (void)addButtonImageTarget:(BOOL)add {
    [self changeButtonTarget:self.buttonPhoto action:@selector(takeImage) add:add];
}

- (void)addButtonExportTarget:(BOOL)add {
    [self changeButtonTarget:self.buttonExport action:@selector(exportToCameraRoll) add:add];
}

- (void)changeButtonTarget:(UIButton *)button action:(SEL)action add:(BOOL)add {
    id target = self;
    UIControlEvents controlEvents = UIControlEventTouchDown;
    
    if (add) {
        [button addTarget:target action:action forControlEvents:controlEvents];
        button.enabled = YES;
    } else {
        [button removeTarget:target action:action forControlEvents:controlEvents];
        button.enabled = NO;
    }
}

#pragma mark - Images

- (void)presentPicker {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    } else {
        NSLog(@"No camera");
    }
}

- (void)takeImage {
    [self presentPicker];
}

- (NSURL *)documentsDirectoryURL {
    NSError *error = nil;
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                        inDomain:NSUserDomainMask
                                               appropriateForURL:nil
                                                          create:NO
                                                           error:&error];
    if (error) {
        NSLog(@"Cant obtain document directory URL: %@", error);
    }
    
    return url;
}

- (NSURL *)saveLocation {
    return [[self documentsDirectoryURL] URLByAppendingPathComponent:PhotoPath];
}

- (void)loadPhoto {
    NSData *imageData = [NSData dataWithContentsOfURL:[self saveLocation]];
    self.photo = [UIImage imageWithData:imageData];
    [self checkAndGlitchIfNeeded];
}

- (void)savePhoto {
    if (self.photo != nil) {
        NSError *saveError = nil;
        NSData *imageData = UIImagePNGRepresentation(self.photo);
        BOOL writeWasSuccessful = [imageData writeToURL:[self saveLocation]
                                                options:kNilOptions
                                                  error:&saveError];
        if (!writeWasSuccessful) {
            NSLog(@"Unsuccessful image write to disk %@", saveError);
        }
    } else {
        NSLog(@"No photo to save");
    }
}

- (void)removePhoto {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtURL:[self saveLocation] error:&error];
    if (!success) {
        NSLog(@"Could not delete file: %@ ",[error localizedDescription]);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"Error exporting an image: %@", error);
        [self addButtonExportTarget:YES];
    } else {
        [self addButtonImageTarget:YES];
        [self addButtonExportTarget:NO];
        [self.buttonPhoto setImage:nil forState:UIControlStateNormal];
        [self removePhoto];
        self.photo = nil;
    }
}

- (void)exportToCameraRoll {
    if (self.photo) {
        [self addButtonImageTarget:NO];
        [self addButtonExportTarget:NO];
        UIImageWriteToSavedPhotosAlbum(self.photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        NSLog(@"Nothing to export");
    }
}

#pragma mark - Glitch

- (BOOL)shouldWeGlitch:(NSDate *)lastGlitchDate {
    if (!lastGlitchDate) {
        return NO;
    }
    
    NSUInteger days = 3;
    NSUInteger hours = 0;
    NSUInteger minutes = 0;
    NSUInteger seconds = 0;
    NSTimeInterval glitchTimeInterval = seconds + minutes * 60 + hours * 60 * 60 + days * 24 * 60 * 60;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastGlitchDate];
    if (timeInterval >= glitchTimeInterval) {
        return YES;
    } else {
        return NO;
    }
}

- (UIImage *)glitchPhoto:(UIImage *)photo {
    UIImage *glitchedPhoto = [photo glitchWithBlock:^int(int byte, int index, uint length, Byte *bytes) {
        NSUInteger numberOfGlitches = 6;
        NSUInteger rate = length / numberOfGlitches;
        if (arc4random() % rate == 1) {
            NSLog(@"Glitched byte: %d index: %d length: %d", byte, index, length);
            return 37 + arc4random() % 10;
        } else {
            return byte;
        }
    }];
    [self saveGlitchDate];
    return glitchedPhoto;
}

- (NSDate *)lastGlitchDate {
    return [[NSUserDefaults standardUserDefaults] valueForKey:GlitchDateKey];
}

- (void)saveGlitchDate {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:GlitchDateKey];
}

- (void)checkAndGlitchIfNeeded {
    if (self.photo) {
        NSDate *lastGlitchDate = [self lastGlitchDate];
        BOOL shouldWeGlitch = [self shouldWeGlitch:lastGlitchDate];
        if (shouldWeGlitch) {
            self.photo = [self glitchPhoto:self.photo];
            self.buttonPhoto.imageView.image = self.photo;
            [self savePhoto];
        }
    }
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.photo = [self glitchPhoto:[info valueForKey:UIImagePickerControllerEditedImage]];
    [self savePhoto];
    [self saveGlitchDate];
    [self addButtonImageTarget:NO];
    [self addButtonExportTarget:YES];
    [self.buttonPhoto setImage:self.photo forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
