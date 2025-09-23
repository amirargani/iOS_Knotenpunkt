//
//  GetDataTableCalendar.swift
//  Knotenpunkt
//
//  Created by ARGA on 25.12.22.
//

import Foundation

struct GetDataTableCalendar {
    
    func getDataCalender(completed : @escaping ([ItemsCalendar])->()) {
        // API Link
        let url = URL(string: "https://script.googleusercontent.com/macros/echo?user_content_key=ir7nju2bodgdR4ZfVdPLqXEStFd8BZaRN5z_LLmxSRmYjkQ_tZ-r8iCCa1-WvlqTTgOKR0be7SrTbD1AhwduLa6Y6rk0EQCmOJmA1Yb3SEsKFZqtv3DaNYcMrmhZHmUMWojr9NvTBuBLhyHCd5hHayInB7P1LJBgMPYRSfbHbrdF_XCV9QzsrQyJvlSBU8xyPhlKOpXbF_KTKoxaEsmUkGFGysKQQjsUbMHTgKUHcJzghnX8BuKMawXIuFltvcj9tQONWInhVK_ZzMThTeyPNB1l731hKZ3xIlReucCM-yeUAzWRtXlCMg&lib=McG-z9CZG2Hd3SuQT8NHRGXgDoiYn0zF_")
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if error != nil {
                print("An error occurred while receiving data.") // error?.localizedDescription
                return
            }
            do {
              let result = try JSONDecoder().decode(ResponseCalendar.self, from: data!)
                completed(result.itemsCalendar) // Data received successfully.
            } catch {
                
            }
        }.resume()
    }
}
