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
    
    func imageView() -> String {
        switch self {
        case .creditCard:
            return "creditcard.fill"
        case .payPal:
            return "paypal"
        case .bankTransfer:
            return "banknote.fill"
        }
    }

}

class CardPayment {
    var cardNumber: String
    var expDate: String
    var CVV: Int
    var cardHolderName: String
    var saveCard: Bool
    
    init(cardNumber: String, expDate: String, CVV: Int, cardHolderName: String, saveCard: Bool) {
        self.cardNumber = cardNumber
        self.expDate = expDate
        self.CVV = CVV
        self.cardHolderName = cardHolderName
        self.saveCard = saveCard
        
    }
}

class PayPalPayment {
    var login: String
    var password: String
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}

class BankTransferPayment {
    var accountName: String
    var bankName: String
    var accountNumber: String
    
    init(accountName: String, bankName: String, accountNumber: String) {
        self.accountName = accountName
        self.bankName = bankName
        self.accountNumber = accountNumber
    }
    
    
}


