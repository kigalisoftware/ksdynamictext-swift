<img src="https://jaysack-github-readme.s3.us-east-2.amazonaws.com/jsconstraints/jsconstraints-example.png">

# KSDynamicText

KSDynamicText is a Swift framework that allows UILabels, UIButtons, and UITextViews to display text token by token, similar to the way ChatGPT outputs its generated text.

---

<br>

## Table Of Content

- [Installation](#-installation)
  <br>

- [How It Works](#-how-it-works)
  _ [KSDynamicLabel](#KSDynamicLabel)
  _ [Custom Components](#custom-components)
  _ [Delegates](#delegates)
  _ [Token Update Policies](#token-update-policies)
  <br>

---

<br>

## Installation

You can install KSDynamicText via Swift Package Manager by adding the following to your Package.swift file's dependencies:

```swift
.package(url: "https://github.com/kigalisoftware/ksdynamictext-swift.git", .upToNextMajor(from: "1.0.0"))
```

---

<br>
## How It Works

### KSDynamicLabel

`KSDynamicLabel` is a ready-to-go UILabel with token-by-token display capability. If more customization is needed, `KSTokenByTokenDisplayable` can be applied to any UILabel, UIButton, or UITextView.

Here's a basic example of how to use KSDynamicLabel:

```swift
import KSDynamicText

let label = KSDynamicLabel()

label.baseText = "Hello, world!"
label.startUpdates() // This will start label updates
```

<br>

### Custom Components

You can also use KSTokenByTokenDisplayable with your own custom classes:

```swift
class CustomButton: UIButton, KSTokenByTokenDisplayable {

    // Init methods
    // ...

    var tokenDelegate: KSTokenByTokenDisplayableDelegate?
    var tokenConfiguration: KSTokenConfiguration
    var isActive: Bool
    var timer: Timer?
    var baseText: String?
    var proxyText: String? {
        didSet {
            setTitle(proxyText, for: .normal)
        }
    }
}
```

In this example, `proxyText` is set to the text you want to update dynamically in the `didSet` block.
**We strongly recommend using the `didSet` block to update text dynamically.**
<br>

### Delegates

You can implement the `KSTokenByTokenDisplayableDelegate` protocol to receive a callback when the label has finished rendering its text:

```swift
class MyDelegate: KSTokenByTokenDisplayableDelegate {
    func tokenRenderableDidFinishRendering(_ tokenRenderable: KSTokenByTokenDisplayable) {
        print("Finished rendering text!")
    }
}

let myDelegate = MyDelegate()
label.tokenDelegate = myDelegate
```

<br>

### Token Update Policies

The `KSTokenConfiguration` struct includes an `UpdatePolicy` enum that defines how tokens are updated when the base text changes. It offers three options:

- `resetThenAdd`: This policy will reset the label and then add tokens back one by one. This is the default update policy.
  <img src="https://jaysack-github-readme.s3.us-east-2.amazonaws.com/jsconstraints/jsconstraints-example.png">
  <br>

- `resetThenAddReverse`: This policy will reset the label, but tokens are added from back to front.
  <img src="https://jaysack-github-readme.s3.us-east-2.amazonaws.com/jsconstraints/jsconstraints-example.png">
  <br>

- `deleteThenAdd`: With this policy, tokens are deleted one by one until the previous baseText prefix and the new baseText prefix match. Then the remaining tokens of the new baseText are added token by token.
  <img src="https://jaysack-github-readme.s3.us-east-2.amazonaws.com/jsconstraints/jsconstraints-example.png">
  <br>

Here's an example of using `deleteThenAdd` policy:

```swift
let label = KSDynamicLabel()
label.tokenConfiguration = KSTokenConfiguration(
    tokenLength: 1...2,
    tokenFrequency: 28,
    tokenUpdatePolicy: .deleteThenAdd
)
```
