//
//  StocksService.swift
//  Stocks
//
//  Created by Ivan on 13/09/2018.
//  Copyright © 2018 Ivan Sorokoletov. All rights reserved.
//

import Foundation

protocol StockServiceDelegate: class
{
    func didReceivedQuote(quote: Quote)
    func didReceivedQuoteLogo(dataLogo: Data)
    func didReceivedCompaniesList(companies: [Company])
}

let hostString = "https://api.iextrading.com/1.0/stock/"

class StocksService
{
    weak var delegate: StockServiceDelegate?

    func requestQuoteLogo(for symbol: String)
    {
        let url = URL(string: "\(hostString)/\(symbol)/logo")!
        
        let dataTask = URLSession.shared.dataTask(with: url)
        {
            data, response, error
            in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    print(" ! Network error")
                    return
            }
            do {
                let quoteLogo = try JSONDecoder().decode(QuoteLogo.self, from: data)
                let logoURL = URL(string: quoteLogo.url)
                self.requestQuoteImage(for: logoURL!)
            } catch {
                print("Parsing quoteLogoModel error")
            }
        }
        dataTask.resume()
    }
    
    private func requestQuoteImage(for url: URL)
    {
        let dataTask = URLSession.shared.dataTask(with: url)
        {
            data, response, error
            in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    print(" ! Network error")
                    return
            }
            self.delegate?.didReceivedQuoteLogo(dataLogo: data)
        }
        dataTask.resume()
    }
    
    // MARK: - refresh companies
    func loadCompanies()
    {
        let companiesUrl = URL(string: "\(hostString)/market/list/infocus")!
        let dataTask = URLSession.shared.dataTask(with: companiesUrl)
        {
            
            data, response, error
            in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    print(" ! Network error")
                    return
            }
            
            do {
                let companies = try JSONDecoder().decode([Company].self,
                                                             from: data)
                DispatchQueue.main.async {
                    self.delegate?.didReceivedCompaniesList(companies:companies)
                }
            } catch {
                print("Parsing CompanyList Error: \(data)")
            }
            
           
        }
        
        dataTask.resume()
    }
    
    //MARK: - Private methods
    
    func requestQuote(for symbol: String)
    {
        let quoteUrl = URL(string: "\(hostString)/\(symbol)/quote")!
        
        let dataTask = URLSession.shared.dataTask(with: quoteUrl)
        {
            data, response, error
            in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    print(" ! Network error")
                    return
            }
            
            do {
                let quote = try JSONDecoder().decode(Quote.self, from: data)
                self.delegate?.didReceivedQuote(quote: quote)
            } catch {
                print("Parsing Quote Error: \(data)")
            }
            
        }
        dataTask.resume()
    }
}






