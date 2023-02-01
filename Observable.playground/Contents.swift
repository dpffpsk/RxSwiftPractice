import UIKit
import Foundation
import RxSwift

// Observable은 그저 정의일 뿐. 구독(subscribe)되기 전까지 값을 출력하지 않음.

print("-----just-----")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })
// 1

print("-----of1-----")
Observable<Int>.of(1,2,3,4,5)
    .subscribe(onNext: {
        print($0)
    })
// 1
// 2
// 3
// 4
// 5`

print("-----of2-----")
Observable.of([1,2,3,4,5])
    .subscribe(onNext: {
        print($0)
    })
// 타입을 명시해주지 않으면 하나의 array로 판단
// Observable.just([1,2,3,4,5]) 와 동일
// [1,2,3,4,5]

print("-----from-----")
Observable.from([1,2,3,4,5])
    .subscribe(onNext: {
        print($0)
    })
// from : array 타입만 받음, array 각각의 요소들을 방출
// 1
// 2
// 3
// 4
// 5

print("-----subscribe1-----")
Observable.of(1,2)
    .subscribe {
        print($0)
    }
// 이벤트를 그대로 보여줌(어떤 이벤트에 어떤 값이 오는지 알 수 있음)
// next(1)
// next(2)
// completed

print("-----subscribe2-----")
Observable.of(1,2)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }
// onNext 결과와 같음
// 1
// 2

print("-----empty-----")
Observable.empty()
    .subscribe {
        print($0)
    }
// 아무것도 출력되지 않음

Observable<Void>.empty()
    .subscribe {
        print($0)
    }
// completed
// 어떤 요소나 이벤트도 가지지않을 때
// 즉시 종료나 0개의 값을 가진 값을 리턴하고 싶을 경우 사용


print("-------never-------")
Observable.never()
//    .debug("never") //작동은 하지만 아무 것도 뱉어내지 않음. -> 확인하기 위해서 debug 함수 사용
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed")
        })


print("-----dispose-----")
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    }).dispose()

let disposeBag = DisposeBag()
Observable.of(1,2,3)
    .subscribe {
        print($0)
    }.disposed(by: disposeBag)

// 구독을 취소하여 Observable을 종료시킬 경우
// 매번 dispose를 하는 것은 효율성이 떨어진다. 해당 코드를 누락시킨 경우 메모리 누수 위험이 있다.
// 그래서 DisposeBag을 만들어 사용한다
