import RxSwift

let disposeBag = DisposeBag()

/*------------------------------------------------------------------
  시퀀스 간의 결합
 -------------------------------------------------------------------*/

print("----------startWith----------")
// 초기값 넣어줄 때
let 노랑반 = Observable<String>.of("👧🏼", "🧒🏻", "👦🏽")
노랑반
//    .enumerated()
//    .map {
//        $0.element + "어린이" + "\($0.index)"
//    }
    .startWith("👨🏻선생님") // 무조건 Observable 값과 타입 동일하게, 구독 전에 어느 위치에서나 사용 가능
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//👨🏻선생님
//👧🏼
//🧒🏻
//👦🏽




print("----------concat1----------")
let 노랑반어린이들 = Observable.of("👧🏼", "🧒🏻", "👦🏽")
let 선생님 = Observable.of("👨🏻")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반어린이들])
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//👨🏻
//👧🏼
//🧒🏻
//👦🏽

print("----------concat2----------")
선생님
    .concat(노랑반어린이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//👨🏻
//👧🏼
//🧒🏻
//👦🏽





print("----------concatMap----------")
let 어린이집 = [
    "노랑반": Observable.of("👧🏼", "🧒🏻", "👦🏽"),
    "파랑반": Observable.of("👶🏾", "👶🏻")
]

Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//👧🏼
//🧒🏻
//👦🏽
//👶🏾
//👶🏻





print("----------merge1----------")
// 순서를 보장하지 않음
let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
    })
    .disposed(by: disposeBag)
//서울특별시의 구: 강북구
//서울특별시의 구: 성북구
//서울특별시의 구: 강남구
//서울특별시의 구: 동대문구
//서울특별시의 구: 강동구
//서울특별시의 구: 종로구
//서울특별시의 구: 영등포구
//서울특별시의 구: 양천구

print("----------merge2----------")
Observable.of(강남, 강북)
    .merge(maxConcurrent: 1)
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
    })
    .disposed(by: disposeBag)
//서울특별시의 구: 강남구
//서울특별시의 구: 강동구
//서울특별시의 구: 영등포구
//서울특별시의 구: 양천구
//서울특별시의 구: 강북구
//서울특별시의 구: 성북구
//서울특별시의 구: 동대문구
//서울특별시의 구: 종로구




print("----------combineLatest1----------")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()
//가장 마지막 성 + 가장 마지막 이름
let 성명 = Observable.combineLatest(성, 이름) { 성, 이름 in
    성 + 이름
}

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("김")
이름.onNext("똘똘")
이름.onNext("영수")
이름.onNext("은영")
성.onNext("박")
성.onNext("이")
성.onNext("조")
//김똘똘
//김영수
//김은영
//박은영
//이은영
//조은영

print("----------combineLatest2----------")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        }
    )

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//1/31/23
//January 31, 2023

print("----------combineLatest3----------")
let lastName = PublishSubject<String>()     //성
let firstName = PublishSubject<String>()    //이름

let fullName = Observable.combineLatest([firstName, lastName]) { name in
    name.joined(separator: " ")
}

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Stella")
firstName.onNext("Lily")
//Paul Kim
//Stella Kim
//Lily Kim





print("----------zip----------")
// 둘 중 한 Observable이라도 완료되면 기다리지않고 연산이 끝나게 됨
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("🇰🇷", "🇨🇭", "🇺🇸", "🇧🇷", "🇯🇵", "🇨🇳")
let 시합결과 = Observable.zip(승부, 선수) { 결과, 대표선수 in
    return 대표선수 + "선수" + " \(결과)!"
}

시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//🇰🇷선수 승!
//🇨🇭선수 승!
//🇺🇸선수 패!
//🇧🇷선수 승!
//🇯🇵선수 패!




/*
 * 트리거 형태의 operator
 */
print("----------withLatestFrom1----------")
// 가장 최신의 이벤트 값이 출력 됨
let 💥🔫 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

💥🔫
    .withLatestFrom(달리기선수)
//    .distinctUntilChanged()     //Sample 이벤트와 똑같이 한 번만 출력하고 싶을 때
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("🏃🏻‍♀️")
달리기선수.onNext("🏃🏻‍♀️ 🏃🏽‍♂️")
달리기선수.onNext("🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿")
💥🔫.onNext(Void())
💥🔫.onNext(Void())
//🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿
//🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿



print("----------sample----------")
// withLatestFrom과 동일하지마 값을 한 번만 출력 됨
let 🏁출발 = PublishSubject<Void>()
let F1선수 = PublishSubject<String>()

F1선수.sample(🏁출발)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1선수.onNext("🏎")
F1선수.onNext("🏎   🚗")
F1선수.onNext("🏎      🚗   🚙")
🏁출발.onNext(Void())
🏁출발.onNext(Void())
🏁출발.onNext(Void())
//🏎      🚗   🚙





print("----------amb----------")
// 두가지 observable을 구독해도 먼저 시작하는 하는 것이 생기면 다른 것을 구독하지 않음
let 🚌버스1 = PublishSubject<String>()
let 🚌버스2 = PublishSubject<String>()

let 🚏버스정류장 = 🚌버스1.amb(🚌버스2)

🚏버스정류장.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

🚌버스2.onNext("버스2-승객0: 👩🏾‍💼")
🚌버스1.onNext("버스1-승객0: 🧑🏼‍💼")
🚌버스1.onNext("버스1-승객1: 👨🏻‍💼")
🚌버스2.onNext("버스2-승객1: 👩🏻‍💼")
🚌버스1.onNext("버스1-승객1: 🧑🏻‍💼")
🚌버스2.onNext("버스2-승객2: 👩🏼‍💼")
//버스2-승객0: 👩🏾‍💼
//버스2-승객1: 👩🏻‍💼
//버스2-승객2: 👩🏼‍💼




print("----------switchLatest----------")
// 마지막 시퀀스 아이템만 구독
let 👩🏻‍💻학생1 = PublishSubject<String>()
let 🧑🏽‍💻학생2 = PublishSubject<String>()
let 👨🏼‍💻학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest()
손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 저는 1번 학생입니다.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저요 저요!!!")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아니그든.")

손들기.onNext(🧑🏽‍💻학생2)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저는 2번이예요!")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아.. 나 아직 할말 있는데")

손들기.onNext(👨🏼‍💻학생3)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 아니 잠깐만! 내가! ")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 언제 말할 수 있죠")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 저는 3번 입니다~ 아무래도 제가 이긴 것 같네요.")

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아니, 틀렸어. 승자는 나야.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: ㅠㅠ")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 이긴 줄 알았는데")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 이거 이기고 지는 손들기였나요?")

//👩🏻‍💻학생1: 저는 1번 학생입니다.
//👩🏻‍💻학생1: 아니그든.
//🧑🏽‍💻학생2: 저는 2번이예요!
//👨🏼‍💻학생3: 저는 3번 입니다~ 아무래도 제가 이긴 것 같네요.
//👩🏻‍💻학생1: 아니, 틀렸어. 승자는 나야.




/*------------------------------------------------------------------
  시퀀스 내의 요소들의 결합
 -------------------------------------------------------------------*/
print("----------reduce----------")
Observable.from((1...10))
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })
//    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//55




print("----------scan----------")
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//1
//3
//6
//10
//15
//21
//28
//36
//45
//55
