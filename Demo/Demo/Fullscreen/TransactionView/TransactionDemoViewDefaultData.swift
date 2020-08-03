//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public struct MotorTransactionModel: MotorTransactionViewModel {
    public var title: String
    public var header: MotorTransactionHeaderViewModel?
    public var alert: MotorTransactionAlertViewModel?
    public var steps: [MotorTransactionStepViewModel]
}

public struct MotorTransactionHeaderModel: MotorTransactionHeaderViewModel {
    public var adId: String
    public var title: String?
    public var registrationNumber: String?
    public var imagePath: String?
}

public struct MotorTransactionAlertModel: MotorTransactionAlertViewModel {
    public var title: String
    public var message: String
    public var imageIdentifier: String
}

public struct MotorTransactionStepModel: MotorTransactionStepViewModel {
    public var state: MotorTransactionStepViewState
    public var style: MotorTransactionStepView.CustomStyle?
    public var main: MotorTransactionStepContentViewModel?
    public var detail: MotorTransactionStepContentViewModel?
}

public struct MotorTransactionButtonModel: MotorTransactionButtonViewModel {
    public var text: String
    public var style: String?
    public var action: String?
    public var url: String?
    public var fallbackUrl: String?

    public init(text: String, style: String? = nil, action: String? = nil, url: String? = nil, fallbackUrl: String? = nil) {
        self.text = text
        self.style = style
        self.action = action
        self.url = url
        self.fallbackUrl = fallbackUrl
    }
}

public struct MotorTransactionStepContentModel: MotorTransactionStepContentViewModel {
    public var title: String?
    /*
     If body contains a link (<a href>), the backend will assign the same content to nativeBody, but without the (<a href>) link.
     Instead the nativeButton will also be present in the payload with the action and link as an replacement.

     This is to avoid having the client render both a link and a nativeButton.

     See line 56-66 in BothPartiesConfirmedHandoverDemoViewModel.swift as an example
    */
    public var body: NSAttributedString?
    public var nativeBody: NSAttributedString?
    public var nativeButton: MotorTransactionButtonViewModel?
    public var primaryButton: MotorTransactionButtonViewModel?
}

public struct TransactionDemoViewDefaultData {
    private var currentState = -1

    // swiftlint:disable cyclomatic_complexity
    mutating func getState() -> MotorTransactionViewModel {
        if currentState == 12 {
            self.currentState = -1
        }

        currentState += 1

        switch currentState {
        case 0:
            print("State: contract not created")
            return TransactionDemoViewDefaultData.ContractNotCreatedDemoViewModel
        case 1:
            print("State: contract created")
            return TransactionDemoViewDefaultData.ContractCreatedDemoViewModel
        case 2:
            print("State: buyer invited")
            return TransactionDemoViewDefaultData.BuyerInvitedDemoViewModel
        case 3:
            print("State: seller only signed")
            return TransactionDemoViewDefaultData.SellerOnlySignedDemoViewModel
        case 4:
            print("State: buyer only signed")
            return TransactionDemoViewDefaultData.BuyerOnlySignedDemoViewModel
        case 5:
            print("State: both parties signed")
            return TransactionDemoViewDefaultData.BothPartiesSignedDemoViewModel
        case 6:
            print("State: awaiting payment")
            return TransactionDemoViewDefaultData.AwaitingPaymentDemoViewModel
        case 7:
            print("State: payment completed")
            return TransactionDemoViewDefaultData.PaymentCompletedDemoViewModel
        case 8:
            print("State: buyer confirmed handover")
            return TransactionDemoViewDefaultData.BuyerConfirmedHandoverDemoViewModel
        case 9:
            print("State: seller confirmed handover")
            return TransactionDemoViewDefaultData.SellerConfirmedHandoverDemoViewModel
        case 10:
            print("State: payment completed - both parties confirmed handover")
            return TransactionDemoViewDefaultData.BothPartiesConfirmedHandoverDemoViewModel
        case 11:
            print("State: ad expired - show Nettbil integration")
            return TransactionDemoViewDefaultData.AdExpiredDemoViewModel
        case 12:
            print("State: payment cancelled")
            return TransactionDemoViewDefaultData.PaymentCancelledDemoViewModel
        default:
            fatalError("No model exists for step \(currentState)")
        }
    }
}
