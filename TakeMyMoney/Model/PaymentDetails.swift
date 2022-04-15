//
//  PaymentDetails.swift
//  TakeMyMoney
//
//  Created by Jadson on 12/04/22.
//

import Foundation

// This one object can cover both paypal and credit card details
struct PaymentDetails {
    var username: String // Credit card name OR paypal email
    var payDetails: String // Credit card #
}
