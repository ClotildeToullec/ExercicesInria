Class {
	#name : #EIDocumentationGenerator,
	#superclass : #Object,
	#instVars : [
		'existingPackages',
		'directory'
	],
	#classVars : [
		'DocumentedPackages'
	],
	#category : #EIDocumentation
}

{ #category : #reset }
EIDocumentationGenerator class >> deleteAllDocumentation [
	<script>
	| documentationFile |
	documentationFile := FileSystem disk workingDirectory
		/ 'Documentation'.
	documentationFile isDirectory
		ifTrue: [ documentationFile deleteAll ].
	DocumentedPackages := OrderedCollection new
]

{ #category : #generation }
EIDocumentationGenerator class >> documentPackage: aPackageName [
	DocumentedPackages := DocumentedPackages
		ifNil: [ OrderedCollection new ].
	^ super new documentPackage: aPackageName
]

{ #category : #example }
EIDocumentationGenerator class >> example [
	<script>
	self
		documentPackage: 'Colors';
		documentPackage: 'Collections'
]

{ #category : #accessing }
EIDocumentationGenerator class >> homepage [
	^ FileSystem disk workingDirectory / 'Documentation/homepage.html'
]

{ #category : #'instance creation' }
EIDocumentationGenerator class >> new [
	self error: 'DocumentGenerators are created with documentPackage: '
]

{ #category : #generation }
EIDocumentationGenerator >> buildDocumentedPackageListIn: html [
	^ DocumentedPackages
		ifNotEmpty: [ DocumentedPackages
				do: [ :pck | 
					| pckPath |
					pckPath := WriteStream with: pck.
					pckPath
						<< '/Package_';
						<< pck;
						<< '.html'.
					html
						tag: #li
						do: [ html
								tag: #a
								attributes:
									{'href'.
									pckPath contents}
								with: pck ] ] ]
]

{ #category : #generation }
EIDocumentationGenerator >> documentPackage: aPackageName [
	EIPackageDocGenerator newForPackage: aPackageName.
	DocumentedPackages addIfNotPresent: aPackageName.
	(directory / 'homepage.html') delete.
	self generateDocumentationHomepage
]

{ #category : #generation }
EIDocumentationGenerator >> generateDocumentationHomepage [
	| homepageContents |
	homepageContents := ZnHtmlOutputStream
		streamContents: [ :html | 
			html
				page: 'Pharo Documentation'
				do: [ html
						tag: #h3 with: 'Documented Packages :';
						tag: #p
							do: [ html tag: #ul do:
								[ self buildDocumentedPackageListIn: html ] ] ] ].
	directory / 'homepage.html'
		writeStreamDo: [ :stream | stream nextPutAll: homepageContents ]
]

{ #category : #initialization }
EIDocumentationGenerator >> initialize [
	super initialize.
	directory := FileSystem disk workingDirectory / 'Documentation'.
	directory ensureCreateDirectory.
	self generateDocumentationHomepage
]
