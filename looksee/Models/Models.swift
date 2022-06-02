//
//  Models.swift
//  looksee
//
//  Created by Robert Malko on 11/17/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import UIKit
import Foundation

struct Tool: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    var value: Double
    let min: Double
    let max: Double
    var selected: Bool = false
}

struct FilterPack: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    let price: String
    let instagram: String
    let filters: [PhotoFilter]
    let collections: [UUID] = []
    let categories: [UUID] = []
    let new: Bool = false
    let featured: Bool = false
    let live: Bool = true
    var selected: Bool = false
}

struct PhotoFilter: Identifiable {
    let id = UUID()
    let photo: String
    let name: String
    let curveFile: String? //
}

struct PackData: Identifiable {
    let id = UUID()
    let name: String
    var packs: [FilterPack]
}

struct CurveFilter: Identifiable {
    let id = UUID()
    let saturation: Double
    let brightness: Double
    let sharpen: Double
    let level: Level?
    let vignette: Vignette?
}

struct Level: Identifiable {
    let id = UUID()
    let redMin: Double
    let gamma: Double
    let max: Double
    let minOut: Double
    let maxOut: Double
}

struct Vignette: Identifiable {
    let id = UUID()
    let start: Double
    let end: Double
}

var ToolsData: [Tool] = [
    Tool(name: "Brightness", image: "tools-brightness", value: 0.0, min: -0.3, max: 0.3, selected: true),
    Tool(name: "Contrast", image: "tools-contrast", value: 1.0, min: 0.7, max: 2.0, selected: false),
    Tool(name: "Saturation", image: "tools-saturation", value: 1.0, min: 0.0, max: 1.5, selected: false),
    Tool(name: "Sharpen", image: "tools-sharpen", value: 0.0, min: -0.5, max: 1.5, selected: false),
//    Tool(name: "Tempature", image: "tools-tempature", value: 0.0, min: 10.0, max: 10.0, selected: false),
//    Tool(name: "Tint", image: "tools-tint", value: 0.0, min: 10.0, max: 10.0, selected: false),
//    Tool(name: "Vignette", image: "tools-vignette", value: 0.0, min: 0.0, max: 1.0, selected: false),
    Tool(name: "Shadows", image: "tools-shadows", value: 0.0, min: 0.0, max: 0.5, selected: false),
    Tool(name: "Highlights", image: "tools-highlights", value: 1.0, min: 0.0, max: 1.0, selected: false)
]

struct FileImage: Identifiable {
    let id = UUID()
    let file: String
    let image: UIImage
}

var PurchasedPacks: [PackData] {
    get {
        var ppacks:[PackData] = [PackData(name: "Purchased", packs: [])]
        if let packs = UserDefaults.standard.object(forKey: "PurchasedPacks") as? [String] {
            for pack in packs {
                ppacks[0].packs = ppacks[0].packs + FeaturedPacks[0].packs.filter({ $0.name == pack })
                ppacks[0].packs = ppacks[0].packs + NaturePacks[0].packs.filter({ $0.name == pack })
                ppacks[0].packs = ppacks[0].packs + FashionPacks[0].packs.filter({ $0.name == pack })
                ppacks[0].packs = ppacks[0].packs + UrbanPacks[0].packs.filter({ $0.name == pack })
                ppacks[0].packs = ppacks[0].packs + ModelPacks[0].packs.filter({ $0.name == pack })
                ppacks[0].packs = ppacks[0].packs + LifestylePacks[0].packs.filter({ $0.name == pack })
            }
        }
        return ppacks
    }
    set {
        if !newValue.isEmpty {
            var ppacks:[String] = []
            if let packs = UserDefaults.standard.object(forKey: "PurchasedPacks") as? [String] {
                ppacks = packs
            }
            ppacks.append(newValue.last!.packs[0].name)
            UserDefaults.standard.set(ppacks, forKey: "PurchasedPacks")
        }
    }
}

//var PurchasedPacks: [PackData] = [
//    PackData(name: "Purchased", packs: [
//       mattCrump, samAlive, neaveBozorgi, bryanaHolly, tonyDetroit
//    ])
//]


let FeaturedPacks: [PackData] = [
    PackData(name: "Featured", packs: [
        hannesBecker
    ])
]

let NaturePacks: [PackData] = [
    PackData(name: "Nature Packs", packs: [
        simoneBrahmante, jenahYamamoto, chrisBurkard, timLandis, eelcoRoos, benSchuyler, craigHowes, scottBakken, samAlive, pauloDelvalle, oliverVegas, dylanFurst, finnBeales, danRubin, christofferCollin
    ])
]

let FashionPacks: [PackData] = [
    PackData(name: "Fashion Packs", packs: [
        sheaMarie, neaveBozorgi, courtneyTrop, samanthaWennerstrom, garethPon
    ])
]


let FashionPacksRowOne: [PackData] = [
    PackData(name: "Fashion Packs", packs: [
        sheaMarie, neaveBozorgi
    ])
]

let FashionPacksRowTwo: [PackData] = [
    PackData(name: "Fashion Packs", packs: [
        courtneyTrop, samanthaWennerstrom
    ])
]

let FashionPacksRowThree: [PackData] = [
    PackData(name: "Fashion Packs", packs: [
        garethPon
    ])
]

let UrbanPacks: [PackData] = [
    PackData(name: "Urban Packs", packs: [
        thirteenWitness, potatounit, jasonPeterson, tonyDetroit, ryanParrilla, kyleKuiper, joshAlvarez, insighting, humzaDeas, hiroakiFukuda, coleYounger, brianAlcazar
    ])
]

let ModelPacks: [PackData] = [
    PackData(name: "Model Packs", packs: [
        karrueche, bryanaHolly, donBenjamin
    ])
]

let LifestylePacks: [PackData] = [
    PackData(name: "Lifestyle Packs", packs: [
        bethanyMarie, mattCrump, jeremyVeach, robertJahns, jelitoDeLeon, ericCoal
    ])
]

/// filterPacks: Please keep alphabetized

fileprivate let benSchuyler = FilterPack(
    name: "Ben Schuyler", avatar: "BenSchuyler", price: "$0.99", instagram: "benschuyler",
    filters: makeFilters(
        photoPrefix: "BenSchuyler",
        name1: "ben01", name2: "ben02", name3: "ben03"
    )
)
fileprivate let bethanyMarie = FilterPack(
    name: "Bethany Marie", avatar: "BethanyMarie", price: "$0.99", instagram: "bethanymarieco",
    filters: makeFilters(
        photoPrefix: "BethanyMarie",
        name1: "BM1", name2: "BM2", name3: "BM3"
    )
)
fileprivate let brianAlcazar = FilterPack(
    name: "1st Instinct", avatar: "BrianAlcazar", price: "$0.99", instagram: "1st",
    filters: makeFilters(
        photoPrefix: "BrianAlcazar",
        name1: "Color Blind", name2: "Daily Grind", name3: "Nocturnal"
    )
)
fileprivate let bryanaHolly = FilterPack(
    name: "Bryana Holly", avatar: "BryanaHolly", price: "$0.99", instagram: "bryanaholly",
    filters: makeFilters(
        photoPrefix: "BryanaHolly",
        name1: "Waves", name2: "Inspire", name3: "Freebird"
    )
)
fileprivate let chrisBurkard = FilterPack(
    name: "Chris Burkard", avatar: "ChrisBurkard", price: "$0.99", instagram: "chrisburkard",
    filters: makeFilters(
        photoPrefix: "ChrisBurkard",
        name1: "Lofoten", name2: "Hofn", name3: "Spirit Island"
    )
)
fileprivate let christofferCollin = FilterPack(
    name: "Christoffer Collin", avatar: "ChristofferCollin", price: "$0.99", instagram: "wisslaren",
    filters: makeFilters(
        photoPrefix: "ChristofferCollin",
        name1: "CC1", name2: "CC2", name3: "CC3"
    )
)
fileprivate let coleYounger = FilterPack(
    name: "Cole Younger", avatar: "ColeYounger", price: "$0.99", instagram: "cole_younger_",
    filters: makeFilters(
        photoPrefix: "ColeYounger",
        name1: "Temper", name2: "Observe", name3: "Oz"
    )
)
fileprivate let courtneyTrop = FilterPack(
    name: "Courtney Trop", avatar: "CourtneyTrop", price: "$0.99", instagram: "alwaysjudging",
    filters: makeFilters(
        photoPrefix: "CourtneyTrop",
        name1: "Mute", name2: "Soft Mute", name3: "Emerald Mute"
    )
)
fileprivate let craigHowes = FilterPack(
    name: "Craig Howes", avatar: "CraigHowes", price: "$0.99", instagram: "craighowes",
    filters: makeFilters(
        photoPrefix: "CraigHowes",
        name1: "Howes Mono", name2: "Howes Tones", name3: "Howes Gold"
    )
)
fileprivate let danRubin = FilterPack(
    name: "Dan Rubin", avatar: "DanRubin", price: "$0.99", instagram: "danrubin",
    filters: makeFilters(
        photoPrefix: "DanRubin",
        name1: "DR1", name2: "DR2", name3: "DR3"
    )
)
fileprivate let donBenjamin = FilterPack(
    name: "Don Benjamin", avatar: "DonBenjamin", price: "$0.99", instagram: "donbenjamin",
    filters: makeFilters(
        photoPrefix: "DonBenjamin",
        name1: "Game Face", name2: "Legs", name3: "Workin"
    )
)
fileprivate let dylanFurst = FilterPack(
    name: "Dylan Furst", avatar: "DylanFurst", price: "$0.99", instagram: "fursty",
    filters: makeFilters(
        photoPrefix: "DylanFurst",
        name1: "Cold Hike", name2: "Deadwood", name3: "Kodak Summer"
    )
)
fileprivate let eelcoRoos = FilterPack(
    name: "Eelco Roos", avatar: "EelcoRoos", price: "$0.99", instagram: "croyable",
    filters: makeFilters(
        photoPrefix: "EelcoRoos",
        name1: "ER1", name2: "ER2", name3: "ER3"
    )
)
fileprivate let ericCoal = FilterPack(
    name: "Eric Coal", avatar: "EricCoal", price: "$0.99", instagram: "littlecoal",
    filters: makeFilters(
        photoPrefix: "EricCoal",
        name1: "Forgiven", name2: "Grace", name3: "Hope"
    )
)
fileprivate let fedjaSalihbasic = FilterPack(
    name: "Fedja Salihbasic", avatar: "FedjaSalihbasic", price: "$0.99", instagram: "",
    filters: makeFilters(
        photoPrefix: "FedjaSalihbasic",
        name1: "", name2: "", name3: ""
    )
)
fileprivate let finnBeales = FilterPack(
    name: "Finn Beales", avatar: "FinnBeales", price: "$0.99", instagram: "finn",
    filters: makeFilters(
        photoPrefix: "FinnBeales",
        name1: "Hofn", name2: "Hogwarts", name3: "Moor"
    )
)
fileprivate let garethPon = FilterPack(
    name: "Gareth Pon", avatar: "GarethPon", price: "$0.99", instagram: "garethpon",
    filters: makeFilters(
        photoPrefix: "GarethPon",
        name1: "Bleu", name2: "Grix", name3: "Vert"
    )
)
fileprivate let hannesBecker = FilterPack(
    name: "Hannes Becker", avatar: "HannesBecker", price: "$0.99", instagram: "hannes_becker",
    filters: makeFilters(
        photoPrefix: "HannesBecker",
        name1: "HB1", name2: "HB2", name3: "HB3"
    )
)
fileprivate let hiroakiFukuda = FilterPack(
    name: "Hiroaki Fukuda", avatar: "HiroakiFukuda", price: "$0.99", instagram: "hirozzzz",
    filters: makeFilters(
        photoPrefix: "HiroakiFukuda",
        name1: "HZ1", name2: "HZ2", name3: "HZ3"
    )
)
fileprivate let humzaDeas = FilterPack(
    name: "Humza Deas", avatar: "HumzaDeas", price: "$0.99", instagram: "humzadeas",
    filters: makeFilters(
        photoPrefix: "HumzaDeas",
        name1: "Temper", name2: "Observe", name3: "Oz"
    )
)
fileprivate let insighting = FilterPack(
    name: "Insighting", avatar: "Insighting", price: "$0.99", instagram: "insighting",
    filters: makeFilters(
        photoPrefix: "Insighting",
        name1: "Meticulous", name2: "Dynamic", name3: "Obsidian"
    )
)
fileprivate let jasonPeterson = FilterPack(
    name: "Jason Peterson", avatar: "JasonPeterson", price: "$0.99", instagram: "jasonpeterson",
    filters: makeFilters(
        photoPrefix: "JasonPeterson",
        name1: "Dark", name2: "Darker", name3: "Darkness"
    )
)
fileprivate let jelitoDeLeon = FilterPack(
    name: "Jelito De Leon", avatar: "JelitoDeLeon", price: "$0.99", instagram: "jelitodeleon",
    filters: makeFilters(
        photoPrefix: "JelitoDeLeon",
        name1: "JDL1", name2: "JDL2", name3: "JDL3"
    )
)
fileprivate let jenahYamamoto = FilterPack(
    name: "Jenah Yamamoto", avatar: "JenahYamamoto", price: "$0.99", instagram: "gypsyone",
    filters: makeFilters(
        photoPrefix: "JenahYamamoto",
        name1: "Scenic Route", name2: "El Classic", name3: "Retro Ruv"
    )
)
fileprivate let jeremyVeach = FilterPack(
    name: "Jeremy Veach", avatar: "JeremyVeach", price: "$0.99", instagram: "jeremyveachh",
    filters: makeFilters(
        photoPrefix: "JeremyVeach",
        name1: "thenorm1", name2: "thenorm2", name3: "thenorm3"
    )
)
fileprivate let joshAlvarez = FilterPack(
    name: "J.A.M", avatar: "JoshAlvarez", price: "$0.99", instagram: "imthejam",
    filters: makeFilters(
        photoPrefix: "JoshAlvarez",
        name1: "Empire JAM", name2: "Blueberry JAM", name3: "Forest JAM"
    )
)
fileprivate let judsonMorgan = FilterPack(
    name: "Judson Morgan", avatar: "JudsonMorgan", price: "$0.99", instagram: "",
    filters: makeFilters(
        photoPrefix: "JudsonMorgan",
        name1: "", name2: "", name3: ""
    )
)
fileprivate let kaelRebick = FilterPack(
    name: "Kael Rebick", avatar: "KaelRebick", price: "$0.99", instagram: "",
    filters: makeFilters(
        photoPrefix: "KaelRebick",
        name1: "", name2: "", name3: ""
    )
)
fileprivate let karrueche = FilterPack(
    name: "Karrueche", avatar: "Karrueche", price: "$0.99", instagram: "karrueche",
    filters: makeFilters(
        photoPrefix: "Karrueche",
        name1: "Stay Gold", name2: "Shoe Selfie", name3: "Nom nom"
    )
)
fileprivate let kyleKuiper = FilterPack(
    name: "Kyle Kuiper", avatar: "KyleKuiper", price: "$0.99", instagram: "kdkuiper",
    filters: makeFilters(
        photoPrefix: "KyleKuiper",
        name1: "Lone Survivor", name2: "Outlaw", name3: "Stealth"
    )
)
fileprivate let mattCrump = FilterPack(
    name: "Matt Crump", avatar: "MattCrump", price: "$0.99", instagram: "mattcrump",
    filters: makeFilters(
        photoPrefix: "MattCrump",
        name1: "Jawbreaker", name2: "Gummi", name3: "Taffy"
    )
)
fileprivate let neaveBozorgi = FilterPack(
    name: "Neave Bozorgi", avatar: "NeaveBozorgi", price: "$0.99", instagram: "neavebozorgi",
    filters: makeFilters(
        photoPrefix: "NeaveBozorgi",
        name1: "NB1", name2: "NB2", name3: "NB3"
    )
)
fileprivate let oliverVegas = FilterPack(
    name: "Oliver Vegas", avatar: "OliverVegas", price: "$0.99", instagram: "ovunno",
    filters: makeFilters(
        photoPrefix: "OliverVegas",
        name1: "OV1", name2: "OV2", name3: "OV3"
    )
)
fileprivate let pauloDelvalle = FilterPack(
    name: "Paulo Delvalle", avatar: "PauloDelvalle", price: "$0.99", instagram: "paulodsamaelvalle",
    filters: makeFilters(
        photoPrefix: "PauloDelvalle",
        name1: "Blue Turquoise", name2: "Golden Hour", name3: "Whiteness"
    )
)
fileprivate let potatounit = FilterPack(
    name: "Potatounit", avatar: "Potatounit", price: "$0.99", instagram: "potatounit",
    filters: makeFilters(
        photoPrefix: "Potatounit",
        name1: "Cozy", name2: "Haze", name3: "Odyssey"
    )
)
fileprivate let robertJahns = FilterPack(
    name: "Robert Jahns", avatar: "RobertJahns", price: "$0.99", instagram: "nois7",
    filters: makeFilters(
        photoPrefix: "RobertJahns",
        name1: "Colorful Nigth", name2: "Summer of Joy", name3: "Cold Winter"
    )
)
fileprivate let ryanParrilla = FilterPack(
    name: "Ryan Parrilla", avatar: "RyanParrilla", price: "$0.99", instagram: "ryanparrilla",
    filters: makeFilters(
        photoPrefix: "RyanParrilla",
        name1: "Glaze", name2: "Elevation", name3: "Time"
    )
)
fileprivate let samAlive = FilterPack(
    name: "SamAlive", avatar: "SamAlive", price: "$0.99", instagram: "samealive",
    filters: makeFilters(
        photoPrefix: "SamAlive",
        name1: "alive1", name2: "alive2", name3: "alive3"
    )
)
fileprivate let samanthaWennerstrom = FilterPack(
    name: "Could I Have That", avatar: "SamanthaWennerstrom", price: "$0.99", instagram: "couldihavethat",
    filters: makeFilters(
        photoPrefix: "SamanthaWennerstrom",
        name1: "SW1", name2: "SW2", name3: "SW3"
    )
)
fileprivate let scottBakken = FilterPack(
    name: "Scott Bakken", avatar: "ScottBakken", price: "$0.99", instagram: "scottbakken",
    filters: makeFilters(
        photoPrefix: "ScottBakken",
        name1: "SCB1", name2: "SCB2", name3: "SCB3"
    )
)
fileprivate let sheaMarie = FilterPack(
    name: "Peace Love Shea", avatar: "SheaMarie", price: "$0.99", instagram: "sheamarie",
    filters: makeFilters(
        photoPrefix: "SheaMarie",
        name1: "California Summer", name2: "Perfect Selfie", name3: "Old Hollywood"
    )
)
fileprivate let simoneBrahmante = FilterPack(
    name: "Simone Brahmante", avatar: "SimoneBrahmante", price: "$0.99", instagram: "brahmino",
    filters: makeFilters(
        photoPrefix: "SimoneBrahmante",
        name1: "SB1", name2: "SB2", name3: "SB3"
    )
)
fileprivate let thirteenWitness = FilterPack(
    name: "13th Witness", avatar: "ThirteenWitness", price: "$0.99", instagram: "13thwitness",
    filters: makeFilters(
        photoPrefix: "ThirteenWitness",
        name1: "XIII1", name2: "XIII2", name3: "XIII3"
    )
)
fileprivate let timLandis = FilterPack(
    name: "Tim Landis", avatar: "TimLandis", price: "$0.99", instagram: "curious2119",
    filters: makeFilters(
        photoPrefix: "TimLandis",
        name1: "cur01", name2: "cur02", name3: "cur03"
    )
)
fileprivate let tonyDetroit = FilterPack(
    name: "Tony Detroit", avatar: "TonyDetroit", price: "$0.99", instagram: "tonydetroit",
    filters: makeFilters(
        photoPrefix: "TonyDetroit",
        name1: "157 Conspiracy", name2: "33rd Degree", name3: "Abandonment"
    )
)

fileprivate func makeFilters(
    photoPrefix: String, name1: String, name2: String, name3: String
) -> [PhotoFilter] {
    return [
        PhotoFilter(photo: "\(photoPrefix)-1", name: name1, curveFile: "\(photoPrefix)-c1"),
        PhotoFilter(photo: "\(photoPrefix)-2", name: name2, curveFile: "\(photoPrefix)-c2"),
        PhotoFilter(photo: "\(photoPrefix)-3", name: name3, curveFile: "\(photoPrefix)-c3")
    ]
}

let purchaseFilter: [String: SubscriptionPack] = [
    "Ben Schuyler": .BS,
    "Bethany Marie": .BM,
    "1st Instinct": .ST,
    "Bryana Holly": .BH,
    "Chris Burkard": .CB,
    "Christoffer Collin": .CC,
    "Cole Younger": .CY,
    "Courtney Trop": .CT,
    "Craig Howes": .CH,
    "Dan Rubin": .DR,
    "Don Benjamin": .DB,
    "Dylan Furst": .DF,
    "Eelco Roos": .ER,
    "Eric Coal": .EC,
    "Fedja Salihbasic": .FS,
    "Finn Beales": .FB,
    "Gareth Pon": .GP,
    "Hannes Becker": .HB,
    "Hiroaki Fukuda": .HF,
    "Humza Deas": .HD,
    "Insighting": .IN,
    "Jason Peterson": .JP,
    "Jelito De Leon": .JDL,
    "Jenah Yamamoto": .JY,
    "Jeremy Veach": .JV,
    "J.A.M": .JAM,
    "Judson Morgan": .JM,
    "Kael Rebick": .KR,
    "Karrueche": .KA,
    "Kyle Kuiper": .KK,
    "Matt Crump": .MC,
    "Neave Bozorgi": .NB,
    "Oliver Vegas": .OV,
    "Paulo Delvalle": .PD,
    "Potatounit": .PU,
    "Robert Jahns": .RJ,
    "Ryan Parrilla": .RP,
    "SamAlive": .SA,
    "Could I Have That": .CI,
    "Scott Bakken": .SBN,
    "Peace Love Shea": .SM,
    "Simone Brahmante": .SB,
    "13th Witness": .TH,
    "Tim Landis": .TL,
    "Tony Detroit": .TD,
]


let CurveFilters = [
    "BenSchuyler-c1": BenSchuylerC1,
    "BenSchuyler-c2": BenSchuylerC2,
    "BenSchuyler-c3": BenSchuylerC3,
    
    "BethanyMarie-c1": BethanyMarieC1,
    "BethanyMarie-c2": BethanyMarieC2,
    "BethanyMarie-c3": BethanyMarieC3,
    
    "BrianAlcazar-c1": BrianAlcazarC1,
    "BrianAlcazar-c2": BrianAlcazarC2,
    "BrianAlcazar-c3": BrianAlcazarC3,
    
    "BryanaHolly-c1": BryanaHollyC1,
    "BryanaHolly-c2": BryanaHollyC2,
    "BryanaHolly-c3": BryanaHollyC3,
    
    "ChrisBurkard-c1": ChrisBurkardC1,
    "ChrisBurkard-c2": ChrisBurkardC2,
    "ChrisBurkard-c3": ChrisBurkardC3,
    
    "ChristofferCollin-c1": ChristofferCollinC1,
    "ChristofferCollin-c2": ChristofferCollinC2,
    "ChristofferCollin-c3": ChristofferCollinC3,
    
    "ColeYounger-c1": ColeYoungerC1,
    "ColeYounger-c2": ColeYoungerC2,
    "ColeYounger-c3": ColeYoungerC3,
    
    "CourtneyTrop-c1": CourtneyTropC1,
    "CourtneyTrop-c2": CourtneyTropC2,
    "CourtneyTrop-c3": CourtneyTropC3,
    
    "CraigHowes-c1": CraigHowesC1,
    "CraigHowes-c2": CraigHowesC2,
    "CraigHowes-c3": CraigHowesC3,
    
    "DanRubin-c1": DanRubinC1,
    "DanRubin-c2": DanRubinC2,
    "DanRubin-c3": DanRubinC3,
    
    "DonBenjamin-c1": DonBenjaminC1,
    "DonBenjamin-c2": DonBenjaminC2,
    "DonBenjamin-c3": DonBenjaminC3,
    
    "DylanFurst-c1": DylanFurstC1,
    "DylanFurst-c2": DylanFurstC2,
    "DylanFurst-c3": DylanFurstC3,
    
    "EelcoRoos-c1": EelcoRoosC1,
    "EelcoRoos-c2": EelcoRoosC2,
    "EelcoRoos-c3": EelcoRoosC3,
    
    "EricCoal-c1": EricCoalC1,
    "EricCoal-c2": EricCoalC2,
    "EricCoal-c3": EricCoalC3,
    
    "FedjaSalihbasic-c1": FedjaSalihbasicC1,
    "FedjaSalihbasic-c2": FedjaSalihbasicC2,
    "FedjaSalihbasic-c3": FedjaSalihbasicC3,
    
    "FinnBeales-c1": FinnBealesC1,
    "FinnBeales-c2": FinnBealesC2,
    "FinnBeales-c3": FinnBealesC3,
    
    "GarethPon-c1": GarethPonC1,
    "GarethPon-c2": GarethPonC2,
    "GarethPon-c3": GarethPonC3,
    
    "HannesBecker-c1": HannesBeckerC1,
    "HannesBecker-c2": HannesBeckerC2,
    "HannesBecker-c3": HannesBeckerC3,
    
    "HiroakiFukuda-c1": HiroakiFukudaC1,
    "HiroakiFukuda-c2": HiroakiFukudaC2,
    "HiroakiFukuda-c3": HiroakiFukudaC3,
    
    "HumzaDeas-c1": HumzaDeasC1,
    "HumzaDeas-c2": HumzaDeasC2,
    "HumzaDeas-c3": HumzaDeasC3,
    
    "Insighting-c1": InsightingC1,
    "Insighting-c2": InsightingC2,
    "Insighting-c3": InsightingC3,
    
    "JasonPeterson-c1": JasonPetersonC1,
    "JasonPeterson-c2": JasonPetersonC2,
    "JasonPeterson-c3": JasonPetersonC3,
    
    "JelitoDeLeon-c1": JelitoDeLeonC1,
    "JelitoDeLeon-c2": JelitoDeLeonC2,
    "JelitoDeLeon-c3": JelitoDeLeonC3,
    
    "JenahYamamoto-c1": JenahYamamotoC1,
    "JenahYamamoto-c2": JenahYamamotoC2,
    "JenahYamamoto-c3": JenahYamamotoC3,
    
    "JeremyVeach-c1": JeremyVeachC1,
    "JeremyVeach-c2": JeremyVeachC2,
    "JeremyVeach-c3": JeremyVeachC3,
    
    "JoshAlvarez-c1": JoshAlvarezC1,
    "JoshAlvarez-c2": JoshAlvarezC2,
    "JoshAlvarez-c3": JoshAlvarezC3,
    
    "JudsonMorgan-c1": JudsonMorganC1,
    "JudsonMorgan-c2": JudsonMorganC2,
    "JudsonMorgan-c3": JudsonMorganC3,
    
    "KaelRebick-c1": KaelRebickC1,
    "KaelRebick-c2": KaelRebickC2,
    "KaelRebick-c3": KaelRebickC3,
    
    "Karrueche-c1": KarruecheC1,
    "Karrueche-c2": KarruecheC2,
    "Karrueche-c3": KarruecheC3,
    
    "KyleKuiper-c1": KyleKuiperC1,
    "KyleKuiper-c2": KyleKuiperC2,
    "KyleKuiper-c3": KyleKuiperC3,
    
    "MattCrump-c1": MattCrumpC1,
    "MattCrump-c2": MattCrumpC2,
    "MattCrump-c3": MattCrumpC3,
    
    "NeaveBozorgi-c1": NeaveBozorgiC1,
    "NeaveBozorgi-c2": NeaveBozorgiC2,
    "NeaveBozorgi-c3": NeaveBozorgiC3,
    
    "OliverVegas-c1": OliverVegasC1,
    "OliverVegas-c2": OliverVegasC2,
    "OliverVegas-c3": OliverVegasC3,
    
    "PauloDelvalle-c1": PauloDelvalleC1,
    "PauloDelvalle-c2": PauloDelvalleC2,
    "PauloDelvalle-c3": PauloDelvalleC3,
    
    "Potatounit-c1": PotatounitC1,
    "Potatounit-c2": PotatounitC2,
    "Potatounit-c3": PotatounitC3,
    
    "RobertJahns-c1": RobertJahnsC1,
    "RobertJahns-c2": RobertJahnsC2,
    "RobertJahns-c3": RobertJahnsC3,
    
    "RyanParrilla-c1": RyanParrillaC1,
    "RyanParrilla-c2": RyanParrillaC2,
    "RyanParrilla-c3": RyanParrillaC3,
    
    "SamAlive-c1": SamAliveC1,
    "SamAlive-c2": SamAliveC2,
    "SamAlive-c3": SamAliveC3,
    
    "SamanthaWennerstrom-c1": SamanthaWennerstromC1,
    "SamanthaWennerstrom-c2": SamanthaWennerstromC2,
    "SamanthaWennerstrom-c3": SamanthaWennerstromC3,
    
    "ScottBakken-c1": ScottBakkenC1,
    "ScottBakken-c2": ScottBakkenC2,
    "ScottBakken-c3": ScottBakkenC3,
    
    "SheaMarie-c1": SheaMarieC1,
    "SheaMarie-c2": SheaMarieC2,
    "SheaMarie-c3": SheaMarieC3,
    
    "SimoneBrahmante-c1": SimoneBrahmanteC1,
    "SimoneBrahmante-c2": SimoneBrahmanteC2,
    "SimoneBrahmante-c3": SimoneBrahmanteC3,
    
    "ThirteenWitness-c1": ThirteenWitnessC1,
    "ThirteenWitness-c2": ThirteenWitnessC2,
    "ThirteenWitness-c3": ThirteenWitnessC3,
    
    "TimLandis-c1": TimLandisC1,
    "TimLandis-c2": TimLandisC2,
    "TimLandis-c3": TimLandisC3,
    
    "TonyDetroit-c1": TonyDetroitC1,
    "TonyDetroit-c2": TonyDetroitC2,
    "TonyDetroit-c3": TonyDetroitC3
]

fileprivate let BenSchuylerC1 = CurveFilter(
    saturation: 0.85, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let BenSchuylerC2 = CurveFilter(
    saturation: 0.65, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let BenSchuylerC3 = CurveFilter(
    saturation: 0.75, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let BethanyMarieC1 = CurveFilter(
    saturation: 0.84, brightness: -0.05, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let BethanyMarieC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let BethanyMarieC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)

fileprivate let BrianAlcazarC1 = CurveFilter(
    saturation: 0.001, brightness: 0.0, sharpen: 0.5, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)
fileprivate let BrianAlcazarC2 = CurveFilter(
    saturation: 1.13, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let BrianAlcazarC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let BryanaHollyC1 = CurveFilter(
    saturation: 1.2, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let BryanaHollyC2 = CurveFilter(
    saturation: 0.85, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let BryanaHollyC3 = CurveFilter(
    saturation: 0.9, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let ChrisBurkardC1 = CurveFilter(
    saturation: 1.31, brightness: 0.05, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let ChrisBurkardC2 = CurveFilter(
    saturation: 1.25, brightness: 0.075, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let ChrisBurkardC3 = CurveFilter(
    saturation: 1.15, brightness: 0.05, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let ChristofferCollinC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let ChristofferCollinC2 = CurveFilter(
    saturation: 1.12, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let ChristofferCollinC3 = CurveFilter(
    saturation: 1.15, brightness: 0.5, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let ColeYoungerC1 = CurveFilter(
    saturation: 0.91, brightness: -0.025, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let ColeYoungerC2 = CurveFilter(
    saturation: 0.0, brightness: 0.5, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)
fileprivate let ColeYoungerC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let CourtneyTropC1 = CurveFilter(
    saturation: 0.73, brightness: -0.175, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let CourtneyTropC2 = CurveFilter(
    saturation: 0.75, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let CourtneyTropC3 = CurveFilter(
    saturation: 0.59, brightness: 0.5, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let CraigHowesC1 = CurveFilter(
    saturation: 0.001, brightness: 0.0, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)
fileprivate let CraigHowesC2 = CurveFilter(
    saturation: 1.2, brightness: 0.05, sharpen: 0.35, level: nil,
    vignette: Vignette(start: 0.5, end: 1.0)
)
fileprivate let CraigHowesC3 = CurveFilter(
    saturation: 1.0, brightness: 0.1, sharpen: 0.35, level: nil, vignette: nil
)

fileprivate let DanRubinC1 = CurveFilter(
    saturation: 0.65, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let DanRubinC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let DanRubinC3 = CurveFilter(
    saturation: 0.75, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let DonBenjaminC1 = CurveFilter(
    saturation: 0.7, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let DonBenjaminC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let DonBenjaminC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let DylanFurstC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let DylanFurstC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let DylanFurstC3 = CurveFilter(
    saturation: 0.63, brightness: -0.05, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let EelcoRoosC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.35, level: nil, vignette: nil
)
fileprivate let EelcoRoosC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.35, level: nil, vignette: nil
)
fileprivate let EelcoRoosC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let EricCoalC1 = CurveFilter(
    saturation: 0.55, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let EricCoalC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let EricCoalC3 = CurveFilter(
    saturation: 1.45, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let FedjaSalihbasicC1 = CurveFilter(
    saturation: 1.17, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let FedjaSalihbasicC2 = CurveFilter(
    saturation: 0.73, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let FedjaSalihbasicC3 = CurveFilter(
    saturation: 0.08, brightness: 0.02, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let FinnBealesC1 = CurveFilter(
    saturation: 0.33, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let FinnBealesC2 = CurveFilter(
    saturation: 0.66, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let FinnBealesC3 = CurveFilter(
    saturation: 0.55, brightness: 0.02, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let GarethPonC1 = CurveFilter(
    saturation: 1.0, brightness: 0.03, sharpen: 0.4, level: nil,
    vignette: Vignette(start: 0.6, end: 1.0)
)
fileprivate let GarethPonC2 = CurveFilter(
    saturation: 0.66, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let GarethPonC3 = CurveFilter(
    saturation: 0.91, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let HannesBeckerC1 = CurveFilter(
    saturation: 0.73, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let HannesBeckerC2 = CurveFilter(
    saturation: 0.43, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let HannesBeckerC3 = CurveFilter(
    saturation: 1.18, brightness: 0.02, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let HiroakiFukudaC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let HiroakiFukudaC2 = CurveFilter(
    saturation: 0.92, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let HiroakiFukudaC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let HumzaDeasC1 = CurveFilter(
    saturation: 1.98, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let HumzaDeasC2 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let HumzaDeasC3 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.6, level: nil,
    vignette: Vignette(start: 0.35, end: 1.0)
)

fileprivate let InsightingC1 = CurveFilter(
    saturation: 0.5, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let InsightingC2 = CurveFilter(
    saturation: 1.29, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let InsightingC3 = CurveFilter(
    saturation: 0.01, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let JasonPetersonC1 = CurveFilter(
    saturation: 0.001, brightness: 0.0, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)
fileprivate let JasonPetersonC2 = CurveFilter(
    saturation: 0.001, brightness: 0.0, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)
fileprivate let JasonPetersonC3 = CurveFilter(
    saturation: 0.001, brightness: 0.4, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)

fileprivate let JelitoDeLeonC1 = CurveFilter(
    saturation: 1.1, brightness: -0.075, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let JelitoDeLeonC2 = CurveFilter(
    saturation: 0.55, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let JelitoDeLeonC3 = CurveFilter(
    saturation: 1.3, brightness: -0.05, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let JenahYamamotoC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let JenahYamamotoC2 = CurveFilter(
    saturation: 0.001, brightness: 0.0, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)
fileprivate let JenahYamamotoC3 = CurveFilter(
    saturation: 0.9, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let JeremyVeachC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let JeremyVeachC2 = CurveFilter(
    saturation: 1.3, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let JeremyVeachC3 = CurveFilter(
    saturation: 0.9, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let JoshAlvarezC1 = CurveFilter(
    saturation: 1.45, brightness: 0.3, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let JoshAlvarezC2 = CurveFilter(
    saturation: 1.27, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let JoshAlvarezC3 = CurveFilter(
    saturation: 1.08, brightness: 0.02, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let JudsonMorganC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let JudsonMorganC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let JudsonMorganC3 = CurveFilter(
    saturation: 0.5, brightness: 0.0, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)

fileprivate let KaelRebickC1 = CurveFilter(
    saturation: 0.7, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let KaelRebickC2 = CurveFilter(
    saturation: 1.15, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let KaelRebickC3 = CurveFilter(
    saturation: 1.35, brightness: 0.02, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let KarruecheC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let KarruecheC2 = CurveFilter(
    saturation: 0.8, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let KarruecheC3 = CurveFilter(
    saturation: 0.9, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let KyleKuiperC1 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let KyleKuiperC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let KyleKuiperC3 = CurveFilter(
    saturation: 1.10, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let MattCrumpC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let MattCrumpC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let MattCrumpC3 = CurveFilter(
    saturation: 1.0, brightness: 0.05, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let NeaveBozorgiC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let NeaveBozorgiC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let NeaveBozorgiC3 = CurveFilter(
    saturation: 0.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let OliverVegasC1 = CurveFilter(
    saturation: 0.76, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)
fileprivate let OliverVegasC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let OliverVegasC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let PauloDelvalleC1 = CurveFilter(
    saturation: 1.17, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let PauloDelvalleC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let PauloDelvalleC3 = CurveFilter(
    saturation: 0.8, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let PotatounitC1 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let PotatounitC2 = CurveFilter(
    saturation: 0.01, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)
fileprivate let PotatounitC3 = CurveFilter(
    saturation: 0.91, brightness: 0.0, sharpen: 0.4, level: nil, vignette: nil
)

fileprivate let RobertJahnsC1 = CurveFilter(
    saturation: 1.2, brightness: 0.1, sharpen: 0.6, level: nil, vignette: nil
)
fileprivate let RobertJahnsC2 = CurveFilter(
    saturation: 1.3, brightness: 0.0, sharpen: 1.13, level: nil, vignette: nil
)
fileprivate let RobertJahnsC3 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.6, level: nil, vignette: nil
)

fileprivate let RyanParrillaC1 = CurveFilter(
    saturation: 1.98, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let RyanParrillaC2 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let RyanParrillaC3 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.6, level: nil,
    vignette: Vignette(start: 0.35, end: 1.0)
)

fileprivate let SamAliveC1 = CurveFilter(
    saturation: 0.9, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let SamAliveC2 = CurveFilter(
    saturation: 0.81, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)
fileprivate let SamAliveC3 = CurveFilter(
    saturation: 0.75, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)

fileprivate let SamanthaWennerstromC1 = CurveFilter(
    saturation: 0.73, brightness: -0.175, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let SamanthaWennerstromC2 = CurveFilter(
    saturation: 0.75, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let SamanthaWennerstromC3 = CurveFilter(
    saturation: 0.59, brightness: 0.05, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let ScottBakkenC1 = CurveFilter(
    saturation: 1.0, brightness: -0.05, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let ScottBakkenC2 = CurveFilter(
    saturation: 1.18, brightness: -0.05, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let ScottBakkenC3 = CurveFilter(
    saturation: 1.18, brightness: 0.0, sharpen: 0.55, level: nil, vignette: nil
)

fileprivate let SheaMarieC1 = CurveFilter(
    saturation: 1.14, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let SheaMarieC2 = CurveFilter(
    saturation: 0.95, brightness: -0.05, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let SheaMarieC3 = CurveFilter(
    saturation: 0.89, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)

fileprivate let SimoneBrahmanteC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.35, level: nil, vignette: nil
)
fileprivate let SimoneBrahmanteC2 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.35, level: nil, vignette: nil
)
fileprivate let SimoneBrahmanteC3 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.35, level: nil, vignette: nil
)

fileprivate let ThirteenWitnessC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let ThirteenWitnessC2 = CurveFilter(
    saturation: 0.85, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let ThirteenWitnessC3 = CurveFilter(
    saturation: 0.0, brightness: 0.0, sharpen: 0.45, level:
    Level(redMin: 0.4, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0),
    vignette: nil
)

fileprivate let TimLandisC1 = CurveFilter(
    saturation: 1.25, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let TimLandisC2 = CurveFilter(
    saturation: 1.2, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let TimLandisC3 = CurveFilter(
    saturation: 1.37, brightness: 0.0, sharpen: 0.5, level: nil, vignette: nil
)

fileprivate let TonyDetroitC1 = CurveFilter(
    saturation: 1.0, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let TonyDetroitC2 = CurveFilter(
    saturation: 0.66, brightness: 0.0, sharpen: 0.45, level: nil, vignette: nil
)
fileprivate let TonyDetroitC3 = CurveFilter(
    saturation: 0.55, brightness: 0.02, sharpen: 0.6, level: nil,
    vignette: Vignette(start: 0.35, end: 1.0)
)
