
import Foundation
import CoreLocation

enum SampleData {

    static let cities: [City] = [istanbul, doha, singapore, reykjavik]


    static let istanbul = City(
        name: "Istanbul",
        country: "Türkiye",
        airportCode: "IST",
        previewImageName: "https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=400",
        routes: [
            Route(
                title: "Old City Highlights",
                durationMinutes: 240,
                totalDistanceMeters: 3200,
                attractions: [
                    Attraction(
                        name: "Hagia Sophia",
                        coordinate: .init(latitude: 41.0086, longitude: 28.9802),
                        timeOnSiteMinutes: 45,
                        travelToNextMinutes: 8,
                        description: "A former cathedral and mosque, a masterpiece of Byzantine architecture."
                    ),
                    Attraction(
                        name: "Blue Mosque",
                        coordinate: .init(latitude: 41.0054, longitude: 28.9768),
                        timeOnSiteMinutes: 35,
                        travelToNextMinutes: 12,
                        description: "The iconic Sultan Ahmed Mosque, famous for its blue Iznik tiles."
                    ),
                    Attraction(
                        name: "Grand Bazaar",
                        coordinate: .init(latitude: 41.0106, longitude: 28.9680),
                        timeOnSiteMinutes: 50,
                        travelToNextMinutes: 0,
                        description: "One of the world's oldest and largest covered markets."
                    )
                ],
                tips: [
                    Tip(icon: "tram.fill", text: "Take the M11 metro from IST directly to the city — about 45 min.", category: .transport),
                    Tip(icon: "doc.text.fill", text: "Many nationalities can enter visa-free for short transits. Check yours first.", category: .visa),
                    Tip(icon: "bag.fill", text: "Carry a light scarf to cover shoulders inside mosques.", category: .packing),
                    Tip(icon: "clock.fill", text: "Mosques close to tourists during prayer times — plan around them.", category: .timing)
                ]
            ),
            Route(
                title: "Bosphorus Quick Stroll",
                durationMinutes: 120,
                totalDistanceMeters: 1800,
                attractions: [
                    Attraction(
                        name: "Galata Tower",
                        coordinate: .init(latitude: 41.0256, longitude: 28.9744),
                        timeOnSiteMinutes: 30,
                        travelToNextMinutes: 15,
                        description: "A medieval stone tower with panoramic views over the Golden Horn."
                    ),
                    Attraction(
                        name: "Karaköy Waterfront",
                        coordinate: .init(latitude: 41.0220, longitude: 28.9770),
                        timeOnSiteMinutes: 25,
                        travelToNextMinutes: 0,
                        description: "A lively quay lined with cafés and Bosphorus ferry piers."
                    )
                ],
                tips: [
                    Tip(icon: "tram.fill", text: "The historic Tünel funicular saves the steep climb to Galata.", category: .transport),
                    Tip(icon: "clock.fill", text: "Sunset from the tower is stunning but queues get long.", category: .timing)
                ]
            )
        ]
    )


    static let doha = City(
        name: "Doha",
        country: "Qatar",
        airportCode: "DOH",
        previewImageName: "https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=400",
        routes: [
            Route(
                title: "Corniche & Culture",
                durationMinutes: 240,
                totalDistanceMeters: 2600,
                attractions: [
                    Attraction(
                        name: "Museum of Islamic Art",
                        coordinate: .init(latitude: 25.2952, longitude: 51.5390),
                        timeOnSiteMinutes: 50,
                        travelToNextMinutes: 10,
                        description: "I. M. Pei's geometric landmark holding 1,400 years of Islamic art."
                    ),
                    Attraction(
                        name: "Souq Waqif",
                        coordinate: .init(latitude: 25.2867, longitude: 51.5333),
                        timeOnSiteMinutes: 55,
                        travelToNextMinutes: 0,
                        description: "A restored traditional market full of spices, textiles and cafés."
                    )
                ],
                tips: [
                    Tip(icon: "tram.fill", text: "The Doha Metro Gold line reaches Souq Waqif in about 25 min from DOH.", category: .transport),
                    Tip(icon: "doc.text.fill", text: "Qatar offers visa-free entry or transit visas for many travellers.", category: .visa),
                    Tip(icon: "drop.fill", text: "Bring water and sun protection — midday heat is intense.", category: .packing)
                ]
            )
        ]
    )


    static let singapore = City(
        name: "Singapore",
        country: "Singapore",
        airportCode: "SIN",
        previewImageName: "https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=400",
        routes: [
            Route(
                title: "Gardens & Marina",
                durationMinutes: 360,
                totalDistanceMeters: 4100,
                attractions: [
                    Attraction(
                        name: "Gardens by the Bay",
                        coordinate: .init(latitude: 1.2816, longitude: 103.8636),
                        timeOnSiteMinutes: 70,
                        travelToNextMinutes: 12,
                        description: "Futuristic Supertree Grove and climate-controlled conservatories."
                    ),
                    Attraction(
                        name: "Marina Bay Sands",
                        coordinate: .init(latitude: 1.2834, longitude: 103.8607),
                        timeOnSiteMinutes: 40,
                        travelToNextMinutes: 14,
                        description: "Iconic three-tower resort with a sky park overlooking the bay."
                    ),
                    Attraction(
                        name: "Merlion Park",
                        coordinate: .init(latitude: 1.2868, longitude: 103.8545),
                        timeOnSiteMinutes: 25,
                        travelToNextMinutes: 0,
                        description: "Home of Singapore's half-lion, half-fish national symbol."
                    )
                ],
                tips: [
                    Tip(icon: "tram.fill", text: "The MRT from Changy reaches Marina Bay in about 30 min.", category: .transport),
                    Tip(icon: "doc.text.fill", text: "Changi's free Singapore Tour is an option if you skip the city solo.", category: .visa),
                    Tip(icon: "clock.fill", text: "The Supertree light show runs nightly at 19:45 and 20:45.", category: .timing)
                ]
            ),
            Route(
                title: "Chinatown Flavours",
                durationMinutes: 120,
                totalDistanceMeters: 1500,
                attractions: [
                    Attraction(
                        name: "Buddha Tooth Relic Temple",
                        coordinate: .init(latitude: 1.2815, longitude: 103.8443),
                        timeOnSiteMinutes: 30,
                        travelToNextMinutes: 8,
                        description: "An ornate Tang-style temple in the heart of Chinatown."
                    ),
                    Attraction(
                        name: "Maxwell Food Centre",
                        coordinate: .init(latitude: 1.2803, longitude: 103.8447),
                        timeOnSiteMinutes: 40,
                        travelToNextMinutes: 0,
                        description: "Legendary hawker centre — try the Hainanese chicken rice."
                    )
                ],
                tips: [
                    Tip(icon: "creditcard.fill", text: "Hawker stalls are cash-friendly; carry small Singapore dollars.", category: .packing)
                ]
            )
        ]
    )


    static let reykjavik = City(
        name: "Reykjavik",
        country: "Iceland",
        airportCode: "KEF",
        previewImageName: "https://images.unsplash.com/photo-1504109586057-7a2ae83d1338?w=400",
        routes: [
            Route(
                title: "Capital Essentials",
                durationMinutes: 240,
                totalDistanceMeters: 2900,
                attractions: [
                    Attraction(
                        name: "Hallgrímskirkja",
                        coordinate: .init(latitude: 64.1417, longitude: -21.9266),
                        timeOnSiteMinutes: 35,
                        travelToNextMinutes: 10,
                        description: "A towering expressionist church with a panoramic viewing platform."
                    ),
                    Attraction(
                        name: "Sun Voyager",
                        coordinate: .init(latitude: 64.1475, longitude: -21.9220),
                        timeOnSiteMinutes: 20,
                        travelToNextMinutes: 12,
                        description: "A steel sculpture echoing a Viking ship facing the mountains."
                    ),
                    Attraction(
                        name: "Harpa Concert Hall",
                        coordinate: .init(latitude: 64.1505, longitude: -21.9325),
                        timeOnSiteMinutes: 30,
                        travelToNextMinutes: 0,
                        description: "A glittering glass façade inspired by Iceland's basalt columns."
                    )
                ],
                tips: [
                    Tip(icon: "bus.fill", text: "The Flybus connects KEF to downtown in about 45 min.", category: .transport),
                    Tip(icon: "snowflake", text: "Pack a warm waterproof layer — weather changes fast.", category: .packing),
                    Tip(icon: "clock.fill", text: "Winter daylight is short; plan the walk around midday.", category: .timing)
                ]
            )
        ]
    )
}
