//
//  rowView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI

struct rowView: View {
    let icon : String
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("2000-07-14 11:00")
                    
                HStack{
                    Text(icon)
                    Text("14 °C").font(.title2)
                }
            }

            
        }
    }
}

struct rowView_Previews: PreviewProvider {
    static var previews: some View {
        rowView(icon: "🌞")
    }
}
