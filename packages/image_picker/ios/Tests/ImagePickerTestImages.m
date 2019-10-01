// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ImagePickerTestImages.h"

@implementation ImagePickerTestImages

+ (NSData*)JPGTestData {
  NSBundle* bundle = [NSBundle bundleForClass:self];
  NSURL* url = [bundle URLForResource:@"jpgImage" withExtension:@"jpg"];
  NSData* data = [NSData dataWithContentsOfURL:url];
  if (!data.length) {
    // When the tests are run outside the example project (podspec lint) the image may not be
    // embedded in the test bundle. Fall back to the base64 string representation of the jpg.
    data = [[NSData alloc]
        initWithBase64EncodedString:
            @"/9j/4AAQSkZJRgABAQAALgAuAAD/4QCMRXhpZgAATU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABA"
             "AAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAAAuAAAAAQAAAC4AAAABAAOg"
             "AQADAAAAAQABAACgAgAEAAAAAQAAAAygAwAEAAAAAQAAAAcAAAAA/+EJc2h0dHA6Ly9ucy5hZG9iZS5jb20"
             "veGFwLzEuMC8APD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz"
             "4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiP"
             "iA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucy"
             "MiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZ"
             "G9iZS5jb20vcGhvdG9zaG9wLzEuMC8iIHBob3Rvc2hvcDpDcmVkaXQ9IsKpIEdvb2dsZSIvPiA8L3JkZjpSR"
             "EY+IDwveDp4bXBtZXRhPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI"
             "CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDw/eHBhY2tldCBlbmQ9In"
             "ciPz4A/+0AVlBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAdHAFaAAMbJUccAgAAAgACHAJuAAnCqSBHb29nbG"
             "UAOEJJTQQlAAAAAAAQmkt2IF3PgNJVMGnV2zijEf/AABEIAAcADAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQA"
             "AAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQ"
             "gjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h"
             "5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp"
             "6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAAB"
             "AncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0R"
             "FRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tr"
             "e4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2wBDAAQDAwMDAgQDAwMEBAQFBgoGBg"
             "UFBgwICQcKDgwPDg4MDQ0PERYTDxAVEQ0NExoTFRcYGRkZDxIbHRsYHRYYGRj/"
             "2wBDAQQEBAYFBgsGBgsYEA0Q"
             "GBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBj/3QAEAAH/"
             "2gAMAwEAAh"
             "EDEQA/AMWiiivzk/qo/9k="
                            options:0];
  }
  return data;
}

+ (NSData*)PNGTestData {
  NSBundle* bundle = [NSBundle bundleForClass:self];
  NSURL* url = [bundle URLForResource:@"pngImage" withExtension:@"png"];
  NSData* data = [NSData dataWithContentsOfURL:url];
  if (!data.length) {
    // When the tests are run outside the example project (podspec lint) the image may not be
    // embedded in the test bundle. Fall back to the base64 string representation of the png.
    data = [[NSData alloc]
        initWithBase64EncodedString:
            @"iVBORw0KGgoAAAAEQ2dCSVAAIAYsuHdmAAAADUlIRFIAAAAMAAAABwgGAAAAPLKsJAAAAARnQU1BAACxj"
             "wv8YQUAAAABc1JHQgCuzhzpAAAAIGNIUk0AAHomAACAhAAA+"
             "gAAAIDoAAB1MAAA6mAAADqYAAAXcJy6UTwAAAAJ"
             "cEhZcwAABxMAAAcTAc4gDwgAAAAOSURBVGMwdX71nxTMMKqBCAwAsfuEYQAAAABJRU5ErkJggg=="
                            options:0];
  }
  return data;
}

+ (NSData*)GIFTestData {
  NSBundle* bundle = [NSBundle bundleForClass:self];
  NSURL* url = [bundle URLForResource:@"gifImage" withExtension:@"gif"];
  NSData* data = [NSData dataWithContentsOfURL:url];
  if (!data.length) {
    // When the tests are run outside the example project (podspec lint) the image may not be
    // embedded in the test bundle. Fall back to the base64 string representation of the gif.
    data = [[NSData alloc]
        initWithBase64EncodedString:
            @"R0lGODlhDAAHAPAAAOpCNQAAACH5BABkAAAAIf8LTkVUU0NBUEUyLjADAQAAAC"
            "wAAAAADAAHAAACCISP"
             "qcvtD1UBACH5BABkAAAALAAAAAAMAAcAhuc/JPA/K+49Ne4+PvA7MrhYHoB+A4N9BYh+BYZ+E4xyG496HZJ"
             "8F5J4GaRtE6tsH7tWIr9SK7xVKJl3IKpvI7lrKc1FLc5PLNJILsdTJMFVJsZWJshWIM9XIshWJNBWLd1SK9"
             "BUMNFRNOlAI+9CMuNJMetHPnuCAF66F1u8FVu7GV27HGytG3utGH6rHGK1G3WxFWeuIHqlIG60IGi4JTnTDz"
             "jZDy/VEy/eFTnVEDzXFxflABfjBRPmBRbnBxPrABvpARntAxLuCBXuCQTyAAb1BgvwACnmDSPpDSLjECPpED"
             "HhFFDLGIeAFoiBFoqCF4uCHYWnHJGVJqSNJQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
             "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
             "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdWgAIXCjE3PTtAPDUuByQfCzQ4Qj9BPjktBgAcC"
             "StJRURGQzYwJyMdDDM6SkhHS0xRCAEgD1IsKikoLzJTDgQlEBQNT05NUBMVBQMmGCEZHhsaEhEiFoEAIfkEAG"
             "QAAAAsAAAAAAwABwCFB+8ACewACu0ACe4ACO8AC+4ACu8ADOwAD+wAEOYAEekAA/EABfAAB/IAAfUAA/UAAP"
             "cAAfcAAvYAA/cBBPQABfUABvQAB/UBBvYBCfAACPEAC/AACvIACvMBAPgAAPkAAPgBAPkBAvgBAPoAAPoBA"
             "PsBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
             "AAAAAAAAAAAAAAAAAAAAAAAABkfAAadjeUxEEYnk8QBoLhUHCASJJCWLyiTiIZFG3lAoO4F4SiUwScywYCQQ8"
             "S"
             "cEEokCG06D8pA4mBUWCQoIBwIGGQQGBgUFQQA7"
                            options:0];
  }
  return data;
}

@end
