Class {
	#name : #EIPackageDocGenerator,
	#superclass : #Object,
	#instVars : [
		'package',
		'directory',
		'homepage'
	],
	#category : #EIDocumentation
}

{ #category : #'instance creation' }
EIPackageDocGenerator class >> newForPackage: packageName [
	^ self basicNew
		package: packageName;
		initialize
]

{ #category : #'class pages' }
EIPackageDocGenerator >> buildCommentOfClass: aClass In: html [
	aClass hasComment
		ifTrue: [ html
				tag: #h3 with: 'Class comment :';
				tag: #p with: aClass comment ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> buildMethodsForProtocol: protocol inClassSide: aClassSide in: html [
	html
		tag: #p
		do: [ html
				tag: #ul
				do: [ (aClassSide methods
						select: [ :method | method protocol == protocol ])
						do: [ :method | 
							html tag: #li with: method selector asString.
							method numArgs > 0
								ifTrue: [ html
										tag: #details
										do: [ html
												tag: #summary with: 'Arguments';
												tag: #ul
													do: [ method argumentNames do: [ :arg | html tag: #li with: arg ] ] ] ].
							method comment
								ifNotNil: [ html
										tag: #details
										do: [ html
												tag: #summary with: 'Comment';
												tag: #p with: method comment ] ] ] ] ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> buildProtocolsFor: aClassSide In: html [
	aClassSide protocols
		do: [ :protocol | 
			html
				tag: #h4 with: protocol asString;
				tag: #ul
					do: [ self
						buildMethodsForProtocol: protocol
						inClassSide: aClassSide
						in: html ] ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> buildSuperclassOf: aClass In: html [
	aClass superclass ifNil: [ ^ self ].
	aClass superclass category == package
		ifTrue:
			[ html tag: #h4 with: 'Superclass : ' , aClass superclass printString ]
]

{ #category : #initialization }
EIPackageDocGenerator >> checkPackageExistence [
	(SystemNavigation default allClassesInPackageNamed: package)
		ifEmpty: [ self error: 'This package is empty or does not exist.' ]
]

{ #category : #homepage }
EIPackageDocGenerator >> generateClassListIn: html [
	html
		tag: #ul
		do: [ (SystemNavigation default allClassesInPackageNamed: package)
				do: [ :class | 
					| classFileName |
					(class inheritsFrom: TestCase)
						ifFalse: [ self generatePageForClass: class.
							classFileName := WriteStream with: class printString.
							classFileName nextPutAll: '.html'.
							html
								tag: #li
								do: [ html
										tag: #a
										attributes:
											{'href'.
											classFileName contents}
										with: class printString ] ] ] ]
]

{ #category : #homepage }
EIPackageDocGenerator >> generateHomePage [
	| homepageContents |
	homepageContents := ZnHtmlOutputStream
		streamContents: [ :html | 
			html
				page: package
				do: [ self linkToDocumentationHomePageIn: html.
					html
						tag: #h3 with: 'Classes :';
						tag: #p do: [ self generateClassListIn: html ] ] ].
	directory / homepage
		writeStreamDo: [ :stream | stream nextPutAll: homepageContents ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> generatePageForClass: aClass [
	| classPageContents classFile |
	classPageContents := ZnHtmlOutputStream
		streamContents: [ :html | 
			html
				page: aClass printString
				do: [ self
						linkToDocumentationHomePageIn: html;
						linkToPackageHomepageIn: html;
						buildSuperclassOf: aClass In: html;
						buildCommentOfClass: aClass In: html.
					html
						tag: #h3 with: 'Class methods :';
						tag: #p
							do: [ self buildProtocolsFor: aClass classSide In: html ];
						tag: #h3 with: 'Instance methods :';
						tag: #p
							do: [ self buildProtocolsFor: aClass In: html ] ] ].
	classFile := aClass printString , '.html'.
	directory / classFile
		writeStreamDo: [ :stream | stream nextPutAll: classPageContents ]
]

{ #category : #initialization }
EIPackageDocGenerator >> initialize [
	super initialize.
	self checkPackageExistence.
	directory := FileSystem disk workingDirectory / 'Documentation'
		/ package.
	directory ensureCreateDirectory.
	homepage := 'Package_' , package , '.html'.
	self generateHomePage
]

{ #category : #'private - utilities' }
EIPackageDocGenerator >> linkToDocumentationHomePageIn: html [
	html
		tag: #p
		do: [ html
				tag: #a
				attributes:
					{'href'.
					EIDocumentationGenerator homepage fullName}
				with: 'Back to Documentation homepage' ]
]

{ #category : #'private - utilities' }
EIPackageDocGenerator >> linkToPackageHomepageIn: html [
	html
		tag: #p
		do: [ html
				tag: #a
				attributes:
					{'href'.
					homepage}
				with: 'Back to package homepage' ]
]

{ #category : #accessing }
EIPackageDocGenerator >> package [
	^ package
]

{ #category : #accessing }
EIPackageDocGenerator >> package: aString [
	package := aString
]
