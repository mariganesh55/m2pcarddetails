import UIKit
import Flutter
import CryptoKit
import CryptoSwift
import SwCrypt
import Alamofire

//@available(iOS 13.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var privateKeyString : String?
    //let privateKey = P256.KeyAgreement.PrivateKey()
    var publicLocalString : String?
    //var sharedSecret : SharedSecret!
    
    
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    
    
    //let publicKey = privateKey.publicKey.x963Representation
      
      let keys = try? CC.EC.generateKeyPair(256)
      self.privateKeyString = keys!.0.toHexString().uppercased()
      let pubKey = try? CC.EC.getPublicKeyFromPrivateKey(keys!.0)
      self.publicLocalString = pubKey?.toHexString().uppercased()
      
      let encryptedPublicString = self.publicLocalString?.aes_Encrypt(AES_KEY: Array(DEVICEID?.utf8 ?? "".utf8) as [UInt8])
      let encryptedPrivateString = self.privateKeyString?.aes_Encrypt(AES_KEY: Array(DEVICEID?.utf8 ?? "".utf8) as [UInt8])
      

//    publicString = pubKey?.toHexString().uppercased()
//    privateString = privateKey.x963Representation.toHexString()
   
    batteryChannel.setMethodCallHandler({
  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
  // Note: this method is invoked on the UI thread.
    
    
    if call.method == "getPublicString" {
        self?.getPublicString(result: result)
    }else if call.method == "getPrivateString" {
        self?.getPrivateString(result: result)
    }else if call.method == "getDeviceId" {
        self?.getDeviceId(result: result)
    }else if call.method == "getSecretString" {
        self?.getSecretKeyString(result: result,argument:call.arguments as! String)
    }else if call.method == "getCardDetail" {
        guard let args = call.arguments as? [String : Any] else {return}
        let detailMessage = args["detailMessage"] as! String
        let serverPublicKey = args["serverPublicKey"] as! String
        self?.getcardDetailString(result: result,argument:detailMessage)
    }else {
        result(FlutterMethodNotImplemented)
        return
      }
})

      GeneratedPluginRegistrant.register(with: self)
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func getPublicString(result: FlutterResult) {
    result(publicLocalString)
}
    
    private func getPrivateString(result: FlutterResult) {
    result(privateKeyString)
}
    
    private func getDeviceId(result: FlutterResult) {
    result(DEVICEID)
}

 private func getSecretKeyString(result: FlutterResult,argument:String) {
   
//     let recievedPublickey = try! P256.KeyAgreement.PublicKey.init(x963Representation: stringToBytes(argument as! String)!)
//      sharedSecret = try! self.privateKey.sharedSecretFromKeyAgreement(
//                    with: recievedPublickey)
//     let sharedString = sharedSecret.withUnsafeBytes(Array.init).toHexString()
//
//     result(sharedString)

}

private func getcardDetailString(result: FlutterResult,argument:String) {
   
//     let decryptedResult = argument.aes_Decrypt(AES_KEY: sharedSecret.withUnsafeBytes(Array.init))
//
//     result(decryptedResult)

}

func stringToBytes(_ string: String) -> [UInt8]? {
    let length = string.count
    if length & 1 != 0 {
        return nil
    }
    var bytes = [UInt8]()
    bytes.reserveCapacity(length/2)
    var index = string.startIndex
    for _ in 0..<length/2 {
        let nextIndex = string.index(index, offsetBy: 2)
        if let b = UInt8(string[index..<nextIndex], radix: 16) {
            bytes.append(b)
        } else {
            return nil
        }
        index = nextIndex
    }
    return bytes
}
}

extension String {
        // encrypt the string
        func aes_Encrypt(AES_KEY: [UInt8]) -> String {
            var result = ""
            do {
                let iv  :[UInt8] = Array(repeating: UInt8(0), count: 16)
                let aes = try! AES(key: AES_KEY, blockMode: CBC(iv: iv) as BlockMode, padding: .pkcs7)
                let encrypted = try aes.encrypt(Array(self.utf8))
                result = encrypted.toBase64() ?? ""
            } catch {
                print("Error: \(error)")
            }
            return result
        }

        // decrypt the string
        func aes_Decrypt(AES_KEY: [UInt8]) -> String {
            var result = ""
            do {
                let encrypted = self
                let iv  :[UInt8] = Array(repeating: UInt8(0), count: 16)
                let aes = try! AES(key: AES_KEY, blockMode: CBC(iv: iv) as BlockMode, padding: .pkcs7)
                let decrypted = try aes.decrypt(Array(base64: encrypted))
                result = String(data: Data(decrypted), encoding: .utf8) ?? ""
            } catch {
                print("Error: \(error)")
            }
            return result
        }

}

extension Data {
  public init(hex: String) {
    self.init(Array<UInt8>(hex: hex))
  }

  public var bytes: Array<UInt8> {
    Array(self)
  }

  public func toHexString() -> String {
    self.bytes.toHexString()
  }
}

extension Array where Element == UInt8 {
  public init(hex: String) {
    self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
    var buffer: UInt8?
    var skip = hex.hasPrefix("0x") ? 2 : 0
    for char in hex.unicodeScalars.lazy {
      guard skip == 0 else {
        skip -= 1
        continue
      }
      guard char.value >= 48 && char.value <= 102 else {
        removeAll()
        return
      }
      let v: UInt8
      let c: UInt8 = UInt8(char.value)
      switch c {
        case let c where c <= 57:
          v = c - 48
        case let c where c >= 65 && c <= 70:
          v = c - 55
        case let c where c >= 97:
          v = c - 87
        default:
          removeAll()
          return
      }
      if let b = buffer {
        append(b << 4 | v)
        buffer = nil
      } else {
        buffer = v
      }
    }
    if let b = buffer {
      append(b)
    }
  }

  public func toHexString() -> String {
    `lazy`.reduce(into: "") {
      var s = String($1, radix: 16)
      if s.count == 1 {
        s = "0" + s
      }
      $0 += s
    }
  }
}

extension Array {
  init(reserveCapacity: Int) {
    self = Array<Element>()
    self.reserveCapacity(reserveCapacity)
  }

  var slice: ArraySlice<Element> {
    self[self.startIndex ..< self.endIndex]
  }
}




