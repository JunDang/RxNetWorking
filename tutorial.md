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

I am going to use CocoaPods to install these third library. If not familiar with CocoaPods, refer to this link: https://cocoapods.org. In the terminal, under the project, create a [./podfile](https://github.com/JunDang/RxNetWorking/blob/master/podfile) and install the podfile. At the same time, create a [./gitignore](https://github.com/JunDang/RxNetWorking/blob/master/.gitignore)so that we can ignore some files when push the project up to the GitHub.
## Implement  the MVVM design pattern
MVVM design pattern has many advantages over MVC pattern and many articles have described these detailedly. For example, refer to this article from https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm.
So in this tutorial, I will mainly focus on how to implement the project by following the MVVM design pattern. Now let’s work with the model layer.
### Model layer
Open the RxNetWorking.xcworkspace file, under the RxNetWorking, create a new group named Model, and within the Model group, create a new swift file named FlickrPhotos.swift. Click to open the swift file. 
To fetch a photo, we firstly send a request to the Flickr API and obtain a list of image URLs. Then via the image URLs, we obtain the images. Let’s take a look at the JSON response from the Flickr API. The JSON has a root element “photos”. Inside “photos”, there is a next level root element “photo” which is an array of photos, as shown below. 
```
{
"photos": {
"page": 1,
"pages": 10,
"perpage": 25,
"total": "246",
"photo": [
{
"id": "21582914405",
"owner": "42922649@N00",
"secret": "3c4875cc7e",
"server": "683",
"farm": 1,
"title": "Stand Tall",
"ispublic": 1,
"isfriend": 0,
"isfamily": 0
},
{
"id": "21530307402",
"owner": "43246590@N06",
"secret": "d644667c02",
"server": "5694",
"farm": 6,
"title": "Sunflowers before the storm",
"ispublic": 1,
"isfriend": 0,
"isfamily": 0
},
{
"id": "18879744526",
"owner": "20286982@N07",
"secret": "696139cdbe",
"server": "5511",
"farm": 6,
"title": "Golden Plains",
"ispublic": 1,
"isfriend": 0,
"isfamily": 0
}
]
},
"stat": "ok"
}
```
 Here is the [./Model](https://github.com/JunDang/RxNetWorking/blob/master/RxNetWorking/Model/FlickrPhotos.swift).
 Firstly create a struct named FlickrPhoto to represent the single photo and let it conform to the Codable protocol. We need the variables of farm, server, id and secret to construct the image url.  Let’s put these variables in the struct, and write the corresponding CodingKeys so that the items can be found when being decoded.  Then implement the init(farm: Int, id: String, server: String, secrect: String) and  init(from decoder: Decoder) methods. We also need construct the image URL with those parameters. So let’s implement the function creatImageURL() which has a return type of NSURL. 
 Secondly, create a struct named FlickrPhotos to hold the array of FlickrPhoto and let it conform to the Codable protocol. The CodingKey for finding the item is “photo”.   
 Finally, move to the root element “photos”and create a struct named FlickrModel which holds FlickrPhotos. And the key for finding this element is “photos”. 
 ### Networking
 Create a new group named Services under the RxNetWorking. Create a new swift file under this group and name it as InternetService. Import RxSwift and RxCocoa. Create an enumeration Result<T, Error> as the generic return type of networking request, see below. For the networking request from REST APIs, I choose to use the Apples’s URLSession because it is powerful and always updated simultaneously with the newest Swift versions. Now, let’s make URLSession reactive. Write a class InternetService, then write a static private function request which takes two parameters: a string of base url from the REST APIs and a dictionary of parameters which wii be the url components. And the function will return an Observable of Result<Data, Error>.  The function is implemented as below:
```
static private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Observable<Result<Data, Error>> {
//1
   let defaultSession = URLSession(configuration: .default)
   var dataTask: URLSessionDataTask?
//2
return Observable.create { observer in
var components = URLComponents(string: baseURL)!
components.queryItems = parameters.map(URLQueryItem.init)
let url = components.url!
var result: Result<Data, Error>?
dataTask = defaultSession.dataTask(with: url) { data, response, error in
if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
result = Result<Data, Error>.Success(data)
} else {
if let error = error {
result = Result<Data, Error>.Failure(error)
}
}
observer.onNext(result!)
observer.onCompleted()
}
dataTask?.resume()
//3
return Disposables.create {
dataTask?.cancel()
}
}
}

```



