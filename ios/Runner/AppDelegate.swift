import Flutter
import UIKit
import CoreML
import Vision

func multiArrayToArray(_ multiArray: MLMultiArray) -> [Double] {
    return (0..<multiArray.count).map { multiArray[$0].doubleValue }
}

extension UIImage {
    // Resize image to model's input size
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    // Convert UIImage to CVPixelBuffer
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attributes: [NSObject: AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ]
        var pixelBuffer: CVPixelBuffer?
        let width = Int(self.size.width)
        let height = Int(self.size.height)

        CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                            kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)

        guard let buffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        let data = CVPixelBufferGetBaseAddress(buffer)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(origin: .zero, size: self.size))
        CVPixelBufferUnlockBaseAddress(buffer, .readOnly)

        return buffer
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
    var channel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        channel = FlutterMethodChannel(name: "com.example.food101", binaryMessenger: controller.binaryMessenger)
        
        channel?.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "predict" {
                guard let args = call.arguments as? [String: Any],
                      let imagePath = args["imagePath"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid image path", details: nil))
                    return
                }
                self?.predict(imagePath: imagePath, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func predict(imagePath: String, result: @escaping FlutterResult) {
        // Load CoreML model
        guard let model = try? MyModel(configuration: MLModelConfiguration()) else {
            result(FlutterError(code: "MODEL_LOADING_ERROR", message: "Failed to load model", details: nil))
            return
        }
        
        // Load the image
        guard let image = UIImage(contentsOfFile: imagePath),
              let resizedImage = image.resize(to: CGSize(width: 224, height: 224)),
              let pixelBuffer = resizedImage.toCVPixelBuffer() else {
            result(FlutterError(code: "IMAGE_ERROR", message: "Failed to process image", details: nil))
            return
        }
        
        // Perform prediction
        do {
            let prediction = try model.prediction(input_1: pixelBuffer)
            let probabilities = multiArrayToArray(prediction.linear_510) // Convert MLMultiArray to [Double]
            
            if let maxIndex = probabilities.indices.max(by: { probabilities[$0] < probabilities[$1] }) {
                let className = MyModelClasses.classes[maxIndex]
                let confidenceScore = probabilities[maxIndex]
                
                // Prepare result to send back to Flutter
                let resultData: [String: Any] = [
                    "className": className,
                    "confidenceScore": confidenceScore
                ]
                result(resultData)
            } else {
                result(FlutterError(code: "NO_RESULT", message: "Unable to determine a result", details: nil))
            }
        } catch {
            result(FlutterError(code: "PREDICTION_ERROR", message: "Prediction failed", details: error.localizedDescription))
        }
    }
}
