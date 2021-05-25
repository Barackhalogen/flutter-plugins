// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTImagePickerPlugin.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <PhotosUI/PHPhotoLibrary+PhotosUISupport.h>
#import <PhotosUI/PhotosUI.h>
#import <UIKit/UIKit.h>

#import "FLTImagePickerImageUtil.h"
#import "FLTImagePickerMetaDataUtil.h"
#import "FLTImagePickerPhotoAssetUtil.h"

@interface FLTImagePickerPlugin () <UINavigationControllerDelegate,
                                    UIImagePickerControllerDelegate,
                                    PHPickerViewControllerDelegate>

@property(copy, nonatomic) FlutterResult result;

@property(nonatomic) bool single;

@property(copy, nonatomic) NSDictionary *arguments;

@property(strong, nonatomic) PHPickerViewController *pickerViewController API_AVAILABLE(ios(14));

@end

static const int SOURCE_CAMERA = 0;
static const int SOURCE_GALLERY = 1;

typedef NS_ENUM(NSInteger, ImagePickerClassType) { UIImagePickerClassType, PHPickerClassType };

@implementation FLTImagePickerPlugin {
  UIImagePickerController *_imagePickerController;
  UIImagePickerControllerCameraDevice _device;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/image_picker"
                                  binaryMessenger:[registrar messenger]];
  FLTImagePickerPlugin *instance = [FLTImagePickerPlugin new];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (UIImagePickerController *)getImagePickerController {
  return _imagePickerController;
}

- (UIViewController *)viewControllerWithWindow:(UIWindow *)window {
  UIWindow *windowToUse = window;
  if (windowToUse == nil) {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
      if (window.isKeyWindow) {
        windowToUse = window;
        break;
      }
    }
  }

  UIViewController *topController = windowToUse.rootViewController;
  while (topController.presentedViewController) {
    topController = topController.presentedViewController;
  }
  return topController;
}

- (void)pickImageWithPHPicker:(bool)single API_AVAILABLE(ios(14)) {
  PHPickerConfiguration *config =
      [[PHPickerConfiguration alloc] initWithPhotoLibrary:PHPhotoLibrary.sharedPhotoLibrary];
  if (!single) {
    config.selectionLimit = 0;  // Setting to zero allow us to pick unlimited photos
  }
  config.filter = [PHPickerFilter imagesFilter];

  _pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:config];
  _pickerViewController.delegate = self;

  self.single = single;

  [self checkPhotoAuthorizationForAccessLevel];
}

- (void)pickImageWithUIImagePicker {
  _imagePickerController = [[UIImagePickerController alloc] init];
  _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
  _imagePickerController.delegate = self;
  _imagePickerController.mediaTypes = @[ (NSString *)kUTTypeImage ];

  int imageSource = [[_arguments objectForKey:@"source"] intValue];

  switch (imageSource) {
    case SOURCE_CAMERA: {
      NSInteger cameraDevice = [[_arguments objectForKey:@"cameraDevice"] intValue];
      _device = (cameraDevice == 1) ? UIImagePickerControllerCameraDeviceFront
                                    : UIImagePickerControllerCameraDeviceRear;
      [self checkCameraAuthorization];
      break;
    }
    case SOURCE_GALLERY:
      [self checkPhotoAuthorization];
      break;
    default:
      self.result([FlutterError errorWithCode:@"invalid_source"
                                      message:@"Invalid image source."
                                      details:nil]);
      break;
  }
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if (self.result) {
    self.result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
    self.result = nil;
  }

  if ([@"pickImage" isEqualToString:call.method]) {
    self.result = result;
    _arguments = call.arguments;
    int imageSource = [[_arguments objectForKey:@"source"] intValue];

    if (imageSource == SOURCE_GALLERY) {  // Capture is not possible with PHPicker
      if (@available(iOS 14, *)) {
        // PHPicker is used
        [self pickImageWithPHPicker:true];
      } else {
        // UIImagePicker is used
        [self pickImageWithUIImagePicker];
      }
    } else {
      [self pickImageWithUIImagePicker];
    }
  } else if ([@"pickMultiImage" isEqualToString:call.method]) {
    if (@available(iOS 14, *)) {
      self.result = result;
      _arguments = call.arguments;
      [self pickImageWithPHPicker:false];
    }
  } else if ([@"pickVideo" isEqualToString:call.method]) {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _imagePickerController.delegate = self;
    _imagePickerController.mediaTypes = @[
      (NSString *)kUTTypeMovie, (NSString *)kUTTypeAVIMovie, (NSString *)kUTTypeVideo,
      (NSString *)kUTTypeMPEG4
    ];
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;

    self.result = result;
    _arguments = call.arguments;

    int imageSource = [[_arguments objectForKey:@"source"] intValue];
    if ([[_arguments objectForKey:@"maxDuration"] isKindOfClass:[NSNumber class]]) {
      NSTimeInterval max = [[_arguments objectForKey:@"maxDuration"] doubleValue];
      _imagePickerController.videoMaximumDuration = max;
    }

    switch (imageSource) {
      case SOURCE_CAMERA:
        [self checkCameraAuthorization];
        break;
      case SOURCE_GALLERY:
        [self checkPhotoAuthorization];
        break;
      default:
        result([FlutterError errorWithCode:@"invalid_source"
                                   message:@"Invalid video source."
                                   details:nil]);
        break;
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)showCamera {
  @synchronized(self) {
    if (_imagePickerController.beingPresented) {
      return;
    }
  }
  // Camera is not available on simulators
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
      [UIImagePickerController isCameraDeviceAvailable:_device]) {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.cameraDevice = _device;
    [[self viewControllerWithWindow:nil] presentViewController:_imagePickerController
                                                      animated:YES
                                                    completion:nil];
  } else {
    UIAlertController *cameraErrorAlert = [UIAlertController
        alertControllerWithTitle:NSLocalizedString(@"Error", @"Alert title when camera unavailable")
                         message:NSLocalizedString(@"Camera not available.",
                                                   "Alert message when camera unavailable")
                  preferredStyle:UIAlertControllerStyleAlert];
    [cameraErrorAlert
        addAction:[UIAlertAction actionWithTitle:NSLocalizedString(
                                                     @"OK", @"Alert button when camera unavailable")
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action){
                                         }]];
    [[self viewControllerWithWindow:nil] presentViewController:cameraErrorAlert
                                                      animated:YES
                                                    completion:nil];
    self.result(nil);
    self.result = nil;
    _arguments = nil;
  }
}

- (void)checkCameraAuthorization {
  AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

  switch (status) {
    case AVAuthorizationStatusAuthorized:
      [self showCamera];
      break;
    case AVAuthorizationStatusNotDetermined: {
      [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                               completionHandler:^(BOOL granted) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                   if (granted) {
                                     [self showCamera];
                                   } else {
                                     [self errorNoCameraAccess:AVAuthorizationStatusDenied];
                                   }
                                 });
                               }];
      break;
    }
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
    default:
      [self errorNoCameraAccess:status];
      break;
  }
}

- (void)checkPhotoAuthorization {
  PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
  switch (status) {
    case PHAuthorizationStatusNotDetermined: {
      [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
          if (status == PHAuthorizationStatusAuthorized) {
            [self showPhotoLibrary:UIImagePickerClassType];
          } else {
            [self errorNoPhotoAccess:status];
          }
        });
      }];
      break;
    }
    case PHAuthorizationStatusAuthorized:
      [self showPhotoLibrary:UIImagePickerClassType];
      break;
    case PHAuthorizationStatusDenied:
    case PHAuthorizationStatusRestricted:
    default:
      [self errorNoPhotoAccess:status];
      break;
  }
}

- (void)checkPhotoAuthorizationForAccessLevel API_AVAILABLE(ios(14)) {
  PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
  switch (status) {
    case PHAuthorizationStatusNotDetermined: {
      [PHPhotoLibrary
          requestAuthorizationForAccessLevel:PHAccessLevelReadWrite
                                     handler:^(PHAuthorizationStatus status) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                         if (status == PHAuthorizationStatusAuthorized) {
                                           [self showPhotoLibrary:PHPickerClassType];
                                         } else if (status == PHAuthorizationStatusLimited) {
                                           [self showPhotoLibrary:PHPickerClassType];
                                         } else {
                                           [self errorNoPhotoAccess:status];
                                         }
                                       });
                                     }];
      break;
    }
    case PHAuthorizationStatusAuthorized:
    case PHAuthorizationStatusLimited:
      [self showPhotoLibrary:PHPickerClassType];
      break;
    case PHAuthorizationStatusDenied:
    case PHAuthorizationStatusRestricted:
    default:
      [self errorNoPhotoAccess:status];
      break;
  }
}

- (void)errorNoCameraAccess:(AVAuthorizationStatus)status {
  switch (status) {
    case AVAuthorizationStatusRestricted:
      self.result([FlutterError errorWithCode:@"camera_access_restricted"
                                      message:@"The user is not allowed to use the camera."
                                      details:nil]);
      break;
    case AVAuthorizationStatusDenied:
    default:
      self.result([FlutterError errorWithCode:@"camera_access_denied"
                                      message:@"The user did not allow camera access."
                                      details:nil]);
      break;
  }
}

- (void)errorNoPhotoAccess:(PHAuthorizationStatus)status {
  switch (status) {
    case PHAuthorizationStatusRestricted:
      self.result([FlutterError errorWithCode:@"photo_access_restricted"
                                      message:@"The user is not allowed to use the photo."
                                      details:nil]);
      break;
    case PHAuthorizationStatusDenied:
    default:
      self.result([FlutterError errorWithCode:@"photo_access_denied"
                                      message:@"The user did not allow photo access."
                                      details:nil]);
      break;
  }
}

- (void)showPhotoLibrary:(ImagePickerClassType)imagePickerClassType {
  // No need to check if SourceType is available. It always is.
  switch (imagePickerClassType) {
    case PHPickerClassType:
      [[self viewControllerWithWindow:nil] presentViewController:_pickerViewController
                                                        animated:YES
                                                      completion:nil];
      break;
    case UIImagePickerClassType:
      _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      [[self viewControllerWithWindow:nil] presentViewController:_imagePickerController
                                                        animated:YES
                                                      completion:nil];
      break;
  }
}

- (NSNumber *)getDesiredImageQuality:(NSNumber *)imageQuality {
  if (![imageQuality isKindOfClass:[NSNumber class]]) {
    imageQuality = @1;
  } else if (imageQuality.intValue < 0 || imageQuality.intValue > 100) {
    imageQuality = [NSNumber numberWithInt:1];
  } else {
    imageQuality = @([imageQuality floatValue] / 100);
  }
  return imageQuality;
}

- (void)picker:(PHPickerViewController *)picker
    didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)) {
  [picker dismissViewControllerAnimated:YES completion:nil];

  NSNumber *maxWidth = [_arguments objectForKey:@"maxWidth"];
  NSNumber *maxHeight = [_arguments objectForKey:@"maxHeight"];
  NSNumber *imageQuality = [_arguments objectForKey:@"imageQuality"];
  NSNumber *desiredImageQuality = [self getDesiredImageQuality:imageQuality];
  NSMutableArray *pathList = [NSMutableArray new];

  for (PHPickerResult *result in results) {
    [result.itemProvider
        loadObjectOfClass:[UIImage class]
        completionHandler:^(__kindof id<NSItemProviderReading> _Nullable image,
                            NSError *_Nullable error) {
          if ([image isKindOfClass:[UIImage class]]) {
            __block UIImage *localImage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
              PHAsset *originalAsset =
                  [FLTImagePickerPhotoAssetUtil getAssetFromPHPickerResult:result];

              if (maxWidth != (id)[NSNull null] || maxHeight != (id)[NSNull null]) {
                localImage = [FLTImagePickerImageUtil scaledImage:localImage
                                                         maxWidth:maxWidth
                                                        maxHeight:maxHeight
                                              isMetadataAvailable:originalAsset != nil];
              }
              __block NSString *savedPath;
              if (!originalAsset) {
                // Image picked without an original asset (e.g. User took a photo directly)
                savedPath =
                    [FLTImagePickerPhotoAssetUtil saveImageWithPickerInfo:nil
                                                                    image:localImage
                                                             imageQuality:desiredImageQuality];
                [pathList addObject:savedPath];

              } else {
                [[PHImageManager defaultManager]
                    requestImageDataForAsset:originalAsset
                                     options:nil
                               resultHandler:^(
                                   NSData *_Nullable imageData, NSString *_Nullable dataUTI,
                                   UIImageOrientation orientation, NSDictionary *_Nullable info) {
                                 // maxWidth and maxHeight are used only for GIF images.
                                 savedPath = [FLTImagePickerPhotoAssetUtil
                                     saveImageWithOriginalImageData:imageData
                                                              image:localImage
                                                           maxWidth:maxWidth
                                                          maxHeight:maxHeight
                                                       imageQuality:desiredImageQuality];
                                 [pathList addObject:savedPath];
                                 if (pathList.count == results.count) {
                                   [self handlePath:savedPath listCount:pathList];
                                 }
                               }];
              }
              if (pathList.count == results.count) {
                [self handlePath:savedPath listCount:pathList];
              }
            });
          }
        }];
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
  NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
  [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
  // The method dismissViewControllerAnimated does not immediately prevent
  // further didFinishPickingMediaWithInfo invocations. A nil check is necessary
  // to prevent below code to be unwantly executed multiple times and cause a
  // crash.
  if (!self.result) {
    return;
  }
  if (videoURL != nil) {
    if (@available(iOS 13.0, *)) {
      NSString *fileName = [videoURL lastPathComponent];
      NSURL *destination =
          [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];

      if ([[NSFileManager defaultManager] isReadableFileAtPath:[videoURL path]]) {
        NSError *error;
        if (![[videoURL path] isEqualToString:[destination path]]) {
          [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:destination error:&error];

          if (error) {
            self.result([FlutterError errorWithCode:@"flutter_image_picker_copy_video_error"
                                            message:@"Could not cache the video file."
                                            details:nil]);
            self.result = nil;
            return;
          }
        }
        videoURL = destination;
      }
    }
    self.result(videoURL.path);
    self.result = nil;
    _arguments = nil;
  } else {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
      image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSNumber *maxWidth = [_arguments objectForKey:@"maxWidth"];
    NSNumber *maxHeight = [_arguments objectForKey:@"maxHeight"];
    NSNumber *imageQuality = [_arguments objectForKey:@"imageQuality"];
    NSNumber *desiredImageQuality = [self getDesiredImageQuality:imageQuality];

    PHAsset *originalAsset = [FLTImagePickerPhotoAssetUtil getAssetFromImagePickerInfo:info];

    if (maxWidth != (id)[NSNull null] || maxHeight != (id)[NSNull null]) {
      image = [FLTImagePickerImageUtil scaledImage:image
                                          maxWidth:maxWidth
                                         maxHeight:maxHeight
                               isMetadataAvailable:originalAsset != nil];
    }

    if (!originalAsset) {
      // Image picked without an original asset (e.g. User took a photo directly)
      [self saveImageWithPickerInfo:info image:image imageQuality:desiredImageQuality];
    } else {
      [[PHImageManager defaultManager]
          requestImageDataForAsset:originalAsset
                           options:nil
                     resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI,
                                     UIImageOrientation orientation, NSDictionary *_Nullable info) {
                       // maxWidth and maxHeight are used only for GIF images.
                       [self saveImageWithOriginalImageData:imageData
                                                      image:image
                                                   maxWidth:maxWidth
                                                  maxHeight:maxHeight
                                               imageQuality:desiredImageQuality];
                     }];
    }
  }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
  if (!self.result) {
    return;
  }
  self.result(nil);
  self.result = nil;
  _arguments = nil;
}

- (void)saveImageWithOriginalImageData:(NSData *)originalImageData
                                 image:(UIImage *)image
                              maxWidth:(NSNumber *)maxWidth
                             maxHeight:(NSNumber *)maxHeight
                          imageQuality:(NSNumber *)imageQuality {
  NSString *savedPath =
      [FLTImagePickerPhotoAssetUtil saveImageWithOriginalImageData:originalImageData
                                                             image:image
                                                          maxWidth:maxWidth
                                                         maxHeight:maxHeight
                                                      imageQuality:imageQuality];
  [self handleSavedPath:savedPath];
}

- (void)saveImageWithPickerInfo:(NSDictionary *)info
                          image:(UIImage *)image
                   imageQuality:(NSNumber *)imageQuality {
  NSString *savedPath = [FLTImagePickerPhotoAssetUtil saveImageWithPickerInfo:info
                                                                        image:image
                                                                 imageQuality:imageQuality];
  [self handleSavedPath:savedPath];
}

- (void)handleSavedPath:(NSString *)path {
  if (!self.result) {
    return;
  }
  if (path) {
    self.result(path);
  } else {
    self.result([FlutterError errorWithCode:@"create_error"
                                    message:@"Temporary file could not be created"
                                    details:nil]);
  }
  self.result = nil;
  _arguments = nil;
}

- (void)handleMultiSavedPaths:(NSMutableArray *)pathList {
  if (!self.result) {
    return;
  }
  if (pathList.count > 0) {
    self.result(pathList);
  } else {
    self.result([FlutterError errorWithCode:@"create_error"
                                    message:@"Temporary files could not be created"
                                    details:nil]);
  }
  self.result = nil;
  _arguments = nil;
}

@end
