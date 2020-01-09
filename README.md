# TerminalKit
‘TerminalKit’ makes it easy to process scripts. ‘TerminalKit’ is a class using Process. The easy callback function allows you to process tasks when scripts are running and when they are complete.

## Installation
<b>CocoaPods:</b>
<pre>
pod 'TerminalKit'
</pre>
<b>Manual:</b>
<pre>
Copy <i>TerminalKit.swift</i> to your project.
</pre>

<b>Swift Package Manager:</b>

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `TerminalKit` by adding the proper description to your `Package.swift` file:

```swift

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/bugkingK/TerminalKit.git", from: "1.0.1"),
    ]
)
```
Then run `swift build` whenever you get prepared.


## Using TerminalKit
```swift
// When checking the script for completion only.
TerminalKit("ls -al").launch { (ter) in
    if let output = ter.output {
        print(output)
    }

    if let errput = ter.errput {
        print(errput)
    }

    print(ter.paragraph)
    print("end")
}

// When you want to track a script,
TerminalKit("ls -al").launch(onRunning: { ter in
    // When the script is working
}) { ter in
    // When the script is complete
}

// You want to run multiple scripts.
TerminalKit(["ls -al", "ls -al", "ls -al"]).launch { ter in
    // When the script is complete
}
```

## License

<i>TerminalKit</i> is available under the MIT license. See the LICENSE file for more info.
