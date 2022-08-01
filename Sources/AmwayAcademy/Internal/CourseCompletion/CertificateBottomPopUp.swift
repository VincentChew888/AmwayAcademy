//
//  CertificateBottomPopUp.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 11/03/22.
//

import SwiftUI

struct CertificateBottomPopUp: View {
    @Binding var certificateSheetState : ResizableSheetState
    @Binding var course: CourseModel
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("CertificateConfetti", bundle: AppConstants.bundle)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            VStack(alignment:.leading, spacing: 15) {
                HStack {
                    Text(StaticLabel.get("txtCertificate").uppercased())
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .extraSmall))
                     Spacer()
                     Image("CloseIcon-DarkPurple", bundle: AppConstants.bundle)
                        .onTapGesture {
                            certificateSheetState = .hidden
                        }
                        .padding(.trailing, 5)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .xxxLarge))
                       
                        .fixedSize(horizontal:false, vertical: true)
                        .lineLimit(5)
                    
                    Text("\(RootViewModel.shared.userDetails.name)")
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .medium))
                    
                    Text(course.completionDate)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .medium))
                
                }
                .padding(.bottom, 120)
               // Spacer()
            }
            .padding([.horizontal])
//            .frame(height: UIScreen.main.bounds.height/2.4, alignment: .top)
            .frame(height: 387, alignment: .top)
        }
        .padding([.bottom])
        .padding(.top, 32)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding([.horizontal, .top], 16)
        .padding(.bottom, 23)
        .foregroundColor(.darkPurple)
        .clipped(antialiased: true)
    }
   
}

struct CertificateBottomPopUp_Previews: PreviewProvider {
    static var previews: some View {
        CertificateBottomPopUp(certificateSheetState: .constant(.medium), course: .constant(CourseModel()))
    }
}
