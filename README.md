# Flourish

## Purpose

Flourish makes it easy to provide complex motion design transitions
to your game or game-like app. While SwiftUI transitions work well
to animate the appearance and disappearance of single elements,
Flourish makes it easy to animate deep subview transitions
and even build multi-step transition sequences.

⚠️ **Please use Flourish responsibly.**
If your app is not a game, or game-like in design, the elaborate transitions
enabled by Flourish may be more likely to annoy your users than delight them.

## Usage

To create a minimal Flourish setup:
- use the `flourishWhen` modifier to create a Flourish Group, bound to a boolean to determine the view's visibility
- use the `flourish` modifier to define animations for the group's children

```swift
VStack {
    Circle().flourish(Scale())
}
.flourishWhen(isOn)
```
![](https://dl.dropboxusercontent.com/s/kll54oz7nbievkh/flourish-minimal.gif)

Flourish will manage the lifecycle of the host view, keeping it alive until
all descendant animations are finished.

At this point, the Flourish animation is accomplishing no more than
SwiftUI's `.transition(.opacity)` modifier.

The real fun lies in animating multiple levels of the view hierarchy
and constructing animation sequences.

```swift
VStack {
    ForEach(0..<5) { rowIndex in
        
        HStack {
            ForEach(0..<5) { columnIndex in
                
                Circle().flourishSequence {
                    Parallel(.ease(1.5, intensity: 0.8)) {
                        TranslateX(50)
                        Opacity()
                    }
                    Scale(0.5, .ease())
                }
                .delayWither(0.1 * Double(columnIndex))
            }
        }
        .delayFlourish(0.1 * Double(rowIndex))
    }
}
.flourishWhen(isOn)
```
![](https://dl.dropboxusercontent.com/s/lnzahb7a78yq4r0/flourish-complex.gif)

Complex animations can be built with very little effort using Flourish's small
but highly composable library of animation types and view modifiers.

The `flourish` and `flourishSequence` modifiers accept a `FlourishAnimation`
struct and use a custom content builder to enable familiar SwiftUI-like
composition of animation sequences.

All `FlourishAnimation`s also support timing curve adjustment, and are easy
to tweak with convenience initializers like `.ease(duration, intensity)`.

The `delayFlourish` and `delayWither` make it simple to delay all descendants
of some view in the hierarchy with no need for awareness of those contents.
