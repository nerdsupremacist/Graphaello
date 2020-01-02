//
//  PipelineFactory.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

enum PipelineFactory {
    
    static func create() -> Pipeline {
        return BasicPipeline(extractor: create(),
                             parser: create(),
                             validator: create(),
                             resolver: create(),
                             cleaner: create(),
                             assembler: create(),
                             preparator: create(),
                             generator: create())
    }
    
    private static func create() -> Extractor {
        return BasicExtractor(extractor: BasicStructExtractor(propertyExtractor: BasicPropertyExtractor(attributeExtractor: BasicAttributeExtractor())))
    }
    
    private static func create() -> Parser {
        return BasicParser {
            .attribute {
                .syntaxTree {
                    .annotationFunctionCall {
                        .pathExpression(
                            memberAccess: { (parent: SubParser<ExprSyntax, Stage.Parsed.Path>) -> SubParser<MemberAccessExprSyntax, Stage.Parsed.Path> in
                                .memberAccess(parent: parent) {
                                    .baseMemberAccess()
                                }
                            },
                            functionCall: { (parent: SubParser<ExprSyntax, Stage.Parsed.Path>) in
                                .functionCall(parent: parent) {
                                    .argumentList {
                                        .argumentExpression(
                                            memberAccess: {
                                                .memberAccess()
                                            },
                                            functionCall: {
                                                .functionCall {
                                                    .queryArgumentExpression(
                                                        memberAccess: {
                                                            .memberAccess()
                                                        },
                                                        functionCall: {
                                                            .functionCall()
                                                        }
                                                    )
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        )
                    }
                }
            }
        }
    }
    
    private static func create() -> Validator {
        return BasicValidator {
            BasicPathValidator {
                BasicComponentValidator {
                    BasicGraphQLToSwiftTranspiler()
                }
            }
        }
    }
    
    private static func create() -> Resolver {
        return BasicResolver {
            BasicStructResolver(resolver: {
                StructPropertiesResolver {
                    PropertyResolver {
                        PathResolver()
                    }
                }
            }, collector: {
                BasicResolvedStructCollector {
                    ResolvedPropertyCollector {
                        ResolvedComponentCollector()
                    }
                }
            })
        }
    }

    private static func create() -> Cleaner {
        return BasicCleaner(
            argumentCleaner: {
                BasicArgumentCleaner(
                    argumentCleaner: GraphQLArgumentCleaner().any(),
                    fieldCleaner: FieldArgumentCleaner().any(),
                    componentCleaner: { GraphQLComponentCleaner(objectCleaner: $0).any() },
                    fragmentCleaner: { GraphQLFragmenrCleaner(objectCleaner: $0).any() },
                    typeConditionalCleaner: { GraphQLTypeConditionalCleaner(objectCleaner: $0).any() },
                    objectCleaner: { GraphQLObjectCleaner(argumentCleaner: $0,
                                                          componentsCleaner: $1,
                                                          fragmentCleaner: $2,
                                                          typeConditionalCleaner: $3).any() },
                    queryCleaner: { GraphQLQueryCleaner(componentsCleaner: $0).any() },
                    connectionQueryCleaner: { GraphQLConnectionQueryCleaner(queryCleaner: $0).any() }
                ).any()
            },
            fieldNameCleaner: {
                BasicFieldNameCleaner(
                    objectCleaner: GraphQLObjectFieldNameCleaner {
                        BasicFieldNameAliasNamer()
                    }.any(),
                    fragmentCleaner: { FragmentFieldNameCleaner(objectCleaner: $0).any() },
                    queryCleaner: { GraphQLQueryFieldNameCleaner(objectCleaner: $0).any() }
                ).any()
            },
            aliasPropagator: {
                BasicPropertyAliasingPropagator {
                    BasicComponentAliasingPropagator()
                }
            }
        )
    }
    
    private static func create() -> Assembler {
        return BasicAssembler {
            BasicRequestAssembler()
        }
    }
    
    private static func create() -> Preparator {
        return BasicPreparator {
            BasicApolloCodegenRequestProcessor {
                BasicApolloProcessInstantiator()
            }
        }
    }
    
    private static func create() -> Generator {
        return BasicGenerator()
    }
}

// MARK: Little help for the compiler

extension SubParser {
    
    fileprivate static func pathExpression(memberAccess: @escaping (SubParser<ExprSyntax, Stage.Parsed.Path>) -> SubParser<MemberAccessExprSyntax, Stage.Parsed.Path>,
                                           functionCall: @escaping (SubParser<ExprSyntax, Stage.Parsed.Path>) -> SubParser<FunctionCallExprSyntax, Stage.Parsed.Path>) -> SubParser<ExprSyntax, Stage.Parsed.Path> {
        
        return .expressionWithParent(memberAccess: memberAccess, functionCall: functionCall)
    }
    
    fileprivate static func argumentExpression(memberAccess: @escaping () -> SubParser<MemberAccessExprSyntax, Argument>,
                                               functionCall: @escaping () -> SubParser<FunctionCallExprSyntax, Argument>) -> SubParser<ExprSyntax, Argument> {
        
        return .expression(memberAccess: memberAccess, functionCall: functionCall)
    }
    
    fileprivate static func queryArgumentExpression(memberAccess: @escaping () -> SubParser<MemberAccessExprSyntax, Argument.QueryArgument>,
                                                    functionCall: @escaping () -> SubParser<FunctionCallExprSyntax, Argument.QueryArgument>) -> SubParser<ExprSyntax, Argument.QueryArgument> {
        // Add default
        return .expression(memberAccess: memberAccess, functionCall: functionCall)
    }
    
}
