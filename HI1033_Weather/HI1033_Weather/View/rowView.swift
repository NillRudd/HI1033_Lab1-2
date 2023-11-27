//
//  rowView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI

struct rowView: View {
    let timestamp: Date
    let icon : String
    let temp: Int
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(formattedDate)
                HStack{
                    Text(icon)
                    Text("\(temp) °C").font(.title2)
                }
            }

            Spacer()
        }
        
            
    }
    
    private var formattedDate: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: timestamp)
    }
    
}

struct rowView_Previews: PreviewProvider {
    static var previews: some View {
        rowView(timestamp: Date.now , icon: "🌞", temp: 15)
    }
}
