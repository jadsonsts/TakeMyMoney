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
    @IBOutlet weak var payPalLoginTextField: UITextField!
    @IBOutlet weak var payPalPasswordTextField: UITextField!
    @IBOutlet weak var proceedPaymentButton: UIButton!
    @IBOutlet weak var saveCardInfoSwitch: UISwitch!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    private var datePicker = UIDatePicker()
    private var currentSelectedItem: Int? //to change the color of the currenct selected collection view
    var selectedPaymentType = PaymentMethods.creditCard
    
    struct PropertyKeys {
        static let paymentTypesId = "paymentCell"
        static let segueToPaymentTVC = "goToPayment"
    }
    
    var bankPayment: BankTransferPayment!
    var cardPayment: CardPayment?
    var payPalPayment: PayPalPayment?
    var userDetails: PaymentDetails? //this one will set the info in the payment table view controller
    
    let alertColor = UIColor.red.cgColor
    let normalColor = UIColor.systemGray5.cgColor
    
    var cardRowSection = IndexPath(row: 1, section: 2)
    var paypalRowSection = IndexPath(row: 1, section: 3)
    var bankTransferRowSection = IndexPath(row: 1, section: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentTypeCollectionView.dataSource = self
        paymentTypeCollectionView.delegate = self
        paymentTypeCollectionView.allowsSelection = true
        createPicker()
        formatTextFields()
        
        CVVTextField.delegate = self
        cardHolderNameTextField.delegate = self
        cardNumberTextField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    
    func createPicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        //assign toolbar
        expirationDateTextField.inputAccessoryView = toolbar
        //assign date picker to the text field
        expirationDateTextField.inputView = datePicker
        //date picker mode
        datePicker.datePickerMode = .date
        //date picker style
        datePicker.preferredDatePickerStyle = .wheels
        let midnightToday = Calendar.current.startOfDay(for: Date())
        datePicker.minimumDate = midnightToday
        datePicker.date = midnightToday
        
    }
    
    @objc func donePressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MM/yyyy"
        expirationDateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    func formatTextFields() {
        
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
    
    @IBAction func proceedButtonTapped(_ sender: Any) {
        
        switch selectedPaymentType {
        case .creditCard:
            checkCardFields()
        case .payPal:
            checkPayPalFields()
        case .bankTransfer:
            bankTranferSelected()
        }
        
    }
    
    //MARK: - Updating the objects and segue to PaymentTableVC
    func creditCardSelected() {
        guard let cardNumber = cardNumberTextField.text,
              let expDate = expirationDateTextField.text,
              let cardHolderName = cardHolderNameTextField.text,
              let CVV = Int(CVVTextField.text!)
        else {return}
        let saveCard = saveCardInfoSwitch.isOn
        
        cardPayment = CardPayment(cardNumber: cardNumber, expDate: expDate, CVV: CVV, cardHolderName: cardHolderName, saveCard: saveCard)
        
        let lastFourDigits = String(cardNumberTextField.text!.suffix(4))
        userDetails = PaymentDetails(username: " \(cardHolderName)", payDetails: " Credit Card ending \(lastFourDigits)")
        
        sendToPayment()
    }
    
    func payPalSelected() {
        guard let payPalUser = payPalLoginTextField.text,
              let payPalPassword = payPalPasswordTextField.text else {return}
        
        payPalPayment = PayPalPayment(login: payPalUser, password: payPalPassword)
        userDetails = PaymentDetails(username: payPalUser, payDetails: "")
        
        sendToPayment()
    }
    
    func bankTranferSelected() {
        let bankAccount = "Bank: \(DataService.instance.bankDetails.bankName) | " + "Name: \(DataService.instance.bankDetails.accountName)"
        let accountNumber = "Account Number: \(DataService.instance.bankDetails.accountNumber)"
        
        userDetails = PaymentDetails(username: bankAccount, payDetails: accountNumber)
        sendToPayment()
    }
    
    func checkCardFields() {
        if cardNumberTextField.text == "" && CVVTextField.text == "" && expirationDateTextField.text == "" && cardHolderNameTextField.text == "" {
            let alert = UIAlertController(title: "", message: "Please, make sure to complete all fields" , preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if cardNumberTextField.text == "" {
            cardNumberTextField.placeholder = "Please insert the card number"
            cardNumberTextField.layer.borderColor = alertColor

        } else if expirationDateTextField.text == "" {
            expirationDateTextField.placeholder = "Invalid data"
            expirationDateTextField.layer.borderColor = alertColor

        } else if CVVTextField.text == "" {
            CVVTextField.placeholder = "Invalid"
            CVVTextField.layer.borderColor = alertColor

        } else if cardHolderNameTextField.text == "" {
            cardHolderNameTextField.placeholder = "Please insert the card holder number"
            cardHolderNameTextField.layer.borderColor = alertColor

        } else {
            creditCardSelected()
        }
    }
    
    func checkPayPalFields()  {
        if payPalLoginTextField.text == "" && payPalPasswordTextField.text == "" {
            let alert = UIAlertController(title: "", message: "Please, make sure to complete both fields" , preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else if payPalLoginTextField.text == "" {
            payPalLoginTextField.text = "Please, insert login"
            payPalLoginTextField.layer.borderColor = alertColor

        } else if payPalPasswordTextField.text == "" {
            payPalPasswordTextField.placeholder = "Password can't be nil"
            payPalPasswordTextField.layer.borderColor = alertColor
        } else {
            payPalSelected()
        }
    }
    
    
    func sendToPayment(){
        performSegue(withIdentifier: PropertyKeys.segueToPaymentTVC, sender: userDetails)
    }
    
    // reset the text fields states to their original
    func resetPayPalTextFields() {
        payPalPasswordTextField.text = ""
        payPalLoginTextField.text = ""
        payPalLoginTextField.layer.borderColor = normalColor
        payPalPasswordTextField.placeholder = " Password"
        payPalPasswordTextField.layer.borderColor = normalColor
    }
    
    func resetCardTextFields() {
        cardNumberTextField.text = ""
        cardHolderNameTextField.text = ""
        CVVTextField.text = ""
        expirationDateTextField.text = ""
        
        cardNumberTextField.layer.borderColor = normalColor
        cardHolderNameTextField.layer.borderColor = normalColor
        CVVTextField.layer.borderColor = normalColor
        expirationDateTextField.layer.borderColor = normalColor
        
        cardNumberTextField.placeholder = " 1234 5678 9012 3456"
        cardHolderNameTextField.placeholder = " Card's Holder Name"
        CVVTextField.placeholder = " ***"
        expirationDateTextField.placeholder = " Month / Year"
        
        
        
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedPaymentType {
        case .creditCard: if indexPath.section == paypalRowSection.section || indexPath.section == bankTransferRowSection.section {
            resetPayPalTextFields()
            return 0
        }
        case .payPal:
            if indexPath.section == cardRowSection.section  || indexPath.section == bankTransferRowSection.section {
                resetCardTextFields()
                return 0
            }
        case .bankTransfer:
            if indexPath.section == cardRowSection.section || indexPath.section == paypalRowSection.section {
                resetPayPalTextFields()
                resetCardTextFields()
                return 0
            }
        }
        
        //change the height of section 0 and 1 (label value and the collection view)
        if indexPath.section == 0 {
            return 60
        } else if indexPath.section == 1 {
            return 75
        }
        
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == PropertyKeys.segueToPaymentTVC {
            let destinationVC = segue.destination as? PaymentTableVC
            destinationVC?.paymentInfo = userDetails
            destinationVC?.selectedPaymentType = selectedPaymentType
        }
        
    }
    
    //MARK: - Change Space Between Section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { //section value label
            return 3.0
        } else if section == 5 { //Proceed to Payment button section
            return 1.0
        }
        return 1.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 5 { // Proceed to Payment button section
            return 2.0
        }
        return 5.0
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
            cell.backgroundColor = currentSelectedItem == indexPath.row ?  UIColor(red: 254/255,
                                                                                   green: 249/255,
                                                                                   blue: 239/255,
                                                                                   alpha: 0.5) : UIColor(red: 162/255,
                                                                                                         green: 210/255,
                                                                                                         blue: 255/255,
                                                                                                         alpha: 0.5)
            return cell
        }
        return PaymentTypeCollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPaymentType = PaymentMethods.allCases[indexPath.row]
        currentSelectedItem = indexPath.row
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    
}

extension PaymentDataTableVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == payPalLoginTextField {
            textField.resignFirstResponder()
            payPalPasswordTextField.becomeFirstResponder()
        } else if textField == payPalPasswordTextField {
            textField.resignFirstResponder()
        }
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
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
