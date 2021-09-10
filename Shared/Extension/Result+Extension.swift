//
//  Result+Extension.swift
//  LoginSUISample (iOS)
//
//  Created by Eduardo Martinez on 8/5/21.
//

import Foundation

extension Result {
    var isSuccessful: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
