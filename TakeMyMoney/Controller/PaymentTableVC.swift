//
//  PaymentTableVC.swift
//  TakeMyMoney
//
//  Created by Jadson on 3/04/22.
//

import UIKit

class PaymentTableVC: UITableViewController {
    
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var payPalUserLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payButton.layer.borderWidth = 15
        payButton.layer.cornerRadius = 0.5
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func payButtonPressed(_ sender: UIButton) {
        
    }
}
