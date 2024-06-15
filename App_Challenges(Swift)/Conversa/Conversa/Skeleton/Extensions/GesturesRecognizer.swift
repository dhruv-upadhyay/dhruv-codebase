//
//  GesturesRecognizer.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import UIKit

extension UIGestureRecognizer {
    
    private func addEventHandlerInternal(_ runnable: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> RemovableTarget {
        class Target: RemovableTarget {
            private weak var recognizer: UIGestureRecognizer?
            private var runnable: (_ recognizer: UIGestureRecognizer) -> Void
            
            init(recognizer: UIGestureRecognizer, runnable: @escaping (_ recognizer: UIGestureRecognizer) -> Void) {
                self.recognizer = recognizer
                self.runnable = runnable
                self.retain()
            }
            
            @objc
            func run(_ recognizer: UIGestureRecognizer) {
                runnable(recognizer)
            }
            
            func remove() {
                recognizer?.removeTarget(self, action: #selector(Target.run(_:)))
                recognizer?.removeObject(key: self.address())
            }
            
            private func retain() {
                recognizer?.setObject(object: self, key: self.address(), policy: .OBJC_ASSOCIATION_RETAIN)
            }
            
            private func address() -> String {
                return String(format: "%p", Unmanaged.passUnretained(self).toOpaque().hashValue)
            }
        }
        
        let target = Target(recognizer: self, runnable: runnable)
        self.addTarget(target, action: #selector(Target.run(_:)))
        return target
    }
    
    @discardableResult
    func addEventHandler<T>(_ runnable: @escaping (_ recognizer: T) -> Void) -> RemovableTarget where T: UIGestureRecognizer {
        
        return self.addEventHandlerInternal { recognizer in
            if let recognizer = recognizer as? T {
                runnable(recognizer)
            }
        }
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString(string: label.text ?? ""))
      
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

       
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
