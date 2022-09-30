import Flutter
import UIKit
import CryptoSwift
import CryptoKit

public class SwiftM2pcarddetailsPlugin: NSObject, FlutterPlugin {

   var privateString : String?
   let privateKey = P256.KeyAgreement.PrivateKey()
   var publicString : String?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    
    
    let publicKey = privateKey.publicKey.x963Representation

    publicString = publicKey.toHexString().uppercased()
    privateString = privateKey.x963Representation.toHexString()
   
    batteryChannel.setMethodCallHandler({
  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
  // Note: this method is invoked on the UI thread.
    if call.method == "getPublicString" {
        // self?.getPublicString(result: result)
    }else if call.method == "getPrivateString" {
        // self?.getPrivateString(result: result)
    }else {
        result(FlutterMethodNotImplemented)
        return
      }
})

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func getPublicStrsing(result: FlutterResult) {
  
    result(publicString)
}
    
    private func getPrivateString(result: FlutterResult) {
   
    
    result(privateString)
}
}
