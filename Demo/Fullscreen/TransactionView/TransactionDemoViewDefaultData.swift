//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public struct TransactionModel: TransactionViewModel {
    public var title: String
    public var header: TransactionHeaderViewModel
    public var alert: TransactionWarningViewModel
    public var steps: [TransactionStepViewModel]
}

public struct TransactionHeaderModel: TransactionHeaderViewModel {
    public var adId: String
    public var title: String
    public var registrationNumber: String?
    public var imageUrlString: String?
}

public struct TransactionWarningModel: TransactionWarningViewModel {
    public var title: String
    public var message: String
    public var imageUrlString: String?
}

public struct TransactionStepModel: TransactionStepViewModel {
    public var state: TransactionStepViewState
    public var title: String
    public var body: String?
    public var primaryButton: TransactionStepPrimaryButtonViewModel?
    public var detail: String?
}

public struct TransactionStepPrimaryButtonModel: TransactionStepPrimaryButtonViewModel {
    public var text: String
    public var style: String
    public var action: String?
    public var urlString: String?
    public var fallbackUrlString: String?
}

public struct TransactionDemoViewDefaultData {
    private var currentState = 0

    mutating func getState() -> TransactionViewModel {
        if currentState == 10 {
            self.currentState = 0
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
        default:
            fatalError("No model exists for step \(currentState)")
        }
    }
}
