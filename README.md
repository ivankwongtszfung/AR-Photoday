# AR PhotoDay
AR PhotoDay is an iOS application for graduating students to take photos with virtual models. Users can add multiple models into the scene and take photos or videos. This application mainly uses ARKit and SceneKit for implementing Augmented Reality (AR) features.

AR PhotoDay is a course project for 2017/18 CSCI4140: Open-source Software Development, a Computer Science elective course in the Chinese University of Hong Kong (CUHK).

## Screenshots
![Screenshot 1](/readme/scr1.png)
![Screenshot 2](/readme/scr2.png)

## Getting Started
### Prerequisites
This product requires the following software and requirements:
* macOS
* Xcode 9.3 (or above)
* Real iOS device with A9+ processor and iOS 11 (or above)
* An Apple Developer account
* [**Cocoapods**](https://cocoapods.org/) 1.4.0 or above

### Installing & Opening Project
1. Clone the project repo: `git clone https://github.com/ivankwongtszfung/AR-Photoday.git`
1. Install dependencies via CocoaPod: `pod install`
1. Launch Xcode and open **AR-Photoday.xcworkspace**

### Building & Running Project
![Building Instructions Image](/readme/build1.png)
1. Select AR-Photoday project file from the Project Navigator
1. Switch to **General** tab
1. Add **your own Developer Account** from the **Team** menu in the **Signing** section
1. Select yourself as the **Development Team** in the **Team** menu
1. Set up your own **bundle identifier**
1. Wait for creating provisioning profile. Click **Try Again** button if it fails
1. Connect your own iOS device to the computer
1. Select your iOS device as the running device
1. Click the **play button** to run on the real device

## Features
Watch video demo on YouTube: https://www.youtube.com/watch?v=ewSYZtef2ZM

### Implemented Features
- [x] Plane detection
- [x] Adding and deleting preset models
- [x] Model transformation by gestures (pan translation, pinch scaling, rotation)
- [x] Model (preset) color configuration
- [x] Model (preset) texture configuration
- [x] App restart (resetting detections)
- [x] Photo taking and sharing
- [x] Photo editing by adding preset static stickers
- [x] Video recording and sharing

### Possible Future Directions
- [ ] Layout reorganization and unification
- [ ] Adding custom models by ID, with backend server support
- [ ] Custom model configuration
- [ ] Sticking two models
- [ ] Member system
- [ ] Gesture recognition enhancement (e.g. better detection, allowing multiple gestures at a time)

## Libraries and Resources
AR PhotoDay uses the following libraries and external files:
- [**ARKit**](https://developer.apple.com/arkit/) and [**SceneKit**](https://developer.apple.com/documentation/scenekit) for AR work
- [**Toast-Swift**](https://github.com/scalessec/Toast-Swift) for generating "Toast" messages
- [**ChromaColorPicker**](https://github.com/joncardasis/ChromaColorPicker) for model color selections

Texture pictures are retrieved from [**Apple sample project**](https://developer.apple.com/documentation/arkit/building_your_first_ar_experience) and Google Search results.

## Authors
This project is developed by four year-4 CUHK BSc(Computer Science) undergraduates, who are members of Group 7 in 2017/18 CSCI4140:

Author | GitHub Profiles
------ | ----------------
Lung Cho Kit | [**kitlung**](https://github.com/kitlung) / cklung5
Ivan Kwong | [**ivankwongtszfung**](https://github.com/ivankwongtszfung)
Ronald Chan | [**rdchc**](https://github.com/rdchc)
Vincent Au | [**vincentau**](https://github.com/vincentau) / [**auwingchun623**](https://github.com/auwingchun623)

## License
This project is licensed under the MIT License - see the [**LICENSE**](/LICENSE) file for details
