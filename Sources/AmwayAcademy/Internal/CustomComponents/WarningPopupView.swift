//
//  WarningPopupView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 11/04/22.
//

import SwiftUI

struct WarningPopupView: View {
    @Binding var showWarningPopup: Bool
    var title: String
    var description: String
    
    var imgName: String = "ExploreWarningIcon"
    var backgroundColor: Color = Color.alertLightOrange
    var textColor: Color = Color.alertOrange
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .top, spacing: 8) {
                
                Image(imgName, bundle: AppConstants.bundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(textColor)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                        .padding(.bottom, 2)
                    
                    Text(description)
                        .foregroundColor(textColor)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                }
                
                Spacer()
                
                Button(action: {
                    showWarningPopup = false
                }) {
                    Image("ExploreAlertCloseIcon", bundle: AppConstants.bundle)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                }
                
            }
            .padding(10)
            
//            if showWarningPopup {
//                VStack{}.onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
//                        showWarningPopup = false
//                    }
//                }
//            }
            
        }
        .background(backgroundColor)
        .customRoundedRectangleOverlay(cornerRadius: 12, color: .alertOutlineOrange, lineWidth: 1.0)
        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .padding(.top, 25)
        .padding(.horizontal, 10)
    }
}

class WarningPopupVM: ObservableObject {
    static var shared = WarningPopupVM()
    
    @Published var showWarningPopup: Bool = false
    @Published var title: String = ""
    @Published var description: String = ""
    private var dissmissTime: DispatchTime = .now()
    
    /// Anywhere you need to show warning popup, just use this method. Note: Will be displayed under sheets.
    func show(title: String, desc: String) {
        self.description = desc
        self.title = title
        self.showWarningPopup = true
        dissmissTime = .now()+3.0
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
            if  .now() >= self.dissmissTime {
                self.showWarningPopup = false
            }
        }
    }
}

//struct ExploreFilterNoCoursesView_Previews: PreviewProvider {
//    static var previews: some View {
//        WarningPopupView(showWarningPopup: .constant(false))
//    }
//}
