//
//  GetDataTable.swift
//  Knotenpunkt
//
//  Created by ARGA on 21.12.22.
//

import Foundation

struct GetDataTableGodiplan {
    
    func getData(completed : @escaping ([Items])->()) {
        // API Link
        let url = URL(string: "https://script.googleusercontent.com/macros/echo?user_content_key=pq0rnAYO1fi-4oW8zplQyKdyO08tQui41DzX3rf6y0nVoTINTQG9SqOXrnWA9rYhlv9f6vSOtmq73aRbPgqHe1ShI5yKpKr7OJmA1Yb3SEsKFZqtv3DaNYcMrmhZHmUMWojr9NvTBuBLhyHCd5hHayZSCDAHUVSS3mVMVcRfiL6hN20gGJMisUYvTU_7v0teBLrBjhYScG4gLjS63dHeAmzu1bj1WdWPuTVbok-WcQwHddikmKHrEgtBHn44AOQPwcXmMXNw05t6IbBiDp_8zivdKcc0_27Xk2DCad7QGfiZYEw2G65thWE9_kKVCpQd&lib=MqKIGfITGTyTFj6oX42_urt25AROQb3Av")
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if error != nil {
                print("An error occurred while receiving data.") // error?.localizedDescription
                return
            }
            do {
              let result = try JSONDecoder().decode(Response.self, from: data!)
                completed(result.items) // Data received successfully.
            } catch {
                
            }
        }.resume()
    }
}
