import Foundation

@objc public class StableDiffusion: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
