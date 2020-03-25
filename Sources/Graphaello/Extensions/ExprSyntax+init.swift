//
//  ExprSyntaxProtocol+init.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import SwiftSyntax

extension IdentifierExprSyntax {

    init(identifier: String) {
        let identifier = SyntaxFactory.makeIdentifier(identifier)
        self = IdentifierExprSyntax { builder in
            builder.useIdentifier(identifier)
        }
    }

}

extension SequenceExprSyntax {

    init(lhs: ExprSyntaxProtocol, rhs: ExprSyntaxProtocol, binaryOperator: BinaryOperatorExprSyntax) {
        self = SequenceExprSyntax { builder in
            builder.addElement(lhs.erased())
            builder.addElement(binaryOperator.erased())
            builder.addElement(rhs.erased())
        }
    }

}

extension ArrayExprSyntax {

    init(expressions: [ExprSyntaxProtocol]) {
        let leftSquare = SyntaxFactory.makeLeftSquareBracketToken()
        let rightSquare = SyntaxFactory.makeRightSquareBracketToken()
        self = ArrayExprSyntax { builder in
            builder.useLeftSquare(leftSquare)
            expressions.forEach { expression, isLast in
                builder.addElement(ArrayElementSyntax(expression: expression,
                                                      useTrailingComma: !isLast))
            }
            builder.useRightSquare(rightSquare)
        }
    }

}

extension BinaryOperatorExprSyntax {

    init(text: String) {
        let token = SyntaxFactory.makeSpacedBinaryOperator(text, leadingTrivia: .spaces(1), trailingTrivia: .spaces(1))
        self = BinaryOperatorExprSyntax { builder in
            builder.useOperatorToken(token)
        }
    }

}


extension ArrayElementSyntax {

    init(expression: ExprSyntaxProtocol, useTrailingComma: Bool) {
        let comma = SyntaxFactory.makeCommaToken()
        self = ArrayElementSyntax { builder in
            builder.useExpression(expression.erased())
            if useTrailingComma {
                builder.useTrailingComma(comma)
            }
        }
    }

}

extension MemberAccessExprSyntax {

    init(base: ExprSyntaxProtocol?, name: String) {
        let dot = SyntaxFactory.makePeriodToken()
        let name = SyntaxFactory.makeIdentifier(name)
        self = MemberAccessExprSyntax { builder in
            if let base = base {
                builder.useBase(base.erased())
            }
            builder.useDot(dot)
            builder.useName(name)
        }
    }

}

extension FunctionCallExprSyntax {

    init(target: ExprSyntaxProtocol, arguments: [(String?, ExprSyntaxProtocol)]) {
        let leftParen = SyntaxFactory.makeLeftParenToken()
        let rightParen = SyntaxFactory.makeRightParenToken()

        self = FunctionCallExprSyntax { builder in
            builder.useCalledExpression(target.erased())
            builder.useLeftParen(leftParen)
            arguments.forEach { argument, isLast in
                builder.addArgument(TupleExprElementSyntax(name: argument.0,
                                                           value: argument.1,
                                                           useTrailingComma: !isLast))
            }
            builder.useRightParen(rightParen)
        }
    }

}

extension TupleExprElementSyntax {

    init(name: String?, value: ExprSyntaxProtocol, useTrailingComma: Bool) {
        let comma = SyntaxFactory.makeCommaToken()

        self = TupleExprElementSyntax { builder in
            if let name = name {
                let label = SyntaxFactory.makeIdentifier(name)
                let colon = SyntaxFactory.makeColonToken()

                builder.useLabel(label)
                builder.useColon(colon)
            }

            builder.useExpression(value.erased())
            if useTrailingComma {
                builder.useTrailingComma(comma)
            }
        }
    }

}

extension Collection {

    fileprivate func forEach(_ body: (Element, Bool) throws -> Void) rethrows {
        let lastIndex = index(endIndex, offsetBy: -1)
        try indices.forEach { index in
            try body(self[index], index == lastIndex)
        }
    }

}

extension ExprSyntaxProtocol {

    func erased() -> ExprSyntax {
        return ExprSyntax(self)
    }

}
