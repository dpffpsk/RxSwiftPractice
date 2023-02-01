import UIKit
import Foundation
import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

// single : 좁은 범위의 Observer, 가독성을 위해서

print("-----single1-----")
Single<String>.just("A")
    .subscribe(
        onSuccess: { print($0) },
        onFailure: { print("error: \($0)") },
        onDisposed: { print("disposed") }
    ).disposed(by: disposeBag)
// onSuccess = onNext, onCompleted

//Observable<String>.just("A")
//    .subscribe(
//        onNext: <#T##((String) -> Void)?##((String) -> Void)?##(String) -> Void#>,
//        onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>,
//        onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>,
//        onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>
//    )


print("------single------")
struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"hello"}
"""

let json2 = """
    {"my_name":"hello"}
"""

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer in
        let disposable = Disposables.create()

        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {

            observer(.failure(JSONError.decodingError))
            return disposable
        }

        observer(.success(json))
        return disposable
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
// hello

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
// decodingError
