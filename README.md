# SwiftQueue
A queue manager, based on OperationQueue. 

[![License](https://img.shields.io/cocoapods/l/SwiftQueue.svg?style=flat)](http://cocoapods.org/pods/SwiftQueue)

Usage
=====

### Shared Queue

```swift
let queue = SwiftQueue.shared
```

### Custom Queue

```swift
let queue = SwiftQueue(name: "QueueName")
```
> Or

```swift
let queue = Queuer(name: "QueueName", maxConcurrentOperationCount: Int.max)
```

### Create an Operation Block

- Directly on the `queue`:

    ```swift
    queue.addOperation {
        /// Your task here
    }
    ```

- Creating a `SwiftOperation` with a block:

    ```swift
    let operation = SwiftOperation {
        /// Your task here
    }
    queue.addOperation(operation)
    ```

### Chained Operations
Chained Operations are operations that add a dependency each other.<br>
For example: `[A, B, C] = A -> B -> C -> completionBlock`.

```swift
let operation1 = SwiftOperation {
    /// Your task 1 here
}
let operation2 = SwiftOperation {
    /// Your task 2 here
}
queue.addChainedOperations([operation1, operation2]) {
    /// Your completion task here
}
```

### Queue States
- Cancel all operations in queue:

    ```swift
    queue.cancelAll()
    ```
- Pause queue:

    ```swift
    queue.pause()
    ```
    > By calling `pause()` you will not be sure that every operation will be paused.
      If the Operation is already started it will not be on pause.

- Resume queue:

    ```swift
    queue.resume()
    ```
    > To have a complete `pause` and `resume` states you must create a custom Operation that overrides `pause()` and `resume()` function.

- Wait until all operations are finished:

    ```swift
    queue.waitUntilAllOperationsAreFinished()
    ```
    > This function means that the queue will blocks the current thread until all operations are finished.

## Author

CatchZeng, 891793848@qq.com

## License

SwiftQueue is available under the MIT license. See the LICENSE file for more info.
