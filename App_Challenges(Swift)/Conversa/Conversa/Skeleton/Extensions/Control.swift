//
//  Control.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import UIKit

protocol RemovableTarget {
    func remove()
}

extension UIControl {
    
    private func addEventHandlerInternal(_ event: UIControl.Event, runnable: @escaping (_ control: UIControl) -> Void) -> RemovableTarget {
        class Target: RemovableTarget {
            private var event: UIControl.Event
            private weak var control: UIControl?
            private var runnable: (_ control: UIControl) -> Void
            
            init(event: UIControl.Event, control: UIControl, runnable: @escaping (_ control: UIControl) -> Void) {
                self.event = event
                self.control = control
                self.runnable = runnable
                self.retain()
            }
            
            @objc
            func run(_ control: UIControl) {
                runnable(control)
            }
            
            func remove() {
                control?.removeTarget(self, action: #selector(Target.run(_:)), for: self.event)
                control?.removeObject(key: self.address())
            }
            
            private func retain() {
                control?.setObject(object: self, key: self.address(), policy: .OBJC_ASSOCIATION_RETAIN)
            }
            
            private func address() -> String {
                return String(format: "%p", Unmanaged.passUnretained(self).toOpaque().hashValue)
            }
        }
        
        let target = Target(event: event, control: self, runnable: runnable)
        self.addTarget(target, action: #selector(Target.run(_:)), for: event)
        return target
    }
    
    @discardableResult
    func addEventHandler<T>(_ event: UIControl.Event, runnable: @escaping (_ control: T) -> Void) -> RemovableTarget where T: UIControl {
        
        return self.addEventHandlerInternal(event) { control in
            if let control = control as? T {
                runnable(control)
            }
        }
    }
}

