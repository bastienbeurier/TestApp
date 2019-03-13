import UIKit


// ----------------------------------
// MARK: Window
// ----------------------------------


class MidgarWindow: UIWindow {
    
    var screenDetectionTimer: Timer?
    var currentScreen = ""
    var eventBatch: [Event] = []
    var eventUploadTimer: Timer?
    let eventUploadService = EventUploadService()
    
    func stopMonitoring() {
        screenDetectionTimer?.invalidate()
    }
    
    func startMonitoring() {
        screenDetectionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (_) in
            print("detection pass")
            let currentScreen = UIApplication.topViewControllerDescription()
            
            if currentScreen != self.currentScreen {
                print("NEW SCREEN DETECTED: \(currentScreen)")
                self.currentScreen = currentScreen
                self.eventBatch.append(Event(screen: currentScreen))
            }
        })
        
        eventUploadTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in
            print("upload pass")
            if self.eventBatch.count > 0 {
                print("UPLOAD BATCH: \(self.eventBatch.count)")
                self.eventUploadService.uploadBatch(events: self.eventBatch)
                self.eventBatch = []
            }
        })
    }
}

// ----------------------------------
// MARK: EventUploadService
// ----------------------------------


class EventUploadService: NSObject {
    
    func uploadBatch(events: [Event]) {
        guard let request = createPostRequest(events: events) else { return }
        URLSession.shared.dataTask(with: request).resume() // TODO: retry if failed.
    }
    
    func createPostRequest(events: [Event]) -> URLRequest? {
        let parameters: [String: Any] = ["events": events.map { $0.toDict() }, "app_token": "abcdefghij"]
        guard let url = URL(string: "https://midgar-flask.herokuapp.com/api/events") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return nil
        }
        request.httpBody = body
        return request
    }
    
}

// ----------------------------------
// MARK: Event Model
// ----------------------------------

struct Event {
    
    let type: String
    let screen: String
    let timestamp: Int
    
    init(screen: String) {
        type = "impression"
        self.screen = screen
        timestamp = Date().timestamp
    }
    
    func toDict() -> [String: Any] {
        return ["type": type, "screen": screen, "timestamp": timestamp]
    }
    
}

// ----------------------------------
// MARK: Extensions
// ----------------------------------


extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    class func topViewControllerDescription() -> String {
        if let topVC = topViewController() {
            return "\(type(of: topVC))"
        } else {
            return ""
        }
    }
    
}

extension Date {
    
    var timestamp: Int {
        return Int(truncatingIfNeeded: Int64((self.timeIntervalSince1970 * 1000.0).rounded()))
    }
    
}
