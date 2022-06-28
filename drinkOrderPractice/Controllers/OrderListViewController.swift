//
//  OrderListViewController.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/26.
//

import UIKit

class OrderListViewController: UIViewController {
    
    var orderLists = [Type]()
    var orderListCount: Int = 0
    var totalPrice: Int = 0
    let ai = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderListTableView: UITableView!
    
    
    func fetchOrderList() {
        if let url = URL(string: "https://api.airtable.com/v0/appbQTpLmlKHdXTtu/orderList") {
            var request = URLRequest(url: url)
            request.setValue("Bearer keyAJ7qqPymAEq7JZ", forHTTPHeaderField: "Authorization")
            NetworkController.shared.fetchOrderList(request: request) { result in
                switch result {
                case .success(let orderLists):
                    self.orderLists = orderLists
                    self.updateUI()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ai.color = .orange
        ai.hidesWhenStopped = true
        ai.center = view.center
        ai.startAnimating()
        view.addSubview(ai)
        
        totalPriceLabel.text = "NTD \(self.totalPrice.description)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrderList()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateUI() {
        DispatchQueue.main.async {
            self.totalPrice = 0
            self.ai.stopAnimating()
            self.orderLists.forEach { orderList in
                self.totalPrice += Int(orderList.fields.finalPrice!)!
            }
            self.totalPriceLabel.text = "NTD \(self.totalPrice.description)"
            self.orderListTableView.reloadData()
        }
    }
    
    

}
extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)", for: indexPath) as! OrderListTableViewCell
        
        let orderList = orderLists[indexPath.row]
        cell.orderLabel.text = orderList.fields.name
        cell.drinkLabel.text = orderList.fields.drinkName
        cell.optionLabel.text = "\(orderList.fields.cupSize),\(orderList.fields.sweet),\(orderList.fields.temperature),\(orderList.fields.topping)"
        cell.priceLabel.text = orderList.fields.finalPrice
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let orderList = orderLists[indexPath.row]
        let id = orderList.id
        print("id: \(id!)")
        if let url = URL(string: "https://api.airtable.com/v0/appbQTpLmlKHdXTtu/orderList/\(id!)") {
            var request = URLRequest(url: url)
            request.setValue("Bearer keyAJ7qqPymAEq7JZ", forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: .utf8)!)
                    self.orderLists.remove(at: indexPath.row)
                    self.updateUI()
                    
                }
                    
            
            }.resume()
            
            
            
        }
    }
}

