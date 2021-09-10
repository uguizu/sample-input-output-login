//
//  LoginService.swift
//  LoginSUISample (iOS)
//
//  Created by Eduardo Martinez on 8/5/21.
//

import Combine
import Foundation

protocol LoginServiceType {
    func login(email: String, password: String) -> AnyPublisher<Void, Error>
}

struct LoginService: LoginServiceType {
    // Probably there are other dependencies here
    // Network clients, firebase client, etc...

    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        let result = email == "testuser@gmail.com" && password == "testpassword"
        return result
            ? Just(())
                .delay(for: .seconds(3), scheduler: RunLoop.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            : Fail(error: NSError())
                .delay(for: .seconds(3), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
    }
}
