import UIKit
import RxSwift
import Foundation

let disposeBag = DisposeBag()


/*
 * PublishSubject
 */
print("-----publishSubject-----")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("안녕하세요")

let subscriber1 = publishSubject
    .subscribe(onNext: {
        print("첫번째 구독 : \($0)")
    })
//    .disposed(by: disposeBag)

// .onNext == .on(.Next
publishSubject.onNext("1")
publishSubject.on(.next("2"))

subscriber1.dispose()

let subscriber2 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독 : \($0)")
    })
//    .disposed(by: disposeBag)

publishSubject.onNext("3")
publishSubject.onCompleted()

publishSubject.onNext("4")

subscriber2.dispose()

// 첫번째 구독 : 1
// 첫번째 구독 : 2
// 두번째 구독 : 3
// = 구독을 시작한 시점 이전(안녕하세요)은 출력되지 않음

publishSubject
    .subscribe {
        print("세번째 구독 : \($0)")
    }
    .disposed(by: disposeBag)
publishSubject.onNext("5")

// 첫번째 구독 : 1
// 첫번째 구독 : 2
// 두번째 구독 : 3
// 세번째 구독 : completed
// = 이미 onCompleted 되었기 때문에 세번째 구독 후 onNext 이벤트가 실행되지 않음




/*
 * BehaviorSubject
 */
print("-----behaviorSubject-----")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "초기값")

behaviorSubject.onNext("첫번째값")

behaviorSubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

behaviorSubject.onError(SubjectError.error1)

// 첫번째 구독: 첫번째값
// 첫번째 구독: error(error1)

behaviorSubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

// behavior 구독을 시작한 시점 직전의 값을 전달해주기 때문에 구독한 시점 이전에 이벤트가 발생하였더라도 실행 됨
// 첫번째 구독은 구독 전에 이벤트가 발생해도 이벤트 실행, 그러나 그 전에 정의된 초깃값은 실행되지 못 함
// 두번째 구독은 구독 전에 에러를 발생시켰기 때문에 에러가 출력됨

// 두번째 구독: error(error1)





/*
 * ReplaySubject
 */
print("-----replaySubject-----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("a")
replaySubject.onNext("b")
replaySubject.onNext("c")

replaySubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)
// 첫번째 구독: b
// 첫번째 구독: c

replaySubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)
// 첫번째 구독: b
// 첫번째 구독: c
// 두번째 구독: b
// 두번째 구독: c

replaySubject.onNext("d")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()
// 첫번째 구독: b
// 첫번째 구독: c
// 두번째 구독: b
// 두번째 구독: c
// 첫번째 구독: d
// 두번째 구독: d
// 첫번째 구독: error(error1)
// 두번째 구독: error(error1)


replaySubject.subscribe {
    print("세번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

// 구독이 발생했을 때 지나간 이벤트라도 버퍼사이즈에 따라 실행시켜줌
// 첫번째 구독: b
// 첫번째 구독: c
// 두번째 구독: b
// 두번째 구독: c
// 첫번째 구독: d
// 두번째 구독: d
// 첫번째 구독: error(error1)
// 두번째 구독: error(error1)
// 세번째 구독: error(Object `RxSwift.(unknown context at $10d94fc60).ReplayMany<Swift.String>` was already disposed.)
