import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Prevent scene snapshotting errors
  override func applicationWillResignActive(_ application: UIApplication) {
    // Called when app is about to move from active to inactive
  }
  
  override func applicationDidEnterBackground(_ application: UIApplication) {
    // Called when app enters background
  }
}