//
//  RunloopOptimize.swift
//  Wintersweet
//
//  Created by Condy on 2023/3/6.
//

import Foundation

/// Perform some operations when the current runloop is idle.
public class RunloopOptimize: NSObject {
    
    public typealias Task = @convention(block) (_ oneself: RunloopOptimize) -> ()
    
    /// The current thread is processed when it is idle.
    public static let `default` = RunloopOptimize(main: false)
    /// The main thread is processed when it is idle.
    public static let `main` = RunloopOptimize(main: true)
    
    private lazy var dispatchedTasks = [Task]()
    
    private init(main: Bool) {
        super.init()
        commonInit(main: main)
    }
}

extension RunloopOptimize {
    
    /// Executes task when main or current runloop is before waiting.
    ///
    /// Example:
    ///
    ///     RunloopOptimize.default.commit {
    ///         // do smothing.
    ///     }
    ///
    /// - Parameter task: Things to deal with.
    public func commit(task: @escaping Task) {
        objc_sync_enter(self)
        dispatchedTasks.append(task)
        objc_sync_exit(self)
    }
    
    /// Removes all commited tasks, note that task may execute already.
    public func removeAllTasks() {
        objc_sync_enter(self)
        dispatchedTasks.removeAll(keepingCapacity: true)
        objc_sync_exit(self)
    }
}

extension RunloopOptimize {
    private func commonInit(main: Bool) {
        let activity = CFRunLoopActivity.beforeWaiting.rawValue
        // after CATransaction
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, activity, true, 0xFFFFFF) { (_, _) in
            objc_sync_enter(self)
            var tasks = self.dispatchedTasks
            self.removeAllTasks()
            objc_sync_exit(self)
            let thread = main ? Thread.main : Thread.current
            let modes = [RunLoop.Mode.default.rawValue]
            while tasks.isEmpty == false {
                let task = tasks.removeFirst()
                // 以source0分解到runloop
                self.perform(#selector(self.invokeTask), on: thread, with: task, waitUntilDone: false, modes: modes)
            }
        }
        let runloop = main ? CFRunLoopGetMain() : CFRunLoopGetCurrent()
        CFRunLoopAddObserver(runloop, observer, .defaultMode)
    }
    
    @objc private func invokeTask(_ task: Task) {
        task(self)
    }
}
