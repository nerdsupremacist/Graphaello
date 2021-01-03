
import Foundation
import SwiftSyntax
import SourceKittenFramework

private let swiftUIViewProtocols: Set<String> = ["View"]

struct UnusedWarningDiagnoser: WarningDiagnoser {
    func diagnose(parsed: Struct<Stage.Parsed>) throws -> [Warning] {
        guard !swiftUIViewProtocols.intersection(parsed.inheritedTypes).isEmpty else {
            return []
        }

        return try parsed.properties.flatMap { try diagnose(property: $0, from: parsed) }
    }

    private func diagnose(property: Property<Stage.Parsed>, from parsed: Struct<Stage.Parsed>) throws -> [Warning] {
        guard property.graphqlPath != nil else { return [] }


        let path = property.code.location.file.absoluteURL.path
        let arguments = ["-sdk", sdkPath(), "-j4", path]

        let request: SourceKitObject = [
            "key.request": UID("source.request.editor.open"),
            "key.name": path,
            "key.sourcefile": path,
            "key.annotated_decl": 1,
            "key.fully_annotated_decl": 1,
            "key.compilerargs": arguments,
        ]
        let info = try Request.customRequest(request: request).send()

        var verifier = UsageVerifier(property: property)

//        for substructure in try parsed.code.substructure() {
//            switch try substructure.kind() {
//            case .varInstance:
////                verifier.verify(syntax: try substructure.syntaxTree())
//            case .functionMethodInstance:
////                verifier.verify(syntax: try substructure.syntaxTree())
//            default:
//                break
//            }
//        }

        guard !verifier.isUsed else { return [] }
        return [Warning(location: property.code.location,
                        descriptionText: "Unused Property `\(property.name)` belongs to a View and is fetching data from GraphQL. This can be wasteful. Consider using it or removing the property.")]
    }
}

struct UsageVerifier {
    let property: Property<Stage.Parsed>

    private(set) var shouldUseSelf = false
    private(set) var isUsed = false

    mutating func verify(syntax: SyntaxProtocol) {
        verify(syntax: syntax._syntaxNode)
    }

    mutating func verify(syntax: Syntax) {
        guard !isUsed else { return }

        let asEnum = syntax.as(SyntaxEnum.self)
        switch asEnum {
        case .unknown:
            return
        case .token:
            return
        case .decl(let decl):
            print(decl)
        case .expr(let expr):
            print(expr)
        case .stmt(let stmt):
            print(stmt)
        case .type:
            return
        case .pattern(let pattern):
            print(pattern)
        case .unknownDecl(let decl):
            print(decl)
        case .unknownExpr(let expr):
            print(expr)
        case .unknownStmt(let stmt):
            print(stmt)
        case .unknownType:
            return
        case .unknownPattern(let pattern):
            print(pattern)
        case .codeBlockItem(let item):
            print(item)
        case .codeBlockItemList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .codeBlock(let block):
            print(block)
        case .inOutExpr:
            return
        case .poundColumnExpr(let expr):
            print(expr)
        case .tupleExprElementList(let tuple):
            print(tuple)
        case .arrayElementList(let arrayElementList):
            print(arrayElementList)
        case .dictionaryElementList(let dictionaryElementList):
            print(dictionaryElementList)
        case .stringLiteralSegments(let segments):
            print(segments)
        case .tryExpr(let expr):
            print(expr)
        case .declNameArgument(let decl):
            print(decl)
        case .declNameArgumentList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .declNameArguments(let list):
            print(list)
        case .identifierExpr(let identifier):
            print(identifier)
        case .superRefExpr:
            return
        case .nilLiteralExpr:
            return
        case .discardAssignmentExpr:
            return
        case .assignmentExpr(let assignment):
            print(assignment)
        case .sequenceExpr(let sequence):
            print(sequence)
        case .exprList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .poundLineExpr(let expr):
            print(expr)
        case .poundFileExpr(let expr):
            print(expr)
        case .poundFileIDExpr(let expr):
            print(expr)
        case .poundFilePathExpr(let expr):
            print(expr)
        case .poundFunctionExpr(let expr):
            print(expr)
        case .poundDsohandleExpr(let expr):
            print(expr)
        case .symbolicReferenceExpr(let expr):
            print(expr)
        case .prefixOperatorExpr(let expr):
            print(expr)
        case .binaryOperatorExpr(let expr):
            print(expr)
        case .arrowExpr(let expr):
            print(expr)
        case .floatLiteralExpr(let expr):
            print(expr)
        case .tupleExpr(let expr):
            print(expr)
        case .arrayExpr(let expr):
            print(expr)
        case .dictionaryExpr(let expr):
            print(expr)
        case .tupleExprElement(let expr):
            print(expr)
        case .arrayElement(let expr):
            print(expr)
        case .dictionaryElement(let expr):
            print(expr)
        case .integerLiteralExpr(let expr):
            print(expr)
        case .booleanLiteralExpr(let expr):
            print(expr)
        case .ternaryExpr(let expr):
            print(expr)
        case .memberAccessExpr(let expr):
            print(expr)
        case .isExpr(let expr):
            print(expr)
        case .asExpr(let expr):
            print(expr)
        case .typeExpr(let expr):
            print(expr)
        case .closureCaptureItem(let expr):
            print(expr)
        case .closureCaptureItemList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .closureCaptureSignature(let expr):
            print(expr)
        case .closureParam(let expr):
            print(expr)
        case .closureParamList(let expr):
            print(expr)
        case .closureSignature(let expr):
            print(expr)
        case .closureExpr(let expr):
            print(expr)
        case .unresolvedPatternExpr(let expr):
            print(expr)
        case .multipleTrailingClosureElement(let expr):
            print(expr)
        case .multipleTrailingClosureElementList(let expr):
            print(expr)
        case .functionCallExpr(let expr):
            print(expr)
        case .subscriptExpr(let expr):
            print(expr)
        case .optionalChainingExpr(let expr):
            print(expr)
        case .forcedValueExpr(let expr):
            print(expr)
        case .postfixUnaryExpr(let expr):
            print(expr)
        case .specializeExpr(let expr):
            print(expr)
        case .stringSegment(let expr):
            print(expr)
        case .expressionSegment(let expr):
            print(expr)
        case .stringLiteralExpr(let expr):
            print(expr)
        case .keyPathExpr(let expr):
            print(expr)
        case .keyPathBaseExpr(let expr):
            print(expr)
        case .objcNamePiece(let expr):
            print(expr)
        case .objcName(let expr):
            print(expr)
        case .objcKeyPathExpr(let expr):
            print(expr)
        case .objcSelectorExpr(let expr):
            print(expr)
        case .editorPlaceholderExpr(let expr):
            print(expr)
        case .objectLiteralExpr(let expr):
            print(expr)
        case .typeInitializerClause(let expr):
            print(expr)
        case .typealiasDecl(let expr):
            print(expr)
        case .associatedtypeDecl(let expr):
            print(expr)
        case .functionParameterList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .parameterClause(let expr):
            print(expr)
        case .returnClause(let expr):
            print(expr)
        case .functionSignature(let expr):
            print(expr)
        case .ifConfigClause(let expr):
            print(expr)
        case .ifConfigClauseList(let expr):
            print(expr)
        case .ifConfigDecl(let expr):
            print(expr)
        case .poundErrorDecl(let expr):
            print(expr)
        case .poundWarningDecl(let expr):
            print(expr)
        case .poundSourceLocation(let expr):
            print(expr)
        case .poundSourceLocationArgs(let expr):
            print(expr)
        case .declModifier(let expr):
            print(expr)
        case .inheritedType(let expr):
            print(expr)
        case .inheritedTypeList(let expr):
            print(expr)
        case .typeInheritanceClause(let expr):
            print(expr)
        case .classDecl(let expr):
            print(expr)
        case .structDecl(let expr):
            print(expr)
        case .protocolDecl(let expr):
            print(expr)
        case .extensionDecl(let expr):
            print(expr)
        case .memberDeclBlock(let expr):
            print(expr)
        case .memberDeclList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .memberDeclListItem(let expr):
            print(expr)
        case .sourceFile(let file):
            for item in file.statements {
                verify(syntax: item)
            }
        case .initializerClause(let expr):
            print(expr)
        case .functionParameter(let expr):
            print(expr)
        case .modifierList:
            return
        case .functionDecl(let expr):
            print(expr)
        case .initializerDecl(let expr):
            print(expr)
        case .deinitializerDecl(let expr):
            print(expr)
        case .subscriptDecl(let expr):
            print(expr)
        case .accessLevelModifier(let expr):
            print(expr)
        case .accessPathComponent(let expr):
            print(expr)
        case .accessPath(let expr):
            print(expr)
        case .importDecl:
            return
        case .accessorParameter(let expr):
            print(expr)
        case .accessorDecl(let expr):
            print(expr)
        case .accessorList(let list):
            for item in list {
                verify(syntax: list)
            }
        case .accessorBlock(let expr):
            print(expr)
        case .patternBinding(let expr):
            print(expr)
        case .patternBindingList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .variableDecl(let expr):
            print(expr)
        case .enumCaseElement(let expr):
            print(expr)
        case .enumCaseElementList(let expr):
            print(expr)
        case .enumCaseDecl(let expr):
            print(expr)
        case .enumDecl(let expr):
            print(expr)
        case .operatorDecl(let expr):
            print(expr)
        case .identifierList(let list):
            for item in list {
                verify(syntax: item)
            }
        case .operatorPrecedenceAndTypes:
            return
        case .precedenceGroupDecl:
            return
        case .precedenceGroupAttributeList:
            return
        case .precedenceGroupRelation:
            return
        case .precedenceGroupNameList:
            return
        case .precedenceGroupNameElement:
            return
        case .precedenceGroupAssignment:
            return
        case .precedenceGroupAssociativity:
            return
        case .tokenList(let expr):
            print(expr)
        case .nonEmptyTokenList(let expr):
            print(expr)
        case .customAttribute(let expr):
            print(expr)
        case .attribute(let expr):
            print(expr)
        case .attributeList(let expr):
            print(expr)
        case .specializeAttributeSpecList(let expr):
            print(expr)
        case .labeledSpecializeEntry(let expr):
            print(expr)
        case .namedAttributeStringArgument(let expr):
            print(expr)
        case .declName(let expr):
            print(expr)
        case .implementsAttributeArguments(let expr):
            print(expr)
        case .objCSelectorPiece(let expr):
            print(expr)
        case .objCSelector(let expr):
            print(expr)
        case .differentiableAttributeArguments(let expr):
            print(expr)
        case .differentiabilityParamsClause(let expr):
            print(expr)
        case .differentiabilityParams(let expr):
            print(expr)
        case .differentiabilityParamList(let expr):
            print(expr)
        case .differentiabilityParam(let expr):
            print(expr)
        case .derivativeRegistrationAttributeArguments(let expr):
            print(expr)
        case .qualifiedDeclName(let expr):
            print(expr)
        case .functionDeclName(let expr):
            print(expr)
        case .continueStmt(let expr):
            print(expr)
        case .whileStmt(let expr):
            print(expr)
        case .deferStmt(let expr):
            print(expr)
        case .expressionStmt(let expr):
            print(expr)
        case .switchCaseList(let expr):
            print(expr)
        case .repeatWhileStmt(let expr):
            print(expr)
        case .guardStmt(let expr):
            print(expr)
        case .whereClause(let expr):
            print(expr)
        case .forInStmt(let expr):
            print(expr)
        case .switchStmt(let expr):
            print(expr)
        case .catchClauseList(let expr):
            print(expr)
        case .doStmt(let expr):
            print(expr)
        case .returnStmt(let expr):
            print(expr)
        case .yieldStmt(let expr):
            print(expr)
        case .yieldList(let expr):
            print(expr)
        case .fallthroughStmt(let expr):
            print(expr)
        case .breakStmt(let expr):
            print(expr)
        case .caseItemList(let expr):
            print(expr)
        case .catchItemList(let expr):
            print(expr)
        case .conditionElement(let expr):
            print(expr)
        case .availabilityCondition(let expr):
            print(expr)
        case .matchingPatternCondition(let expr):
            print(expr)
        case .optionalBindingCondition(let expr):
            print(expr)
        case .conditionElementList(let expr):
            print(expr)
        case .declarationStmt(let expr):
            print(expr)
        case .throwStmt(let expr):
            print(expr)
        case .ifStmt(let expr):
            print(expr)
        case .elseIfContinuation(let expr):
            print(expr)
        case .elseBlock(let expr):
            print(expr)
        case .switchCase(let expr):
            print(expr)
        case .switchDefaultLabel(let expr):
            print(expr)
        case .caseItem(let expr):
            print(expr)
        case .catchItem(let expr):
            print(expr)
        case .switchCaseLabel(let expr):
            print(expr)
        case .catchClause(let expr):
            print(expr)
        case .poundAssertStmt(let expr):
            print(expr)
        case .genericWhereClause(_):
            return
        case .genericRequirementList(_):
            return
        case .genericRequirement(_):
            return
        case .sameTypeRequirement(_):
            return
        case .genericParameterList(_):
            return
        case .genericParameter(_):
            return
        case .genericParameterClause(_):
            return
        case .conformanceRequirement(_):
            return
        case .simpleTypeIdentifier(_):
            return
        case .memberTypeIdentifier(_):
            return
        case .classRestrictionType(_):
            return
        case .arrayType(_):
            return
        case .dictionaryType(_):
            return
        case .metatypeType(_):
            return
        case .optionalType(_):
            return
        case .someType(_):
            return
        case .implicitlyUnwrappedOptionalType(_):
            return
        case .compositionTypeElement(_):
            return
        case .compositionTypeElementList(_):
            return
        case .compositionType(_):
            return
        case .tupleTypeElement(_):
            return
        case .tupleTypeElementList(_):
            return
        case .tupleType(_):
            return
        case .functionType(_):
            return
        case .attributedType(_):
            return
        case .genericArgumentList(_):
            return
        case .genericArgument(_):
            return
        case .genericArgumentClause(_):
            return
        case .typeAnnotation(let expr):
            print(expr)
        case .enumCasePattern(let expr):
            print(expr)
        case .isTypePattern(let expr):
            print(expr)
        case .optionalPattern(let expr):
            print(expr)
        case .identifierPattern(let expr):
            print(expr)
        case .asTypePattern(let expr):
            print(expr)
        case .tuplePattern(let expr):
            print(expr)
        case .wildcardPattern(let expr):
            print(expr)
        case .tuplePatternElement(let expr):
            print(expr)
        case .expressionPattern(let expr):
            print(expr)
        case .tuplePatternElementList(let expr):
            print(expr)
        case .valueBindingPattern(let expr):
            print(expr)
        case .availabilitySpecList(let expr):
            print(expr)
        case .availabilityArgument(let expr):
            print(expr)
        case .availabilityLabeledArgument(let expr):
            print(expr)
        case .availabilityVersionRestriction(let expr):
            print(expr)
        case .versionTuple(let expr):
            print(expr)
        }
    }
}
