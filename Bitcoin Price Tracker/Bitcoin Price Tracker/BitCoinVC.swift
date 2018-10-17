//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by David E Bratton on 10/16/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit

class BitCoinVC: UIViewController {

    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var jpnLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.set(<#T##value: Double##Double#>, forKey: <#T##String#>)
        //UserDefaults.standard.set(123.56, forKey: "USD")
        //UserDefaults.standard.synchronize()
        getDefaultPrices()
        getPrice()
    }
    
    func getDefaultPrices() {
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0 {
            self.usdLabel.text = self.convertCurrency(price: usdPrice, currencyCode: "USD") + "~"
        }
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        if eurPrice != 0.0 {
            self.eurLabel.text = self.convertCurrency(price: eurPrice, currencyCode: "EUR") + "~"
        }
        let jpyPrice = UserDefaults.standard.double(forKey: "JPY")
        if jpyPrice != 0.0 {
            self.jpnLabel.text = self.convertCurrency(price: jpyPrice, currencyCode: "JPY") + "~"
        }
    }

    func convertCurrency(price: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        let priceString = formatter.string(from: NSNumber(value: price))
        return priceString ?? ""
    }
    
    func getPrice() {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        if let jsonDictionary = json {
                            DispatchQueue.main.async {
                                if let usdPrice = jsonDictionary["USD"] {
                                    //let formatter = NumberFormatter()
                                   // formatter.numberStyle = .currency
                                   // formatter.currencyCode = "USD"
                                   // let usdString = formatter.string(from: NSNumber(value: usdPrice))
                                   // self.usdLabel.text = priceString
                                    
                                    // REPLACE redundant code and pass to func
                                    self.usdLabel.text = self.convertCurrency(price: usdPrice, currencyCode: "USD")
                                    UserDefaults.standard.set(usdPrice, forKey: "USD")
                                }
                                if let eurPrice = jsonDictionary["EUR"] {
                                    self.eurLabel.text = self.convertCurrency(price: eurPrice, currencyCode: "EUR")
                                    UserDefaults.standard.set(eurPrice, forKey: "EUR")
                                }
                                if let jpyPrice = jsonDictionary["JPY"] {
                                    self.jpnLabel.text = self.convertCurrency(price: jpyPrice, currencyCode: "JPY")
                                    UserDefaults.standard.set(jpyPrice, forKey: "JPY")
                                }
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                } else {
                    print("Something went wrong")
                }
            }.resume()
        }
    }
    
    @IBAction func refreshPrice(_ sender: Any) {
        getPrice()
    }
    
}

