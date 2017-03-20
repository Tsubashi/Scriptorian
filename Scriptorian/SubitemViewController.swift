//
// Copyright © 2017 Hilton Campbell. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit
import WebKit
import LDSContent
import Swiftification
import SVProgressHUD

class SubitemViewController: UIViewController {
    let contentController: ContentController
    let itemID: Int64
    let subitemID: Int64

    init(contentController: ContentController, itemID: Int64, subitemID: Int64) {
        self.contentController = contentController
        self.itemID = itemID
        self.subitemID = subitemID

        super.init(nibName: nil, bundle: nil)

        automaticallyAdjustsScrollViewInsets = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentController.itemPackageInstallObservers.add(self, operationQueue: .main, type(of: self).itemPackageDidUpdate)
        reloadData()
    }

    func reloadData() {
        if let itemPackage = contentController.itemPackageForItemWithID(itemID),
            let subitem = itemPackage.subitemWithID(subitemID),
            let subitemContent = itemPackage.subitemContentWithSubitemID(subitemID) {
            title = subitem.title
            webView.load(subitemContent.contentHTML, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: itemPackage.url)
        } else {
            title = nil
            webView.loadHTMLString("", baseURL: nil)
        }
    }

    func itemPackageDidUpdate(_ item: Item) {
        guard item.id == itemID else { return }

        reloadData()
    }
}
