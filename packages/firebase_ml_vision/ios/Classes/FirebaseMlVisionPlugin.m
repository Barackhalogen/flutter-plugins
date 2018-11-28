#import "FirebaseMlVisionPlugin.h"

@interface NSError (FlutterError)
@property(readonly, nonatomic) FlutterError *flutterError;
@end

@implementation NSError (FlutterError)
- (FlutterError *)flutterError {
  return [FlutterError errorWithCode:[NSString stringWithFormat:@"Error %d", (int)self.code]
                             message:self.domain
                             details:self.localizedDescription];
}
@end

@implementation FLTFirebaseMlVisionPlugin
+ (void)handleError:(NSError *)error result:(FlutterResult)result {
  result([error flutterError]);
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/firebase_ml_vision"
                                  binaryMessenger:[registrar messenger]];
  FLTFirebaseMlVisionPlugin *instance = [[FLTFirebaseMlVisionPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    if (![FIRApp defaultApp]) {
      [FIRApp configure];
    }
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  FIRVisionImage *image = [self dataToVisionImage:call.arguments];
  NSDictionary *options = call.arguments[@"options"];
  if ([@"BarcodeDetector#detectInImage" isEqualToString:call.method]) {
    [BarcodeDetector handleDetection:image options:options result:result];
  } else if ([@"FaceDetector#detectInImage" isEqualToString:call.method]) {
    [FaceDetector handleDetection:image options:options result:result];
  } else if ([@"LabelDetector#detectInImage" isEqualToString:call.method]) {
    [LabelDetector handleDetection:image options:options result:result];
  } else if ([@"CloudLabelDetector#detectInImage" isEqualToString:call.method]) {
    [CloudLabelDetector handleDetection:image options:options result:result];
  } else if ([@"TextRecognizer#processImage" isEqualToString:call.method]) {
    [TextRecognizer handleDetection:image options:options result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (FIRVisionImage *)dataToVisionImage:(NSDictionary *)imageData {
  NSString *imageType = imageData[@"type"];

  if ([@"file" isEqualToString:imageType]) {
    UIImage *image = [UIImage imageWithContentsOfFile:imageData[@"path"]];
    return [[FIRVisionImage alloc] initWithImage:image];
  } else if ([@"bytes" isEqualToString:imageType]) {
    FlutterStandardTypedData *byteData = imageData[@"bytes"];
    NSData *imageBytes = byteData.data;

    CVPixelBufferRef pxbuffer = NULL;
    size_t widths[2] = {1080, 1080};
    size_t heights[2] = {1920, 1920};
    size_t bytesPerRows[2] = {1088, 1080};
    CVPixelBufferCreateWithPlanarBytes(kCFAllocatorDefault, 1080, 1920, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, NULL, 4177920, 2, (void *) imageBytes.bytes, widths, heights, bytesPerRows, NULL, NULL, NULL, &pxbuffer);

    CMSampleTimingInfo info;
    info.presentationTimeStamp = kCMTimeZero;
    info.duration = kCMTimeInvalid;
    info.decodeTimeStamp = kCMTimeInvalid;

    CMFormatDescriptionRef formatDesc = NULL;
    CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pxbuffer, &formatDesc);

    CMSampleBufferRef sampleBuffer = NULL;
    CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault, pxbuffer, formatDesc, &info, &sampleBuffer);

    return [[FIRVisionImage alloc] initWithBuffer:sampleBuffer];
    /*
    UIImage *image = [[UIImage alloc] initWithData:imageBytes];
    // TODO(bmparr): Rotate image from imageData[@"rotation"].
    return [[FIRVisionImage alloc] initWithImage:image];
     */
  } else {
    NSString *errorReason = [NSString stringWithFormat:@"No image type for: %@", imageType];
    @throw
        [NSException exceptionWithName:NSInvalidArgumentException reason:errorReason userInfo:nil];
  }
}
@end
