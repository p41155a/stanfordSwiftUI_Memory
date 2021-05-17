스터디에서 stanford 유튜브의 SwiftUI강의를 듣고 실습한 내용입니다.

<img src="https://user-images.githubusercontent.com/50395024/108480033-cbf17200-72d9-11eb-99bd-c2a7537ec98b.gif" width="150">

아래는 강의 중 3강을 제가 맡아 발표를 하며 리드 했는데 그 내용중 일부입니다.



## **🍏 SwiftUI vs UIKit**

UIKit은 이벤트 기반(Event-Driven) 프레임워크입니다. 개발자는 View들이 불러와 지거나(viewDidLoad) View에서 어떤 이벤트가 발생할 경우 이벤트를 수령하여 View를 직접 업데이트 합니다. UIKit에서 **View는 이벤트들의 나열**을 통해서 표현됩니다. 그리고 이 이벤트를 수령하기 위해서 `UITableViewDelegate`와 같은 수많은 Delegate와 콜백함수, target-action이 필요했습니다.

반면, SwiftUI는 상태 기반(State-Driven) 프레임워크입니다. 개발자는 View의 Reference를 불러오거나 View를 임의로 수정할 수도 없습니다. SwiftUI에서 **View는 상태값(State)를 입력으로 하는 함수**로서 동작하게 됩니다.

```swift
struct HelloWorldView: View {   
    var body: some View {
				Text("Hello World")
    }
}
```

위의 코드와 같이 SwiftUI에서 모든 뷰는 `View`프로토콜을 conform하는 구조체로 선언되며, computed property인 `body`에서 리턴된 뷰를 표시해줍니다.

View가 상태(State)를 인풋으로하는 함수의 출력값이기 때문에 View의 내용을 변경하기 위한 유일한 방법은 입력값을 바꾸는것, 다시 말해 상태(State)를 수정하는 것 뿐입니다.

![https://media.vlpt.us/post-images/idevkang/bc27ce80-47cb-11ea-aa7b-57445856d949/image.png](https://media.vlpt.us/post-images/idevkang/bc27ce80-47cb-11ea-aa7b-57445856d949/image.png)

위의 도표와 같이 ViewController에서는 각종 이벤트들이 연속적으로 ViewController로 들어오고 ViewController는 개발자에게 ViewController가 관리하는 view에 직접 접근하여 UI를 수정하게 합니다.

![https://media.vlpt.us/post-images/idevkang/8935be90-47cd-11ea-bffc-4d95e29fbbb7/image.png](https://media.vlpt.us/post-images/idevkang/8935be90-47cd-11ea-bffc-4d95e29fbbb7/image.png)

반면, SwiftUI는 유저의 입력이나 각종 이벤트가(도표의 Action) 앱의 상태(State)를 바꾸고, 바뀐 상태값에 따라 변경된 View가 변경되는 단방향의 데이터 흐름을 가능하게 해줍니다.

이러한 단방향의 데이터 흐름을 가진 어플리케이션은 앱의 복잡도가 증가하여도 코드의 복잡도는 상대적으로 적게 증가하게 되며, 코드 유지보수를 한결 수월하게 만들어줍니다.



### **💃🏻 swiftUI의 특성**

- 구조체인 struct로 만들어짐

- 제네릭을 적극적으로 사용 (some View)

- 디자인 도구 - 기존에는 코드로 개발하느냐 스토리보드로 개발하느냐 선택을 해야했지만 이제는 간단한 코드로 UI를 그릴 수 있으며, 프리뷰를 통해 실행하지 않고 바로 바로 뷰로 확인 할 수 있다

- 모든 애플 플랫폼 지원

- 선언형

- 선언형 예시

  ```swift
  // 기존의 명령형 코드
  let button = UIButton(type: .system)
  button.setTitle("SwiftUI", for: .normal)
  button.setTitleColor(.black, for: .normal)
  button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
  button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
  view.addSubview(button)
  
  button.translatesAutoresizingMaskIntoConstraints = false
  NSLayoutConstraint.activate([
  button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
  button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
  ])
  
  @objc func buttonDidTap(_ sender: UIButton) {
  print("hello, swiftUI!")
  }
  ```

  ```swift
  import SwiftUI
  
  Button(action: {
      print("hello")
  }) {
      Text("SwiftUI")
          .font(.title)
          .foregroundColor(.black)
  }
  ```



<img src = "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f2f51f68-bab2-4788-b01a-b23a12d7d7c2/_2021-01-20__12.58.39.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210517%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210517T053958Z&X-Amz-Expires=86400&X-Amz-Signature=604ce680733bf47aadc35eb6f5e8093762cf7b5174eea8a010d8485b7a81c316&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22_2021-01-20__12.58.39.png%22" width=500>





## 🍏 Lecture 3: Reactive UI + Protocols + Layout

#### stack

스택(stack)은 swiftUI에서 뷰를 배치하는 데 사용하는 컨테이너 뷰로 콘텐츠로 전달된 자식 뷰들을 어떤 형태로 배치할 것인지 결정 짓습니다.

- HStack
- VStack
- ZStack

스택은 뷰 프로토콜을 준수하는 Content 를 제네릭 매개변수로 받아 자식 뷰로 표현하는 제네릭 구조체로 선언되어 있으며, 그 자신도 뷰 프로토콜을 채택하고 있습니다.



<img src="https://blogfiles.pstatic.net/MjAyMTA1MTdfMjA5/MDAxNjIxMjMwMjQ5OTAz.6IUX6GwdRkWka0c9e0jbC2UaOygYo-KiTRpkD9sdz3og.M_s-60fGEh5HnSaGWRwPKPK1sbdOC2ijrj7qrn0hlmgg.PNG.p41155a/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7_2021-05-17_%EC%98%A4%ED%9B%84_2.43.28.png?type=w1" width=550>

﻿

```swift
var body: some View { // 컴파일 오류 발생
    Text("Hello SwiftUI🙋🏻‍♀️")
    Text("Hello SwiftUI🙋🏻‍♀️")
}

var body: some View {
    VStack {
      Text("Hello SwiftUI🙋🏻‍♀️")
      Text("Hello SwiftUI🙋🏻‍♀️")
    }
}
```

body 프로퍼티에는 반드시 하나의 값만 반환해야하기 때문에 Stack을 잘 사용해야한다



<img src="https://blog.kakaocdn.net/dn/bBQjCv/btq41k2kp3d/rRG1nCvkkVRR8ewe3VR7h1/img.png" width=600>

생성자를 살펴보면 정렬(alignment), 간격(spacing), 콘텐츠(content) 3개의 매개변수를 받고 있음



#### spacer

뷰 사이의 간격을 설정하거나 뷰의 크기를 확장할 용도로 사용되는 레이아웃을 위한 뷰

부모 뷰가 제공하는 공간 내에서 가능한 최대의 크기로 확장됨

spacer은 아래와 같은 형태를 가짐

```swift
// Spacer의 형태
struct Spacer {
    public var minLength: CGFloat? //최소 간격 지정
    @inlinable public init(minLength: CGFloat? = nil) 
		// nil인 경우에는 시스템 기본 간격 사용
    public typealias Body = Never
}
extension Sapcer: View{}
```

<img src="https://blog.kakaocdn.net/dn/ntZgp/btq4ZSLNMDb/41hMqDcXPuHRfrckykxlk1/img.png" width=500>

#### Divider()

말 그대로 구분선

#### LayoutPriority()

<img src="https://blog.kakaocdn.net/dn/8uC5M/btq40RFtrfW/M6r3cv2KKekteNCPJkFF91/img.png" width=500>



## 🍏 추가 설명

### swiftUI는 순서가 중요

```swift
VStack {
  Text("SwiftUI")
    .font(.title)   // Text
    .bold()         // Text
    .padding()      // View
  Text("SwiftUI")
    .bold()         // Text
    .padding()      // View
    .font(.title)   // View
  Text("SwiftUI")
    .padding()      // View
    .font(.title)   // View
    .bold()         // 컴파일 오류
}
```

- 출력 UI는 위에 두개 다 같음 하지만 반환 타입이 달라 조심해야함

```swift
Image("apple") // Image
  .resizable()
  .frame(width: 50, height: 50) // View
Image("apple")
  .frame(width: 50, height: 50)
  .resizable() // 이미지에서만 사용 가능한 수식어로 오류
```



ex)

<img src="https://blog.kakaocdn.net/dn/ojJiK/btq4ZSE1sl4/lLc8frPwB1MXhsfvwwdwC1/img.png" width=500>



### 참고

SwiftUI 의 수식어는 뷰를 직접 변경하는 것이 아니라 원래의 뷰를 수식하는 새로운 뷰를 반환 액자에 콘텐츠를 넣은 형식이라고 이해하면 쉽습니다.

그래서 color를 밖에다 설정해주면 하위 아이들도 다 같이 적용되는 구나 등등...

<img src="https://blog.kakaocdn.net/dn/NoZ0O/btq5acVNl5y/mjkO1g9XTH9EL3SRom5Qn1/img.png" width=500>

