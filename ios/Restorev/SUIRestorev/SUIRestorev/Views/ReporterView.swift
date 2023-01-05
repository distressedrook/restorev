//
//  ReporterView.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 04/01/23.
//

import SwiftUI
import SwiftMessages

struct ReporterView: UIViewRepresentable {
    func makeUIView(context: Context) -> MessageView {
        let view = MessageView.viewFromNib(layout: .cardView)
        if self.type == .success {
            view.configureTheme(.success)
        } else {
            view.configureTheme(.error)
        }
        view.button?.isHidden = true
        view.configureDropShadow()
        view.iconLabel?.isHidden = true
        view.configureContent(title: title, body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 24, left: 8, bottom: 24, right: 8)
        return view
    }

    func updateUIView(_ uiView: MessageView, context: Context) {

    }

    typealias UIViewType = MessageView

    enum MessageType {
        case success
        case failure
    }
    let type: MessageType
    let message: String
    let title: String

}

struct ReporterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReporterView(type: .success, message: "Success!", title: "Yay")
                .frame(height: 100)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Success")

            ReporterView(type: .failure, message: "Failure!", title: "Nay")
                .frame(height: 100)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Failure")
        }

    }
}
