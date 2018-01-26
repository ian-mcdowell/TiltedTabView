# Tilted Tab View

This library aims to replicate the tab switcher in Safari on iOS. It handles both compact width (tilted) and regular width (grid) layouts.

![Screenshot](resources/Screenshot.png)
![Screenshot](resources/Screenshot_iPad.png)

## Installation

### Carthage
This library is available via [Carthage](https://github.com/Carthage/Carthage). To install, add the following to your Cartfile:
```
github IMcD23/TiltedTabView
```
### Submodule
You can also add this project as a git submodule.
```
git submodule add https://github.com/IMcD23/TiltedTabView path/to/TiltedTabView
```
Run the command above, then drag the `TiltedTabView.xcodeproj` into your Xcode project and add it as a build dependency.

### ibuild
A Swift static library of this project is also available for the ibuild build system. Learn more about ibuild [here](https://github.com/IMcD23/ibuild)

## Usage
The main class in this library is the `TiltedTabViewController`. It is a subclass of `UICollectionViewController`, that contains a custom collection view and layout.

To get started, you can either:
- Subclass `TiltedTabViewController`, and add your data providing implementations there.
- Instantiate a `TiltedTabViewController`, and add it as a child to your view controller.

The `TiltedTabViewController` has data source and delegate properties, similar to those of a UICollectionView.

Set an object that conforms to the `TiltedTabViewControllerDataSource` and `TiltedTabViewControllerDelegate` protocols as the `dataSource` and `delegate` properties, respectively.

Provide implementations for all required methods of each protocol, and you're off to the races.

## Example
Take a look at the [Sample App](Sample) for an example of the implementation.
