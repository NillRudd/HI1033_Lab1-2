//
//  listView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI

struct listView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Weather Forecast")
                    .foregroundColor(.white)
                    .background(.blue)
                    .padding()
                    .frame(alignment: .leading)
            }
            Text("Approved time 2022-07-14")

            
            ForEach (0..<7) { index in
                rowView(icon: "☁️")
            }
            
        }

    }
    
}

struct listView_Previews: PreviewProvider {
    static var previews: some View {
        listView()
    }
}
