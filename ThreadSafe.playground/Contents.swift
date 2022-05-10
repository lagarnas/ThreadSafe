import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
// Prevent race condition
class ThreadSafeString {
    
    private var internalString = ""
    private let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    var string: String {
        get {
            var result = ""
            // чтения могут делаться параллельно с разных потоков
            queue.sync {
                result = internalString
            }
            return result
        }
        
        set {
            // запись может быть только одна в одно время, разные потоки не смогут записать новые данные
            queue.async(flags: .barrier) { self.internalString = newValue }
        }
    }
    
    func addString(_ string: String) {
        queue.async(flags: .barrier) { self.internalString += string }
    }
}
