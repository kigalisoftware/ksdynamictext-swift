<img src="https://github.com/kigalisoftware/ksdynamictext-swift/assets/44855831/53853ba6-35c3-444a-b748-2b9c7e4a16a7" width=500>

# KSDynamicText

KSDynamicText is a Swift framework that allows UILabels, UIButtons, and UITextViews to display text token by token, similar to the way ChatGPT outputs its generated text.

---

<br>

## Table Of Content

- [Installation](#installation)
  <br>

- [How It Works](#how-it-works)
  * [KSDynamicLabel](#KSDynamicLabel)
  * [Custom Components](#custom-components)
  * [Delegates](#delegates)
  * [Token Update Policies](#token-update-policies)
  * [KSRotatingLabel](#KSRotatingLabel)
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

> **Note:** The `startUpdates()` method is required to start the label updates. Make sure to call this method after setting up the `baseText`.

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

> **Recommendation:** In this example, `proxyText` is set to the text you want to update dynamically in the `didSet` block. We **strongly recommend** using the `didSet` block to update text dynamically.

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
  <br>

- `resetThenAddReverse`: This policy will reset the label, but tokens are added from back to front.
  <br>

- `deleteThenAdd`: With this policy, tokens are deleted one by one until the previous baseText prefix and the new baseText prefix match. Then the remaining tokens of the new baseText are added token by token.
  <br>

    <img src="https://github.com/kigalisoftware/ksdynamictext-swift/assets/44855831/c7ac9ca8-a66a-4c01-83cb-e74321feb446" width=500>
    
    
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

<br>

### KSRotatingLabel
<img src="https://github.com/kigalisoftware/ksdynamictext-swift/assets/44855831/bcaa4ed5-c169-41e3-9d52-55d359427592" width=500>

<br>

`KSRotatingLabel` is a special kind of `KSDynamicLabel` that rotates between a list of given texts. The number of labels, the text of each label, and the update interval are provided through a data source that conforms to the `GTRotatingLabelDataSource` protocol.

Here's a basic example of how to use `KSRotatingLabel`:

```swift
class MyDataSource: KSRotatingLabelDataSource {
    func numberOfLabels(for rotatingLabel: KSRotatingLabel) -> Int {
        return 3
    }

    func rotatingLabel(_ rotatingLabel: KSRotatingLabel, labelForIndex index: Int) -> String? {
        switch index {
        case 0:
            return "First Label"
        case 1:
            return "Second Label"
        case 2:
            return "Third Label"
        default:
            return nil
        }
    }

    func updatesTimeInterval(for rotatingLabel: KSRotatingLabel) -> TimeInterval {
        return 2.0
    }
}

let myDataSource = MyDataSource()
let rotatingLabel = KSRotatingLabel()
rotatingLabel.dataSource = myDataSource
rotatingLabel.startRotations() // This will start the label rotations
```

<br>

To stop the rotations at any point, call the stopRotations() method:

```swift
rotatingLabel.stopRotations()
```

> **Note:** Make sure your data source provides a valid number of labels and labels for each index, and set a reasonable time interval for updates.

<br>
