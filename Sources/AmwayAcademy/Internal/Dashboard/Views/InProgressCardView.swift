//
//  InProgressCardView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 24/01/22.
//

import SwiftUI


//struct InProgressView: View {
//
//    @State private var index = 0
//    var body: some View {
//
//        VStack {
//            TabView(selection: $index) {
//                ForEach((0..<3), id: \.self) { index in
//                    InProgressCardView()
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            HStack(spacing: 10) {
//                ForEach((0..<3), id: \.self) { index in
//                    Circle()
//                        .fill(index == self.index ? Color.darkPurple : Color.outlinePurple)
//                        .frame(width: 10, height: 10)
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//
//
//
//struct InProgressCardView: View {
//
//    private var courseImageURL: String = ""
//    private var courseTitle: String = "Selling Balance Within™️ Probiotics to Build Your Business"
//    private var courseDuration: String = "1h 15m"
//    private var coursesCount: String = "10 Courses"
//    @State var progressValue: Float = 0.1
//
//    var body: some View {
//
//
////        ZStack {
//        GeometryReader { gp in
//
//
//                VStack(alignment: .leading) {
//
//                    ZStack(alignment: .top) {
//                        Image("Course", bundle: AppConstants.bundle)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: gp.size.width)
//        //Uncomment below code once we get the image URL from the API.
//    //                    AsyncImage(url: URL(string: "https://assetscdn1.paytm.com/images/catalog/product/L/LA/LAPGANDIVA-ECONNALL1088566365C7F92/1615367285787_0..jpg?imwidth=320&impolicy=hq"), content: { image in
//    //                            image.resizable()
//    //                                 .aspectRatio(contentMode: .fit)
//    ////                                 .frame(maxWidth: 300, maxHeight: 100)
//    //                        },
//    //                        placeholder: {
//    //                          ProgressView()
//    //                        }
//    //                    )
//
//                        VStack() {
//                            HStack {
//                                Spacer()
//                                Button {
//                                    print("Delete Button pressed")
//                                } label: {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color.white)
//                                            .frame(width: 25, height: 25)
//                                        Image("CloseBlackIcon", bundle: AppConstants.bundle)
//                                            .renderingMode(.original)
//                                    }
//                                }
//                                .padding([.top, .trailing])
//                            }
//                        }
//                    }
////
//                    .padding(.bottom)
//                    Spacer()
//                        .frame(height: 20)
//                    Text(courseTitle)
//                        .font(.gtWalsheimBoldWithSizeBold24)
//                        .lineLimit(3)
//                        .foregroundColor(.amwayBlack)
//                        .padding([.leading, .trailing, .bottom])
//                        .layoutPriority(1)
//                    HStack {
//                        Label(courseDuration, image: "LoadIcon")
//                            .font(.gtWalsheimMediumWithSizeMedium14)
//                            .foregroundColor(.darkPurple)
//                            .padding(.leading)
//                        Spacer()
//                    }
//                    ProgressBar(value: $progressValue)
//                        .frame(height: 10)
//                        .padding([.leading, .trailing, .bottom])
//                }
//
//
//        }
//            .background(Color.white)
//            .cornerRadius(12)
////        }
//    }
//}
//
//struct ProgressBar: View {
//    @Binding var value: Float
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
//                    .opacity(0.3)
//                    .foregroundColor(Color(UIColor.systemTeal))
//
//                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
//                    .foregroundColor(Color(UIColor.systemBlue))
//                    .animation(.linear, value: value)
//            }.cornerRadius(5.0)
//        }
//    }
//}


//struct InProgressCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        InProgressCardView()
//    }
//}
