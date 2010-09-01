
TestResource subclass: PPParserResource [
    | parsers |
    
    <comment: nil>
    <category: 'PetitTests-Core'>

    parserAt: aParserClass [
	"Answer a cached instance of aParserClass."

	<category: 'accessing'>
	^parsers at: aParserClass name ifAbsentPut: [aParserClass new]
    ]

    setUp [
	<category: 'running'>
	super setUp.
	parsers := Dictionary new
    ]
]



TestCase subclass: PPAbstractParseTest [
    
    <comment: nil>
    <category: 'PetitTests-Core'>

    PPAbstractParseTest class >> isAbstract [
	<category: 'testing'>
	^self name = #PPAbstractParseTest
    ]

    PPAbstractParseTest class >> packageNamesUnderTest [
	<category: 'accessing'>
	^#('PetitParser' 'PetitTests')
    ]

    assert: aParser fail: aCollection [
	<category: 'utilities'>
	| stream result |
	self assert: aParser isPetitParser.
	stream := aCollection asPetitStream.
	result := aParser parse: stream.
	self assert: result isPetitFailure.
	self assert: stream position = 0
    ]

    assert: aParser parse: aCollection [
	<category: 'utilities'>
	self 
	    assert: aParser
	    parse: aCollection
	    to: nil
	    end: aCollection size
    ]

    assert: aParser parse: aCollection end: anInteger [
	<category: 'utilities'>
	self 
	    assert: aParser
	    parse: aCollection
	    to: nil
	    end: anInteger
    ]

    assert: aParser parse: aCollection to: anObject [
	<category: 'utilities'>
	self 
	    assert: aParser
	    parse: aCollection
	    to: anObject
	    end: aCollection size
    ]

    assert: aParser parse: aParseObject to: aTargetObject end: anInteger [
	<category: 'utilities'>
	| stream result |
	self assert: aParser isPetitParser.
	stream := aParseObject asPetitStream.
	result := aParser parse: stream.
	aTargetObject isNil 
	    ifTrue: [self deny: result isPetitFailure]
	    ifFalse: [self assert: result = aTargetObject].
	self assert: stream position = anInteger
    ]

    assert: aParser parse: aParserObject toToken: from stop: to [
	<category: 'utilities'>
	| token |
	token := PPToken 
		    on: aParserObject
		    start: from
		    stop: to.
	^self 
	    assert: aParser
	    parse: aParserObject
	    to: token
    ]

    assert: aParser parse: aParserObject toToken: from stop: to end: end [
	<category: 'utilities'>
	| token |
	token := PPToken 
		    on: aParserObject
		    start: from
		    stop: to.
	^self 
	    assert: aParser
	    parse: aParserObject
	    to: token
	    end: end
    ]
]



PPAbstractParseTest subclass: PPCompositeParserTest [
    | parser |
    
    <comment: nil>
    <category: 'PetitTests-Core'>

    PPCompositeParserTest class >> isAbstract [
	<category: 'testing'>
	^self name = #PPCompositeParserTest
    ]

    PPCompositeParserTest class >> resources [
	<category: 'accessing'>
	^Array with: PPParserResource
    ]

    assert: aCollection is: anObject [
	<category: 'utilities'>
	| result |
	result := self parse: aCollection.
	self 
	    assert: result = anObject
	    description: 'Got: ' , result printString , '; Expected: ' 
		    , anObject printString
	    resumable: true
    ]

    parse: aString [
	<category: 'utilities'>
	^parser parse: aString onError: [:err :pos | self error: err]
    ]

    parse: aString production: aSymbol [
	<category: 'utilities'>
	^(parser productionAt: aSymbol) parse: aString
	    onError: [:err :pos | self error: err]
    ]

    parserClass [
	<category: 'accessing'>
	self subclassResponsibility
    ]

    parserInstance [
	<category: 'accessing'>
	^PPParserResource current parserAt: self parserClass
    ]

    setUp [
	<category: 'running'>
	super setUp.
	parser := self parserInstance
    ]
]

