import RxSwift

print("--------ignoreElements--------")
let μ·¨μΉ¨λͺ¨λπ΄ = PublishSubject<String>()
let disposeBag = DisposeBag()

μ·¨μΉ¨λͺ¨λπ΄
    .ignoreElements()
    .subscribe { _ in
        print("βοΈ")
    }
    .disposed(by: disposeBag)

μ·¨μΉ¨λͺ¨λπ΄.onNext("π")
μ·¨μΉ¨λͺ¨λπ΄.onNext("π")
μ·¨μΉ¨λͺ¨λπ΄.onNext("π")

//μ·¨μΉ¨λͺ¨λπ΄.onCompleted()


print("--------elementAt--------")
let λλ²μΈλ©΄κΉ¨λμ¬λ = PublishSubject<String>()

λλ²μΈλ©΄κΉ¨λμ¬λ
    .element(at: 2)
    .subscribe(onNext: { _ in
        print("λκ΅¬μΈμ")
    })
    .disposed(by: disposeBag)

λλ²μΈλ©΄κΉ¨λμ¬λ.onNext("π")
λλ²μΈλ©΄κΉ¨λμ¬λ.onNext("π")
λλ²μΈλ©΄κΉ¨λμ¬λ.onNext("π")



print("--------filter--------")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//2
//4
//6
//8


print("--------skip--------")
Observable.of("π", "π", "π", "π€", "π", "πΆ")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//πΆ


print("--------skipWhile--------")
Observable.of("π", "π", "π", "π€", "π", "πΆ", "π", "π")
    .skip(while: {
        $0 != "πΆ"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//πΆ
//π
//π



print("--------skipUntil--------")
let μλ = PublishSubject<String>()
let λ¬Έμ¬λμκ° = PublishSubject<String>()

μλ
    .skip(until: λ¬Έμ¬λμκ°)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

μλ.onNext("π")
μλ.onNext("π")

λ¬Έμ¬λμκ°.onNext("λ‘")
μλ.onNext("π")
//π


print("--------take--------")
Observable.of("π₯", "π₯", "π₯", "π€", "π")
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//π₯
//π₯
//π₯


print("--------takeWhile--------")
Observable.of("π₯", "π₯", "π₯", "π€", "π")
    .take(while: {
        $0 != "π₯"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//π₯
//π₯


print("--------enumerated--------")
Observable.of("π₯", "π₯", "π₯", "π€", "π")
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print("\($0.index + 1)λ²μ§Έ μ μ \($0.element)λ©λ¬")
    })
    .disposed(by: disposeBag)
//1λ²μ§Έ μ μ π₯λ©λ¬
//2λ²μ§Έ μ μ π₯λ©λ¬
//3λ²μ§Έ μ μ π₯λ©λ¬


print("--------takeUntil--------")
let μκ°μ μ²­ = PublishSubject<String>()
let μ μ²­λ§κ° = PublishSubject<String>()
μκ°μ μ²­
    .take(until: μ μ²­λ§κ°)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

μκ°μ μ²­.onNext("ππΌββοΈ")
μκ°μ μ²­.onNext("ππ»ββοΈ")
μ μ²­λ§κ°.onNext("λ!")
μκ°μ μ²­.onNext("ππ»")
//ππΌββοΈ
//ππ»ββοΈ



print("--------distinctUntilChanged1--------")
Observable.of("μ λ", "μ λ", "μ΅λ¬΄μ", "μ΅λ¬΄μ", "μ΅λ¬΄μ", "μλλ€", "μλλ€", "μλλ€", "μ λ", "μ΅λ¬΄μ", "μΌκΉμ?", "μΌκΉμ?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//μ λ
//μ΅λ¬΄μ
//μλλ€
//μ λ
//μ΅λ¬΄μ
//μΌκΉμ?
