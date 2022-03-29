//
//  PaymentMethods.swift
//  TakeMyMoney
//
//  Created by Jadson on 29/03/22.
//

import Foundation

enum PaymentMethods {
    case creditCard
    case payPal
    case bankTransfer
    
    static let all: [PaymentMethods] = [.creditCard, .payPal, .bankTransfer]

}

struct Payment {
    var cardNumber: Int?
    var expDate: Date?
    var CVV: Int?
    var cardHolderName: String?
    var login: String?
    var password: String?
    var accountName: String?
    var bankName: String?
    var accountNumber: String?
}
