//
//  Inflector.swift
//  SwiftPatch
//
//  Created by draveness on 17/03/2017.
//  Copyright © 2017 draveness. All rights reserved.
//

// copied from https://github.com/draveness/RbSwift

import Foundation

private let inflector = Inflector()

extension String {

    var singular: String {
        return inflector.singularize(string: self)
    }

    var plural: String {
        return inflector.pluralize(string: self)
    }

}

struct InflectorRule {
    var rule: String
    var replacement: String
}

class Inflector {
    private var pluralRules: [InflectorRule] = []
    private var singularRules: [InflectorRule] = []
    private var words: Set<String> = Set<String>()

    init() {
        irregulars.forEach { (key, value) in
            self.addIrregularRule(singular: key, andPlural: value)
        }

        singularToPlural.reversed().forEach { (key, value) in
            self.addPluralRule(rule: key, forReplacement: value)
        }

        pluralToSingular.reversed().forEach { (key, value) in
            self.addSingularRule(rule: key, forReplacement: value)
        }

        unchangings.forEach { self.unchanging(word: $0) }
        uncountables.forEach { self.uncountableWord(word: $0) }
    }

    func pluralize(string: String) -> String {
        return apply(rules: pluralRules, forString: string)
    }

    func singularize(string: String) -> String {
        return apply(rules: singularRules, forString: string)
    }

    func addIrregularRule(singular: String, andPlural plural: String) {
        let singularRule: String = "\(plural)$"
        addSingularRule(rule: singularRule, forReplacement: singular)
        let pluralRule: String = "\(singular)$"
        addPluralRule(rule: pluralRule, forReplacement: plural)
    }

    func addSingularRule(rule: String, forReplacement replacement: String) {
        singularRules.append(InflectorRule(rule: rule, replacement: replacement))
    }

    func addPluralRule(rule: String, forReplacement replacement: String) {
        pluralRules.append(InflectorRule(rule: rule, replacement: replacement))
    }

    func uncountableWord(word: String) {
        words.insert(word)
    }

    func unchanging(word: String) {
        words.insert(word)
    }

    private func apply(rules: [InflectorRule], forString string: String) -> String {
        if words.contains(string) {
            return string
        } else {
            for rule in rules {
                let range = NSMakeRange(0, string.count)
                let regex: NSRegularExpression = try! NSRegularExpression(pattern: rule.rule, options: .caseInsensitive)
                if let _ = regex.firstMatch(in: string, options: [], range: range) {
                    return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: rule.replacement)
                }
            }
        }
        return string
    }
}

fileprivate let uncountables = ["access", "accommodation", "adulthood", "advertising", "advice", "aggression", "aid", "air", "alcohol", "anger", "applause", "arithmetic", "art", "assistance", "athletics", "attention", "bacon", "baggage", "ballet", "beauty", "beef", "beer", "biology", "botany", "bread", "butter", "carbon", "cash", "chaos", "cheese", "chess", "childhood", "clothing", "coal", "coffee", "commerce", "compassion", "comprehension", "content", "corruption", "cotton", "courage", "cream", "currency", "dancing", "danger", "data", "delight", "dignity", "dirt", "distribution", "dust", "economics", "education", "electricity", "employment", "engineering", "envy", "equipment", "ethics", "evidence", "evolution", "faith", "fame", "fish", "flour", "flu", "food", "freedom", "fuel", "fun", "furniture", "garbage", "garlic", "genetics", "gold", "golf", "gossip", "grammar", "gratitude", "grief", "ground", "guilt", "gymnastics", "hair", "happiness", "hardware", "harm", "hate", "hatred", "health", "heat", "height", "help", "homework", "honesty", "honey", "hospitality", "housework", "humour", "hunger", "hydrogen", "ice", "importance", "inflation", "information", "injustice", "innocence", "iron", "irony", "jealousy", "jeans", "jelly", "judo", "karate", "kindness", "knowledge", "labour", "lack", "laughter", "lava", "leather", "leisure", "lightning", "linguistics", "litter", "livestock", "logic", "loneliness", "luck", "luggage", "machinery", "magic", "management", "mankind", "marble", "mathematics", "mayonnaise", "measles", "meat", "methane", "milk", "money", "mud", "music", "nature", "news", "nitrogen", "nonsense", "nurture", "nutrition", "obedience", "obesity", "oil", "oxygen", "passion", "pasta", "patience", "permission", "physics", "poetry", "police", "pollution", "poverty", "power", "pronunciation", "psychology", "publicity", "quartz", "racism", "rain", "relaxation", "reliability", "research", "respect", "revenge", "rice", "rubbish", "rum", "salad", "satire", "seaside", "series", "shame", "sheep", "shopping", "silence", "sleep", "smoke", "smoking", "snow", "soap", "software", "soil", "sorrow", "soup", "species", "speed", "spelling", "steam", "stuff", "stupidity", "sunshine", "symmetry", "tennis", "thirst", "thunder", "toast", "tolerance", "toys", "traffic", "transporation", "travel", "trust", "understanding", "unemployment", "unity", "validity", "veal", "vengeance", "violence"]

fileprivate let singularToPlural = [
    "$": "s",
    "s$": "s",
    "^(ax|test)is$": "$1es",
    "(octop|vir)us$": "$1i",
    "(octop|vir)i$": "$1i",
    "(alias|status)$": "$1es",
    "(bu)s$": "$1ses",
    "(buffal|tomat)o$": "$1oes",
    "([ti])um$": "$1a",
    "([ti])a$": "$1a",
    "sis$": "ses",
    "(?:([^f])fe|([lr])f)$": "$1$2ves",
    "(hive)$": "$1s",
    "([^aeiouy]|qu)y$": "$1ies",
    "(x|ch|ss|sh)$": "$1es",
    "(matr|vert|ind)(?:ix|ex)$": "$1ices",
    "^(m|l)ouse$": "$1ice",
    "^(m|l)ice$": "$1ice",
    "^(ox)$": "$1en",
    "^(oxen)$": "$1",
    "(quiz)$": "$1zes"]

fileprivate let pluralToSingular = [
    "s$": "",
    "(ss)$": "$1",
    "(n)ews$": "$1ews",
    "([ti])a$": "$1um",
    "((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$": "$1sis",
    "(^analy)(sis|ses)$": "$1sis",
    "([^f])ves$": "$1fe",
    "(hive)s$": "$1",
    "(tive)s$": "$1",
    "([lr])ves$": "$1f",
    "([^aeiouy]|qu)ies$": "$1y",
    "(s)eries$": "$1eries",
    "(m)ovies$": "$1ovie",
    "(x|ch|ss|sh)es$": "$1",
    "^(m|l)ice$": "$1ouse",
    "(bus)(es)?$": "$1",
    "(o)es$": "$1",
    "(shoe)s$": "$1",
    "(cris|test)(is|es)$": "$1is",
    "^(a)x[ie]s$": "$1xis",
    "(octop|vir)(us|i)$": "$1us",
    "(alias|status)(es)?$": "$1",
    "^(ox)en": "$1",
    "(vert|ind)ices$": "$1ex",
    "(matr)ices$": "$1ix",
    "(quiz)zes$": "$1",
    "(database)s$": "$1"]

fileprivate let unchangings = [
    "sheep",
    "deer",
    "moose",
    "swine",
    "bison",
    "corps",
    "means",
    "series",
    "scissors",
    "species"]

fileprivate let irregulars = [
    "person": "people",
    "man": "men",
    "child": "children",
    "sex": "sexes",
    "move": "moves",
    "zombie": "zombies"]
