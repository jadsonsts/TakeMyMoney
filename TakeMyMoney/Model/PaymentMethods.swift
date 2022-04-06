//
//  PaymentMethods.swift
//  TakeMyMoney
//
//  Created by Jadson on 29/03/22.
//

import Foundation
//CaseIterable makes an array of the cases I have in the Enum and no longer need the array (change the PaymentDataTableVC)
enum PaymentMethods: CaseIterable {
    case creditCard
    case payPal
    case bankTransfer
    
//    static let all: [PaymentMethods] = [.creditCard, .payPal, .bankTransfer]
    
    func description() -> String {
        switch self {
        case .creditCard:
            return "Credit Card"
        case .payPal:
            return "Paypal"
        case .bankTransfer:
            return "Bank Transfer"
        }
    }

}

struct CardPayment {
    var cardNumber: Int
    var expDate: Date
    var CVV: Int
    var cardHolderName: String
    var saveCard: Bool
}

struct PayPalPayment {
    var login: String?
    var password: String?
}

struct BankTransferPayment {
    var accountName = "iOS Develeper"
    var bankName = "Swift"
    var accountNumber = "11-2222-3333444-0"
}


