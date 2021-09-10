//
//  LoginServiceMock.swift
//  LoginSUISampleTests
//
//  Created by Eduardo Martinez on 8/5/21.
//

import Combine
import Foundation

@testable import LoginSUISample

struct LoginServiceMock: LoginServiceType {

    let shouldLoginFail: Bool

    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        if shouldLoginFail {
            return Fail(error: NSError()).eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
