//
//  PaymentDataTableVC.swift
//  TakeMyMoney
//
//  Created by Jadson on 28/03/22.
//

import UIKit

class PaymentDataTableVC: UITableViewController {
    
    @IBOutlet weak var paymentTypeCollectionView: UICollectionView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var CVVTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var expireDatePicker: UIDatePicker!
    @IBOutlet weak var payPalLoginTextField: UITextField!
    @IBOutlet weak var payPalPasswordTextField: UITextField!
    @IBOutlet weak var proceedPaymentButton: UIButton!
    @IBOutlet weak var saveCardInfoSwitch: UISwitch!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    var selectedPaymentType = PaymentMethods.creditCard
    
    struct PropertyKeys {
        static let paymentTypesId = "paymentCell"
        static let segueToPaymentTVC = "goToPayment"
    }
    
    var typeOfPayment: PaymentMethods!
    var bankPayment: BankTransferPayment!
    //var cardPayment: CardPayment?
    var cardPayment: CardPayment? {
        let cardNumber = cardNumberTextField.text ?? ""
        let expDate = expireDatePicker.date
        let cardHolderName = cardHolderNameTextField.text ?? ""
        let CVV = CVVTextField.text ?? ""
        let saveCard = saveCardInfoSwitch.isOn
        
        return CardPayment(cardNumber: Int(cardNumber)!,
                           expDate: expDate,
                           CVV: Int(CVV)!,
                           cardHolderName: cardHolderName,
                           saveCard: saveCard)
    }
    
    
    var payPalPayment: PayPalPayment?
    
    
    var isEditingExpirationDate: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    
    var cardRowSection = IndexPath(row: 1, section: 2)
    var expirationDateRowSection = IndexPath(row: 1, section: 3)
    var paypalRowSection = IndexPath(row: 1, section: 4)
    var bankTransferRowSection = IndexPath(row: 1, section: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentTypeCollectionView.dataSource = self
        paymentTypeCollectionView.delegate = self
        paymentTypeCollectionView.allowsSelection = true
        
        updateViews()
        
        CVVTextField.delegate = self
        cardHolderNameTextField.delegate = self
        cardNumberTextField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
        //        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
    }
    
    func updateViews() {
        
        let cornerRadius = 15.0
        let borderWidth = 1.0
        let colour = UIColor.systemGray5.cgColor
        
        proceedPaymentButton.layer.cornerRadius = cornerRadius
        tableView.allowsSelection = false
        
        cardNumberTextField.layer.cornerRadius = cornerRadius
        cardNumberTextField.layer.borderWidth = borderWidth
        cardNumberTextField.layer.borderColor = colour
        cardHolderNameTextField.layer.cornerRadius = cornerRadius
        cardHolderNameTextField.layer.borderWidth = borderWidth
        cardHolderNameTextField.layer.borderColor = colour
        CVVTextField.layer.cornerRadius = cornerRadius
        CVVTextField.layer.borderWidth = borderWidth
        CVVTextField.layer.borderColor = colour
        expirationDateTextField.layer.cornerRadius = cornerRadius
        expirationDateTextField.layer.borderWidth = borderWidth
        expirationDateTextField.layer.borderColor = colour
        payPalLoginTextField.layer.cornerRadius = cornerRadius
        payPalLoginTextField.layer.borderWidth = borderWidth
        payPalLoginTextField.layer.borderColor = colour
        payPalPasswordTextField.layer.cornerRadius = cornerRadius
        payPalPasswordTextField.layer.borderWidth = borderWidth
        payPalPasswordTextField.layer.borderColor = colour
    }
    
    //    func updateView() {
    //        if let cardPayment = cardPayment {
    //            cardNumberTextField.text = String(cardPayment.cardNumber)
    //            let dateFormatter = DateFormatter()
    //            dateFormatter.dateStyle = .short
    //            expirationDateTextField.text = dateFormatter.string(from: cardPayment.expDate)
    //            CVVTextField.text = String(cardPayment.CVV)
    //            cardHolderNameTextField.text = cardPayment.cardHolderName
    //        } else if let payPalPayment = payPalPayment {
    //            payPalLoginTextField.text = payPalPayment.login
    //            payPalPasswordTextField.text = payPalPayment.password
    //        }
    //    }
    
    func updateExpireDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        expirationDateTextField.text = String(dateFormatter.string(from: expireDatePicker.date).dropFirst(3))
        
        disableProceedButton()
    }
    
    func disableProceedButton() {
        
    }
    
    
    @IBAction func proceedButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: PropertyKeys.segueToPaymentTVC, sender: self)
        
        
        let cardNumber = cardNumberTextField.text ?? ""
        let expDate = expireDatePicker.date
        let cardHolderName = cardHolderNameTextField.text ?? ""
        let CVV = CVVTextField.text ?? ""
        let saveCard = saveCardInfoSwitch.isOn
        
        print("PROCEED TAPPED")
        print("Card Number: \(cardNumber)")
        print("Expiration date: \(expDate)")
        print("Card Name: \(cardHolderName)")
        print("CVV: \(CVV)")
        print("Is save card on?: \(saveCard)")
        
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateExpireDate()
        
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedPaymentType {
        case .creditCard: if indexPath.section == paypalRowSection.section || indexPath.section == bankTransferRowSection.section {
            return 0
        }
        case .payPal:
            if indexPath.section == cardRowSection.section  || indexPath.section == bankTransferRowSection.section {
//                if indexPath.section == expirationDateRowSection.section {
//                    return 0
//                }
                return 0
            }
        case .bankTransfer:
            if indexPath.section == cardRowSection.section || indexPath.section == paypalRowSection.section {
                return 0
            }
            
        }
        return 44.0
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.segueToPaymentTVC {
            let destinationVC = segue.destination as? PaymentDataTableVC
            //            destinationVC?.cardPayment = cardPayment
            destinationVC?.payPalPayment = payPalPayment
        }
    }
    
    
    
}

extension PaymentDataTableVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PaymentMethods.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.paymentTypesId, for: indexPath) as? PaymentTypeCollectionViewCell {
            let text = PaymentMethods.allCases[indexPath.row]
            cell.updateView(paymentType: text)
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.systemGray5.cgColor
            return cell
        }
        return PaymentTypeCollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPaymentType = PaymentMethods.allCases[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
}

extension PaymentDataTableVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //limit the number of the CVVTextField characters to 3
        if CVVTextField.isEditing {
            let maxLength = 3
            let currentString: NSString = (CVVTextField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        
        
        //format cardNumberTextField for cards
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        //Allow only letters on cardHolderNameTextField
        
        if cardHolderNameTextField.isEditing {
            
            if range.location == 0 && string == " " { // prevent space on first character
                return false
            }
            
            if textField.text?.last == " " && string == " " { // allowed only single space
                return false
            }
            
            if string == " " { return true } // now allowing space between name
            
            if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                return false
            }
        }
        
        return true
        
        
    }
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        cardHolderNameTextField.endEditing(true)
    //        payPalLoginTextField.endEditing(true)
    //        payPalPasswordTextField.endEditing(true)
    //
    //        if textField == payPalLoginTextField {
    //            textField.resignFirstResponder()
    //        }
    //        return true
    //    }
    
    
    //Format card textField
    
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
        ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
}
