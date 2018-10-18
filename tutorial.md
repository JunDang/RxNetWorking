# MVVM and NetWorking with RxSwift
In this tutorial, I will implement the networking request in RxSwift, fetch the picture from the Flickr API, process the JSON data and bind the picture to the UI. The topics will be covered include:
- Networking with RxSwift
- JSON data parsing with Swift 4 Codable.
- Implement MVVM design pattern
- Unit test with RxTest

## Project setup 
Launch Xcode 10 and Create a new project by choosing the Single View Application and name it as RxNetWorking. Set Language to Swift and devices to iPhone. Check Include Unit Tests and keep both Core Data and Include UI Tests unchecked. Now within the project navigator, you can see the RxNetWorking Target and RxNetWorkingTests Target. Be sure to make the iOS Deployment Target and Swift Language Version in the Building Settings for both the project target and the tests target the same. 
In the project navigator, choose the folder of RxNetWorking. In the Info.plist, add App Transport Security Settings and its subitem Allow Arbitrary Loads and set the value to YES.
#### Integrate the third libraries
The third libraries will be used include: 
#### RxSwift and RxCocoa
This is the language will be used for this project. For more information, refer to  [./ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift)
#### RxTest and RxBlocking
This will be used for test. For more information, refer to  [./ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift)
#### ReachabilitySwift
It will be used to detect if the network is reachable.
#### SwiftMessages
It will be used to display messages to the users.

I am going to use CocoaPods to install these third library. If not familiar with CocoaPods, refer to this link: https://cocoapods.org. In the terminal, under the project, create  podfile as [./podfile](https://github.com/JunDang/RxNetWorking/blob/master/podfile)

