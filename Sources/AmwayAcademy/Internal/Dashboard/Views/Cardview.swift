//
//  Cardview.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 27/01/22.
//

import SwiftUI

struct Cardview: View {
    var image: String
    var title: String
    var city: String
    var des: String
    
    var body: some View {
        
        VStack {
            
            Image(image, bundle: AppConstants.bundle)
            .resizable()
            .aspectRatio(contentMode: .fit)
                .padding(.bottom)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                
                Text(title)
                    .font(.title)
                    .fontWeight(.black)
                
                Text(city)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(des)
                    .foregroundColor(.secondary)
                   .lineLimit(3)
                
                }.layoutPriority(100)
                
                Spacer()
                
            }.padding()
            
        }
    .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1))
        .padding()
    }
}

struct Cardview_Previews: PreviewProvider {
    static var previews: some View {
        Cardview(image: "redfort", title: "The Red Fort", city: "Delhi", des: "Established  as Shahjahanabad in 1648, The Red Fort was known as the capital of the Mughal Empire in India. Its construction is attributed to Shah Jahan who also built the famous Taj Mahal in Agra, and was also known by the name Quila Mubarak and remained the residence of the Mughal Imperial family for nearly 20 decades.")
    }
}
