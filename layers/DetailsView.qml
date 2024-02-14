import QtQuick 2.12


	//Properties to display the list and images in the current collection

	FocusScope {
		id: root
		property var currentCollection: collectionsView.currentCollection
		property alias currentGameIndex: gameView.currentIndex
		property var currentGame: currentCollection.games.get(currentGameIndex)
		width: parent.width
		height: parent.height
		enabled: focus
		visible: y < parent.height

	Keys.onPressed: {

		//Launch content

		if (api.keys.isAccept(event)) {
		event.accepted = true;
		api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
		api.memory.set('gameIndex', currentGameIndex);
		currentGame.launch();
		return;
	}

		//Back to home

		if (api.keys.isCancel(event)) {
		event.accepted = true;
		collectionsView.focus = true
		return;
	}

		//Next page

		if (api.keys.isNextPage(event)) {
		event.accepted = true
		gameView.currentIndex = Math.min(gameView.currentIndex + 5, currentCollection.games.count - 1)
		return;

}

		//Prev page

		if (api.keys.isPrevPage(event)) {
		event.accepted = true
		gameView.currentIndex = Math.max(gameView.currentIndex - 5, 0)
		return;

}

		//Next collection

		if (api.keys.isPageDown(event)) {
		event.accepted = true;
		collectionsView.currentCollectionIndex = collectionsView.currentCollectionIndex + 1
		return;
	}

		//Prev collection

		if (api.keys.isPageUp(event)) {
		event.accepted = true;
		collectionsView.currentCollectionIndex = collectionsView.currentCollectionIndex - 1
		return;
	}

}

	// The header ba on the top, with the collection's logo and name

	Rectangle {
		id: header
		property int paddingH: vpx(30) // H as horizontal
		property int paddingV: vpx(22) // V as vertical
		height: vpx(115)
		color: "#c5c6c7"

	anchors {
		top: parent.top
		left: parent.left
		right: parent.right
	}

	Image {
		height: parent.height - header.paddingV * 2
		fillMode: Image.PreserveAspectFit
		horizontalAlignment: Image.AlignLeft
		source: currentCollection.shortName ? "../assets/images/logos/%1.svg".arg(currentCollection.shortName) : ""
		asynchronous: true

	anchors {
		left: parent.left; leftMargin: header.paddingH
		right: parent.horizontalCenter; rightMargin: header.paddingH
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		width: parent.width * 0.35
		text: currentCollection.name
		wrapMode: Text.WordWrap
		color: "#7b7d7f"
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		font.pixelSize: vpx(32)
		font.weight: Font.Light // this is how you use the light variant
		horizontalAlignment: Text.AlignRight

	anchors {
		right: parent.right; rightMargin: header.paddingH
		verticalCenter: parent.verticalCenter
	}

}

}

	Rectangle {
		id: content
		property int paddingH: vpx(110)
		property int paddingV: vpx(75)
		color: "#97999a"

	anchors {
		top: header.bottom
		left: parent.left
		right: parent.right
		bottom: footer.top
	}

	Item {
		id: boxart
		height: vpx(418)
		width: Math.max(vpx(460), Math.min(height * boxartImage.aspectRatio, vpx(520)))
		z: 1

	anchors {
		top: parent.top; topMargin: content.paddingV
		right: parent.right; rightMargin: content.paddingH
	}

	Image {
		id: boxartImage
		property double aspectRatio: (implicitWidth / implicitHeight) || 0
		source: currentGame.assets.boxFront || currentGame.assets.logo
		sourceSize { width: 256; height: 256 } // optimization (max size)
		fillMode: Image.PreserveAspectFit
		asynchronous: true
		horizontalAlignment: Image.AlignHCenter

	anchors {
		fill: parent
	}

}

}

	ListView {
		id: gameView
		width: parent.width * 0.35
		model: currentCollection.games
		focus: true

	anchors {
		top: parent.top; topMargin: content.paddingV
		left: parent.left; leftMargin: content.paddingH
		bottom: parent.bottom; bottomMargin: content.paddingV
	}

	delegate:

	Rectangle {
		property bool selected: ListView.isCurrentItem
		property color clrDark: "#393a3b"
		property color clrLight: "#97999b"
		width: ListView.view.width
		height: gameTitle.height
		color: selected ? clrDark : clrLight

	Text {
		id: gameTitle
		width: parent.width
		leftPadding: vpx(10)
		rightPadding: leftPadding
		lineHeight: 1.2
		text: modelData.title
		color: selected ? clrLight : clrDark
		font.pixelSize: vpx(24)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter
		elide: Text.ElideRight
		visible: selected ? 0 : 1

}

	Item {
		id: gameTitle__item
		property string text: modelData.title
		property string spacing: "          "
		property string combined: text + spacing
		property string display: combined.substring(step) + combined.substring(0, step)
		property int step: 0

	Text {
		id: gameTitle__animation
		width: parent.width
		leftPadding: vpx(10)
		rightPadding: leftPadding
		lineHeight: 1.2
		text: gameTitle__item.display
		color: selected ?clrLight : clrDark
		font.pixelSize: vpx(24)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter
		visible: selected ? 1 : 0
}

	Timer {
		id: gameTitle_animation_timer
		interval: 300
		running: selected ? gameTitle.truncated : 0
		repeat: true
		onTriggered: parent.step = (parent.step + 1) % parent.combined.length
	}

}

	MouseArea {
		anchors.fill: gameTitle
		onClicked: {
			if (selected) {
			api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
			api.memory.set('gameIndex', currentGameIndex);
			currentGame.launch();
			return;
	}
	else
			gameView.currentIndex = index
	}

}

}

	highlightRangeMode: ListView.ApplyRange
	highlightMoveDuration: 0
	preferredHighlightBegin: height * 0.5 - vpx(15)
	preferredHighlightEnd: height * 0.5 + vpx(15)

}

}

	Rectangle {
		id: footer
		height: vpx(25) * 1.5
		color: header.color

	anchors {
		left: parent.left
		right: parent.right
		bottom: parent.bottom
	}

}

}
