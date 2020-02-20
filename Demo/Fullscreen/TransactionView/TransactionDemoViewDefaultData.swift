//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public struct TransactionStepModel: TransactionStepViewModel {
    public var state: TransactionState
    public var title: String
    public var body: String?
    public var buttonText: String?
    public var detail: String?
}

public struct TransactionStepsFactory {
    public static var steps: [TransactionStepModel] = completedSteps + currentStep + notStartedSteps
    public static var numberOfSteps: Int = completedSteps.count + currentStep.count + notStartedSteps.count

    public static var completedSteps: [TransactionStepModel] = [
        TransactionStepModel(
            state: .completed,
            title: "Annonsen er lagt ut",
            buttonText: "Se annonsen"),

        TransactionStepModel(
            state: .completed,
            title: "Kontrakt",
            body: "Du har opprettet kontrakt.",
            buttonText: "Inviter kjøper"),
    ]

    public static var currentStep = [TransactionStepModel(
        state: .inProgress,
        title: "Betaling",
        body: "Før kjøper kan overføre pengene må du forberede betalingen.",
        buttonText: "Forbered betaling")
    ]

    public static var currentStepAwaitingOtherParty = [TransactionStepModel(
        state: .inProgress,
        title: "Betaling",
        body: "Før kjøper kan overføre pengene må du forberede betalingen.",
        buttonText: "Forbered betaling")
    ]

    public static var notStartedSteps: [TransactionStepModel] = [
        TransactionStepModel(
            state: .notStarted,
            title: "Overlevering",
            body: "Dere må møtes og bekrefte overleveringen innen 7 dager etter kjøper har betalt."),

        TransactionStepModel(
            state: .notStarted,
            title: "Gratulerer med salget!",
            body: "Du kan finne igjen bilen i Mine kjøretøy under <<Eide før>>.",
            detail: "Det kan ta noen dager før pengene dukker opp på kontoen din"),
    ]
}
