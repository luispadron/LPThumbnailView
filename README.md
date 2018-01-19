## LPThumbnailView

![Banner](https://raw.githubusercontent.com/luispadron/LPThumbnailView/master/.github/banner.png)

<p align="center">
  <img src="https://raw.githubusercontent.com/luispadron/LPThumbnailView/master/.github/thumbnail.png">
</p>

<h3 align="center">A contextual image thumbnail view for iOS.</h3>

## Features

- Easy to use
- Sleek animations
- Customizeable
- Written in the latest Swift

## Requires

- iOS 10.0+

## Installation

### CocoaPods

1. Install [CocoaPods](https://cocoapods.org)
2. Add this repo to your `Podfile`

	```ruby
	target 'Example' do
	    # IMPORTANT: Make sure use_frameworks! is included at the top of the file
	    use_frameworks!
	    pod 'LPThumbnailView'
	end
	```
3. Run `pod install`
4. Open up the `.xcworkspace` that CocoaPods created
5. Done!

### Carthage

To use with [Carthage](https://github.com/Carthage/Carthage)

1. Make sure Carthage is installed 
	
	`brew install carthage`
2. Add this repo to your Cartfile

	`github "luispadron/LPThumbnailView"` 
3. Drag the `LPThumbnailView.framework` from `MyProjDir/Carthage/Builds/iOS/LPThumbnailView` into the `General -> Embeded Binaries` section of your Xcode project.

### Manually

1. Simply download the source files from [here](https://github.com/luispadron/LPThumbnailView/tree/master/luispadron) and drag them into your project.

## Usage

### Simple animation

```swift
// Pick your animation style
thumbnailView.animationStyle = .enterFromRight 
// Simply add an image to the thumbnail view, animation is handled for you!
thumbnailView.addImage(image)
```

![Demo gif 1](https://raw.githubusercontent.com/luispadron/LPThumbnailView/master/.github/animation1.gif)

### Contextual animation

```swift
// Create/use an existing image view you would like to be animated to the position of the thumbnail.
let imgView = UIImageView(image: someImage)
// Animation from imgView to thumbnail is handled for you!
// imgView will animate to the correct frame and will be removed from the super view on completion of animation.
thumbnailView.addImageWithContext(imgView)
```

<img src="https://raw.githubusercontent.com/luispadron/LPThumbnailView/master/.github/animation2.gif" alt="Demo gif 2" height="500" width="400">

## Documentation

Please read the docs [here](https://htmlpreview.github.io/?https://raw.githubusercontent.com/luispadron/LPThumbnailView/master/docs/Classes/LPThumbnailView.html) for more information and before posting an issue.

## Example Project

Take a look at the example project [here](https://github.com/luispadron/LPThumbnailView/tree/master/Example) 
