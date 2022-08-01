//
//  WebView.swift
//  WebPoc
//
//  Created by Swapnil Tilkari on 03/03/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
  @Binding  var cookieData: CookieDataModel
    @Binding var courseID : String
    var urlRequest: URLRequest?
    let webView = WKWebView()
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date as Date, completionHandler: {
            #if DEBUG
            AmwayAppLogger.generalLogger.debug("remove all data in iOS9 later")
            #endif
        })
       // let value = #"{"name":["Vaibhav Mahajan"],"mbox":["mailto:vaibhav.mahajan@amway.com"]}"#
      //  let jsonString = "{\"name\":[\"Vaibhav Mahajan\"],\"mbox\":[\"mailto:vaibhav.mahajan@amway.com\"]}"
       // let urlEncoadedJson = jsonString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        AmwayAppLogger.generalLogger.debug(cookieData.courseUrl)
        let jsonString = "{\"account\":{\"homePage\":\"\(AppConstants.userUrl)\",\"name\":\"\(RootViewModel.shared.userDetails.amwayId)\"}}"
        let urlEncodedJson = jsonString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlWithJsonParameter = URL(string: "\(cookieData.courseUrl)?actor=\(urlEncodedJson ?? "")")
        
        if urlRequest == nil {
            if let url = urlWithJsonParameter {
                
                let request = URLRequest(url: url)
               
                AmwayAppLogger.generalLogger.debug(url.description)
                // adding header
                // request.httpMethod = "POST"
                // request.setValue(viewModel.headerName, forHTTPHeaderField: "Session")
                // adding Cokkies
                // let cookie = getCookies(url: url)
                //            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie[0])
                
                
                self.setCookies(cookieData: cookieData)
                webView.navigationDelegate = context.coordinator
                webView.load(request)
                
            }
        } else {
            self.setCookies(cookieData: cookieData)
            webView.navigationDelegate = context.coordinator
            webView.load(urlRequest!)
        }
        
        return webView
    }
    
    func setCookies(cookieData: CookieDataModel) {
        
       // /course-bltb3701822ee7858a1
        let cloudFrontPolicyCookie = HTTPCookie(properties: [
            .domain: "\(cookieData.lrsDomain)",
            .path: "/course-\(courseID)",
            .name: "CloudFront-Policy",
            .value: "\(cookieData.cloudFrontPolicy)",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!
        AmwayAppLogger.generalLogger.debug(cloudFrontPolicyCookie.description)
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cloudFrontPolicyCookie)
        AmwayAppLogger.generalLogger.debug(cloudFrontPolicyCookie.description)
        let cloudFrontKeyPairIdCookie = HTTPCookie(properties: [
            .domain: "\(cookieData.lrsDomain)",
            .path: "/course-\(courseID)",
            .name: "CloudFront-Key-Pair-Id",
            .value: "\(cookieData.cloudFrontKeyPairId)",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!
        
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cloudFrontKeyPairIdCookie)
        AmwayAppLogger.generalLogger.debug(cloudFrontPolicyCookie.description)
        let cloudFrontSignatureCookie = HTTPCookie(properties: [
            .domain: cookieData.lrsDomain,
            .path: "/course-\(courseID)",
            .name: "CloudFront-Signature",
            .value: "\(cookieData.cloudFrontSignature)",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!
        AmwayAppLogger.generalLogger.debug(cloudFrontSignatureCookie.description)
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cloudFrontSignatureCookie)
        
        let cloudFrontPolicyCookie1 = HTTPCookie(properties: [
            .domain: cookieData.lrsDomain,
            .path: "/data/xAPI",
            .name: "CloudFront-Policy",
            .value: "\(cookieData.lrsCloudFrontPolicy)",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!
        AmwayAppLogger.generalLogger.debug(cloudFrontPolicyCookie.description)
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cloudFrontPolicyCookie1)
        AmwayAppLogger.generalLogger.debug(cloudFrontPolicyCookie1.description)
        let cloudFrontKeyPairIdCookie1 = HTTPCookie(properties: [
            .domain: cookieData.lrsDomain,
            .path: "/data/xAPI",
            .name: "CloudFront-Key-Pair-Id",
            .value: "\(cookieData.lrsCloudFrontKeyPairId)",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!
        
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cloudFrontKeyPairIdCookie1)
        AmwayAppLogger.generalLogger.debug(cloudFrontPolicyCookie1.description)
        let cloudFrontSignatureCookie1 = HTTPCookie(properties: [
            .domain: cookieData.lrsDomain,
            .path: "/data/xAPI",
            .name: "CloudFront-Signature",
            .value: "\(cookieData.lrsCloudFrontSignature)",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!
        AmwayAppLogger.generalLogger.debug(cloudFrontSignatureCookie1.description)
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cloudFrontSignatureCookie1)
       
        
    }
    
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        return
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
     @Binding var viewModel: CookieDataModel
        
        init(viewModel: Binding<CookieDataModel>) {
            self._viewModel = viewModel
           // super.init()
           
       }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            AmwayAppLogger.generalLogger.debug("WebView: navigation finished")
            viewModel.didFinishLoading = true
            
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    AmwayAppLogger.generalLogger.debug(cookie.description)
                }
            }
            
          
            webView.evaluateJavaScript("document.getElementById(\"my-id\").innerHTML", completionHandler: { (jsonRaw: Any?, error: Error?) in
                guard let jsonString = jsonRaw as? String else { return }
                //  let json = JSON(parseJSON: jsonString)
                // do stuff
                AmwayAppLogger.generalLogger.debug(jsonString)
            })
            
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
            viewModel.didFinishLoading = true
            if let response = navigationResponse.response as? HTTPURLResponse {
                
                // Somehow get the response body?
                //print( response.value(forHTTPHeaderField: "Session")!)
                //                    if let val = response.value(forHTTPHeaderField: "Session") {
                //                        if val == self.viewModel.headerName {
                //
                //                            let request = URLRequest(url: URL(string: "https://www.google.com")!)
                //                            webView.load(request)
                //                        }else{
                //                            self.viewModel.outPutName = "Page Not Found"
                //                        }
                //                    }
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.targetFrame == nil {
//                webView.load(navigationAction.request)
                CourseAdaptVM.shared.otherUrlRequest = navigationAction.request
            }
        decisionHandler(.allow)
        }
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(viewModel: $cookieData)
    }
}


