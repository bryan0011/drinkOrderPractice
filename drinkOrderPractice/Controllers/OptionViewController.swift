//
//  OptionViewController.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/23.
//

import UIKit

class OptionViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet weak var toppingSegment: UISegmentedControl!
    @IBOutlet weak var orderTextField: UITextField!
    
    
    var cupSize = "中杯"
    var temperature = "正常冰"
    var sweet = "正常糖"
    var topping = "不加料"
    var finalPrice = ""
    
    let drinkMenu: Record

   
        required init?(coder: NSCoder, drinkMenu: Record) {
        self.drinkMenu = drinkMenu
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        if drinkMenu.fields.largePrice == nil {
            sizeSegment.isEnabled = false
        }
        
        nameLabel.text = drinkMenu.fields.drinkName
        priceLabel.text = drinkMenu.fields.mediumPrice
        finalPrice = drinkMenu.fields.mediumPrice
        URLSession.shared.dataTask(with: drinkMenu.fields.drinkImage[0].url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.drinkImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
    }
    
    @IBAction func cupSizeChoice(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            cupSize = "中杯"
            if toppingSegment.selectedSegmentIndex == 0 {
                finalPrice = drinkMenu.fields.mediumPrice
            } else {
                let mediumPrice = drinkMenu.fields.mediumPrice
                finalPrice = String(Int(mediumPrice)! + 10)
            }
            priceLabel.text = finalPrice
            
        case 1:
            cupSize = "大杯"
            if toppingSegment.selectedSegmentIndex == 0 {
                finalPrice = drinkMenu.fields.largePrice ?? ""
            } else {
                let largePrice = drinkMenu.fields.largePrice ?? ""
                finalPrice = String(Int(largePrice)! + 10)
            }
            priceLabel.text = finalPrice
            
        default:
            break
        }
    }
    
    @IBAction func temperatureChoice(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            temperature = "正常冰"
        case 1:
            temperature = "少冰"
        case 2:
            temperature = "微冰"
        case 3:
            temperature = "去冰"
        case 4:
            temperature = "溫熱"
        default:
            break
        }
    }
    
    @IBAction func sweetChoice(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            sweet = "正常糖"
        case 1:
            sweet = "少糖"
        case 2:
            sweet = "半糖"
        case 3:
            sweet = "微糖"
        case 4:
            sweet = "無糖"
        default:
            break
        }
    }
    
    @IBAction func toppingChoice(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            topping = "不加料"
            if sizeSegment.selectedSegmentIndex == 0 {
                finalPrice = drinkMenu.fields.mediumPrice
                priceLabel.text = finalPrice
            } else if sizeSegment.selectedSegmentIndex == 1 {
                finalPrice = drinkMenu.fields.largePrice ?? ""
                priceLabel.text = finalPrice
            }
        case 1:
            topping = "白玉"
            if sizeSegment.selectedSegmentIndex == 0 {
                finalPrice = String(Int(drinkMenu.fields.mediumPrice)! + 10 )
                priceLabel.text = finalPrice
            } else if sizeSegment.selectedSegmentIndex == 1 {
                let largePrice = drinkMenu.fields.largePrice ?? ""
                finalPrice = String(Int(largePrice)! + 10)
                priceLabel.text = finalPrice
            }
            
        case 2:
            topping = "水玉"
            if sizeSegment.selectedSegmentIndex == 0 {
                finalPrice = String(Int(drinkMenu.fields.mediumPrice)! + 10 )
                priceLabel.text = finalPrice
            } else if sizeSegment.selectedSegmentIndex == 1 {
                let largePrice = drinkMenu.fields.largePrice ?? ""
                finalPrice = String(Int(largePrice)! + 10)
                priceLabel.text = finalPrice
            }
            
        default:
            break
        }
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        if orderTextField.text?.isEmpty == true {
            let alertController = UIAlertController(title: "", message: "請輸入訂購者姓名", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        } else {
            if let url = URL(string: "https://api.airtable.com/v0/appbQTpLmlKHdXTtu/orderList") {
                var request = URLRequest(url: url)
                request.setValue("Bearer keyAJ7qqPymAEq7JZ", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let encoder = JSONEncoder()
                let user = OrderList(records: [.init(id: nil, fields: .init(name: orderTextField.text!, drinkName: drinkMenu.fields.drinkName, temperature: temperature, sweet: sweet, topping: topping, finalPrice: finalPrice, cupSize: cupSize))])
                let data = try? encoder.encode(user)
                request.httpBody = data
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let orderList = try decoder.decode(OrderList.self, from: data)
                            print(orderList.records.count)
                        } catch {
                            print(error)
                        }
                    }
                }.resume()
            }
            
            let orderSuccessController = UIAlertController(title: "", message: "已完成訂購", preferredStyle: .alert)
            orderSuccessController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(orderSuccessController, animated: true) 
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
