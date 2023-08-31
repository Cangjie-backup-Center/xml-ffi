// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from xml4cj import xml4cj.*
from std import collection.*
from std import unittest.testmacro.*
from std import collection.*
from std import math.*
main(): Int64 {
    let x: XmlParser = XmlParser(MovieHandler())
        let latestMovie = """
        <collection shelf="New Arrivals">
            <movie title="Movie 2021">
                <score>7.4</score>
                <year>2021-3</year>
                <description>This is a virtual film released in 2021 for testing.</description>
            </movie>
            <movie title="Movie 2022">
                <type>Anime, Science Fiction</type>
                <score>7</score>
                <year>2022-2</year>
                <description>This is a virtual film released in 2022 for testing.</description>
            </movie>
            <movie title="Movie 2023">
                <score>6.5</score>
                <year>2023-4</year>
                <description>This is a virtual film released in 2023 for testing.</description>
            </movie>
        </collection>
        """
        let ret =  x.parse(latestMovie)
        var returntag = -1
        match (ret) {
        case Some(k) => 
            println("XML Parse success")
        case None => 
            returntag = 1
        }
        if (returntag == 1) {
            return 0
        }
        return 1
}

public class MovieHandler <: SaxHandler {
    private var curTag: String
    private var title: String
    private var score: String
    private var year: String

    init() {
        curTag = ""
        title = ""
        score = ""
        year = ""
    }

    public func startDocument(): Unit {
        println("Start Parsing.")
    }
    public func endDocument(): Unit {
        println("End Parsing.")
    }
    public func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit {
        curTag = name
        if (name == "movie") {
            title = attrs[0].content
            println("Title: ${title}")
        }
    }
    public func endElement(name: String): Unit {
        if (curTag == "score") {
            println("Score: ${score}")
        } else if (curTag == "year") {
            println("Year: ${year}")
        }
    }
    public func characters(content: String): Unit {
        if (curTag == "score") {
            score = content
        } else if (curTag == "year") {
            year = content
        }
    }
}

