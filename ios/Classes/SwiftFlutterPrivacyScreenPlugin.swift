import Flutter
import UIKit

public class SwiftFlutterPrivacyScreenPlugin: NSObject, FlutterPlugin {
    
    static var enabled = true
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_privacy_screen", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPrivacyScreenPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Register events
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appResumed(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc static func appMovedToBackground(_ notification: Notification) {
        if enabled {
            let application: UIApplication = notification.object as! UIApplication
            let rootView: UIView! = application.keyWindow?.rootViewController?.view
            
            let containerView = UIView(frame: rootView.bounds)
            containerView.tag = 999 // Tag for removing view
            
            // Create gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = containerView.bounds
            gradientLayer.colors = [
                UIColor(red: 0.0, green: 190.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0).cgColor,
                UIColor(red: 1.0 / 255.0, green: 89.0 / 255.0, blue: 162.0 / 255.0, alpha: 1.0).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            containerView.layer.addSublayer(gradientLayer)
            
            // Create logo image
            let logoImage = UIImage(named: "Logo")
            let logoImageView = UIImageView(image: logoImage)
            logoImageView.contentMode = .center
            logoImageView.frame = containerView.bounds
            containerView.addSubview(logoImageView)
            
            rootView.addSubview(containerView)
        }
    }
    
    @objc static func appResumed(_ notification: Notification) {
        if enabled {
            let application: UIApplication = notification.object! as! UIApplication;
            if let viewToRemove = application.keyWindow?.rootViewController?.view.viewWithTag(999) {
                UIView.animate(withDuration: 0.1, animations: {
                    viewToRemove.alpha = 0
                }) { _ in
                    viewToRemove.removeFromSuperview()
                }
            }
        }
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "enablePrivacyScreen":
            SwiftFlutterPrivacyScreenPlugin.enabled = true
            result(true)
        case "disablePrivacyScreen":
            SwiftFlutterPrivacyScreenPlugin.enabled = false
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

// TODO (improvements):
// 1. Pass image and gradient as args
// 2. Use flutter images
