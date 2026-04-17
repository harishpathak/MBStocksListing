//
//  StockCatalog.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import Foundation

enum StockCatalog {
 
    static let all: [Stock] = [
        Stock(
            id: "AAPL", symbol: "AAPL", companyName: "Apple Inc.",
            sector: "Technology",
            description: "Apple designs, manufactures and markets smartphones, personal computers, tablets, wearables and accessories worldwide. Its ecosystem — iPhone, Mac, iPad, Apple Watch, and services — serves over 2 billion active devices.",
            currentPrice: 189.84, previousPrice: 189.85
        ),
        Stock(
            id: "MSFT", symbol: "MSFT", companyName: "Microsoft Corporation",
            sector: "Technology",
            description: "Microsoft develops and supports software, services, devices and solutions globally. Azure cloud, Office 365, LinkedIn, and Xbox are among its flagship franchises, serving enterprises and consumers alike.",
            currentPrice: 415.32, previousPrice: 415.32
        ),
        Stock(
            id: "GOOGL", symbol: "GOOGL", companyName: "Alphabet Inc.",
            sector: "Communication Services",
            description: "Alphabet is the parent of Google, the world's most-used search engine, as well as YouTube, Google Cloud, Waymo, and DeepMind. Its ad platform reaches billions of users every day.",
            currentPrice: 175.98, previousPrice: 175.98
        ),
        Stock(
            id: "AMZN", symbol: "AMZN", companyName: "Amazon.com Inc.",
            sector: "Consumer Discretionary",
            description: "Amazon operates the world's largest e-commerce marketplace and AWS, the dominant cloud computing platform. Its logistics network, Prime Video, Alexa, and advertising business further diversify revenues.",
            currentPrice: 192.45, previousPrice: 192.45
        ),
        Stock(
            id: "NVDA", symbol: "NVDA", companyName: "NVIDIA Corporation",
            sector: "Technology",
            description: "NVIDIA designs graphics processing units and system-on-chip units for gaming, professional visualization, data centers, and automotive markets. Its CUDA platform and H100 GPUs power the generative AI revolution.",
            currentPrice: 875.40, previousPrice: 875.40
        ),
        Stock(
            id: "META", symbol: "META", companyName: "Meta Platforms Inc.",
            sector: "Communication Services",
            description: "Meta owns Facebook, Instagram, WhatsApp and Threads — platforms used by nearly 4 billion people monthly. Its Reality Labs division is building the metaverse through AR/VR hardware and software.",
            currentPrice: 504.22, previousPrice: 504.22
        ),
        Stock(
            id: "TSLA", symbol: "TSLA", companyName: "Tesla Inc.",
            sector: "Consumer Discretionary",
            description: "Tesla designs, develops and sells electric vehicles, energy storage systems and solar products. Its Full Self-Driving software, Gigafactories, and Supercharger network position it at the forefront of sustainable transport.",
            currentPrice: 248.60, previousPrice: 248.60
        ),
        Stock(
            id: "AVGO", symbol: "AVGO", companyName: "Broadcom Inc.",
            sector: "Technology",
            description: "Broadcom designs and supplies a broad range of semiconductor and infrastructure software solutions for data centers, networking, broadband, wireless, storage and industrial markets.",
            currentPrice: 1342.75, previousPrice: 1342.75
        ),
        Stock(
            id: "JPM", symbol: "JPM", companyName: "JPMorgan Chase & Co.",
            sector: "Financials",
            description: "JPMorgan Chase is the largest U.S. bank by assets, offering investment banking, financial services, commercial banking, financial transaction processing, asset management and private banking globally.",
            currentPrice: 198.30, previousPrice: 198.30
        ),
        Stock(
            id: "LLY", symbol: "LLY", companyName: "Eli Lilly and Company",
            sector: "Health Care",
            description: "Eli Lilly discovers, develops and markets pharmaceuticals worldwide. Its GLP-1 drugs Mounjaro and Zepbound for diabetes and obesity have made it one of the world's most valuable healthcare companies.",
            currentPrice: 782.56, previousPrice: 782.56
        ),
        Stock(
            id: "V", symbol: "V", companyName: "Visa Inc.",
            sector: "Financials",
            description: "Visa operates the world's largest retail electronic payments network, facilitating global commerce through the transfer of value and information among consumers, merchants, financial institutions and governments.",
            currentPrice: 279.44, previousPrice: 279.44
        ),
        Stock(
            id: "UNH", symbol: "UNH", companyName: "UnitedHealth Group Inc.",
            sector: "Health Care",
            description: "UnitedHealth Group is a diversified health care company offering health care coverage, benefits, services and analytics through UnitedHealthcare and Optum, its health services business.",
            currentPrice: 524.18, previousPrice: 524.18
        ),
        Stock(
            id: "XOM", symbol: "XOM", companyName: "Exxon Mobil Corporation",
            sector: "Energy",
            description: "ExxonMobil is the largest publicly traded international oil and gas company, engaged in exploration, production, refining, marketing, and chemical manufacturing across more than 60 countries.",
            currentPrice: 118.72, previousPrice: 118.72
        ),
        Stock(
            id: "MA", symbol: "MA", companyName: "Mastercard Incorporated",
            sector: "Financials",
            description: "Mastercard is a global payments and technology company connecting consumers, financial institutions, merchants, governments, digital partners and businesses worldwide through its transaction-processing network.",
            currentPrice: 473.91, previousPrice: 473.91
        ),
        Stock(
            id: "HD", symbol: "HD", companyName: "The Home Depot Inc.",
            sector: "Consumer Discretionary",
            description: "Home Depot is the world's largest home improvement retailer, operating over 2,300 warehouse-format stores across North America selling building materials, home improvement products and lawn and garden products.",
            currentPrice: 361.25, previousPrice: 361.25
        ),
        Stock(
            id: "PG", symbol: "PG", companyName: "Procter & Gamble Co.",
            sector: "Consumer Staples",
            description: "Procter & Gamble sells branded consumer goods in over 180 countries. Its portfolio of trusted brands — Tide, Gillette, Pampers, Oral-B, and SK-II — makes it a cornerstone of household consumption globally.",
            currentPrice: 164.80, previousPrice: 164.80
        ),
        Stock(
            id: "COST", symbol: "COST", companyName: "Costco Wholesale Corporation",
            sector: "Consumer Staples",
            description: "Costco operates membership-only warehouse clubs offering merchandise at significantly lower prices than conventional wholesale or retail sources. Its high membership renewal rates signal exceptional customer loyalty.",
            currentPrice: 895.60, previousPrice: 895.60
        ),
        Stock(
            id: "NFLX", symbol: "NFLX", companyName: "Netflix Inc.",
            sector: "Communication Services",
            description: "Netflix is the world's leading streaming entertainment service with over 260 million paid subscribers across 190 countries. Its investment in original content, live events, and gaming differentiates it in a crowded market.",
            currentPrice: 628.34, previousPrice: 628.34
        ),
        Stock(
            id: "AMD", symbol: "AMD", companyName: "Advanced Micro Devices Inc.",
            sector: "Technology",
            description: "AMD designs and sells semiconductor products including x86 microprocessors, graphics processing units and related technologies. Its Ryzen, EPYC and Instinct product lines challenge Intel and NVIDIA across markets.",
            currentPrice: 178.92, previousPrice: 178.92
        ),
        Stock(
            id: "CRM", symbol: "CRM", companyName: "Salesforce Inc.",
            sector: "Technology",
            description: "Salesforce is the world's #1 CRM platform, offering cloud-based applications for sales, service, marketing and commerce. Its Einstein AI layer and AppExchange ecosystem span every industry vertical.",
            currentPrice: 289.46, previousPrice: 289.46
        ),
        Stock(
            id: "ORCL", symbol: "ORCL", companyName: "Oracle Corporation",
            sector: "Technology",
            description: "Oracle offers database software and technology, cloud engineered systems, and enterprise software products, including its own suite of cloud applications for ERP, HCM, and CX.",
            currentPrice: 122.34, previousPrice: 122.34
        ),
        Stock(
            id: "INTC", symbol: "INTC", companyName: "Intel Corporation",
            sector: "Technology",
            description: "Intel designs, manufactures and sells computer components and related products worldwide. Its foundry strategy and next-generation node development are central to its effort to recapture technological leadership.",
            currentPrice: 43.18, previousPrice: 43.18
        ),
        Stock(
            id: "DIS", symbol: "DIS", companyName: "The Walt Disney Company",
            sector: "Communication Services",
            description: "Disney is a diversified global entertainment company operating theme parks, media networks, streaming via Disney+, Hulu and ESPN+, and a studio that produces Marvel, Star Wars and Pixar content.",
            currentPrice: 112.45, previousPrice: 112.45
        ),
        Stock(
            id: "BA", symbol: "BA", companyName: "The Boeing Company",
            sector: "Industrials",
            description: "Boeing designs, manufactures and sells commercial jetliners, military aircraft, satellites, missile defense and space systems. Its 737 MAX recovery and defense backlog are key drivers for the medium-term outlook.",
            currentPrice: 198.76, previousPrice: 198.76
        ),
        Stock(
            id: "GS", symbol: "GS", companyName: "The Goldman Sachs Group Inc.",
            sector: "Financials",
            description: "Goldman Sachs is a leading global investment banking, securities and investment management firm, providing services to corporations, financial institutions, governments and individuals worldwide.",
            currentPrice: 455.82, previousPrice: 455.82
        ),
    ]
}
