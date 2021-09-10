//
//  LoginViewModel.swift
//  LoginSUISample (iOS)
//
//  Created by Eduardo Martinez on 8/5/21.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    // MARK: Variable Declaration
    // Input
    @Published var email = ""
    @Published var password = ""
    let didTapLogin = PassthroughSubject<Void, Never>()

    // Output
    @Published var isLoading = false
    @Published var emailValidation = true
    @Published var passwordValidation = true
    let didLoginSucceed = PassthroughSubject<Void, Never>()
    let didThrowError = PassthroughSubject<Void, Never>()
    var isButtonEnabled: Bool {
        !email.isEmpty
            && !password.isEmpty
            && emailValidation
            && passwordValidation
    }

    private var cancellables = Set<AnyCancellable>()
    private let loginService: LoginServiceType

    // MARK: Initializer
    init(
        loginService: LoginServiceType = LoginService()
    ) {
        self.loginService = loginService
        setSubscriptions()
    }
    
    func login() {
        
    }

    // MARK: Private Methods
    private func setSubscriptions() {
        let email = $email.dropFirst().share()
        let password = $password.dropFirst().share()

        email
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { !$0.isEmpty && $0.contains("@") }
            .sink { [weak self] in self?.emailValidation = $0 }
            .store(in: &cancellables)

        password
            .map { !$0.isEmpty }
            .sink { [weak self] in self?.passwordValidation = $0 }
            .store(in: &cancellables)

        let result = didTapLogin
            .compactMap { [weak self] _ -> (String, String)? in
                guard let self = self else { return nil }
                return (self.email, self.password)
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
            })
            .map { [weak self] email, password -> AnyPublisher<Result<Void, Error>, Never> in
                guard let service = self?.loginService else { return Empty().eraseToAnyPublisher() }
                return service.login(email: email, password: password)
                    .map { _ in .success(()) }
                    .catch { Just(.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = false
            })
            .share()

        result
            .filter { $0.isSuccessful }
            .sink { [weak self] _ in
                self?.didLoginSucceed.send()
            }
            .store(in: &cancellables)
        
        result
            .filter { !$0.isSuccessful }
            .sink { [weak self] error in
                self?.didThrowError.send()
            }
            .store(in: &cancellables)
    }
}
