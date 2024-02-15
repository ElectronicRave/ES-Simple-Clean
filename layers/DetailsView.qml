import QtQuick 2.12
import QtGraphicalEffects 1.12


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

}

	// The header ba on the top, with the collection's logo and name

	Rectangle {
		id: header
		property int paddingH: aspectRatio === 43 ? vpx(16*screenRatio) : vpx(16*screenRatio)
		property int paddingV: aspectRatio === 43 ? vpx(12*screenRatio) : vpx(12*screenRatio)
		height: aspectRatio === 43 ? vpx(65*screenRatio) : vpx(65*screenRatio)
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
		font.pixelSize: aspectRatio === 43 ? vpx(20*screenRatio) : vpx(20*screenRatio)
		font.weight: Font.Light
		horizontalAlignment: Text.AlignRight

	anchors {
		right: parent.right; rightMargin: header.paddingH
		verticalCenter: parent.verticalCenter
	}

}

}

	Rectangle {
		id: content
		property int paddingH: aspectRatio === 43 ? vpx(52*screenRatio) : vpx(52*screenRatio)
		property int paddingV: aspectRatio === 43 ? vpx(32*screenRatio) : vpx(32*screenRatio)
		color: "#97999a"

	anchors {
		top: header.bottom
		left: parent.left
		right: parent.right
		bottom: footer.top
	}

	Item {
		id: boxart
		height: aspectRatio === 43 ? vpx(220*screenRatio) : vpx(220*screenRatio)
		width: Math.max(aspectRatio === 43 ? vpx(230*screenRatio) : vpx(230*screenRatio), Math.min(height * boxartImage.aspectRatio, aspectRatio === 43 ? vpx(260*screenRatio) : vpx(260*screenRatio)))
		z: 1

	anchors {
		top: parent.top; topMargin: content.paddingV
		right: parent.right; rightMargin: content.paddingH
	}

	Image {
		id: boxartImage
		property double aspectRatio: (implicitWidth / implicitHeight) || 0
		source: currentGame.assets.boxFront || currentGame.assets.logo
		sourceSize { width: 256; height: 256 }
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

		Keys.onLeftPressed: { collectionsView.currentCollectionIndex = collectionsView.currentCollectionIndex + 1 } 
		Keys.onRightPressed: { collectionsView.currentCollectionIndex = collectionsView.currentCollectionIndex - 1 }

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
		leftPadding: aspectRatio === 43 ? vpx(6*screenRatio) : vpx(6*screenRatio)
		rightPadding: leftPadding
		lineHeight: 1.2
		text: modelData.title
		color: selected ? clrLight : clrDark
		font.pixelSize: aspectRatio === 43 ? vpx(13*screenRatio) : vpx(13*screenRatio)
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
		leftPadding: aspectRatio === 43 ? vpx(6*screenRatio) : vpx(6*screenRatio)
		rightPadding: leftPadding
		lineHeight: 1.2
		text: gameTitle__item.display
		color: selected ? clrLight : clrDark
		font.pixelSize: aspectRatio === 43 ? vpx(13*screenRatio) : vpx(13*screenRatio)
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

	//Footer bar

	Rectangle {
		id: footer
		height: aspectRatio === 43 ? vpx(22*screenRatio) * 1.5 : vpx(22*screenRatio) * 1.5
		color: header.color

	anchors {
		left: parent.left
		right: parent.right
		bottom: parent.bottom
	}

}

	//Footer bar helper

	Rectangle {
		id: footer__helper
		height: aspectRatio === 43 ? vpx(22*screenRatio) * 1.5 : vpx(22*screenRatio) * 1.5
		color: "transparent"

	anchors {
		left: parent.left
		right: parent.right
		bottom: parent.bottom
	}

	Image {
		id: footer__helper_back
		width: aspectRatio === 43 ? vpx(32*screenRatio) : vpx(32*screenRatio)
		height: aspectRatio === 43 ? vpx(32*screenRatio) : vpx(32*screenRatio)
		fillMode: Image.PreserveAspectFit
		source: "../assets/icons/helper_back.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#4f4f4f" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: parent.left; leftMargin: aspectRatio === 43 ? vpx(5*screenRatio) : vpx(5*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_back_label
		text: "back"
		color: "#7b7d7f"
		font.pixelSize: aspectRatio === 43 ? vpx(16*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_back.right; leftMargin: aspectRatio === 43 ? vpx(0*screenRatio) : vpx(0*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Image {
		id: footer__helper_launch
		width: aspectRatio === 43 ? vpx(32*screenRatio) : vpx(32*screenRatio)
		height: aspectRatio === 43 ? vpx(32*screenRatio) : vpx(32*screenRatio)
		fillMode: Image.PreserveAspectFit
		source: "../assets/icons/helper_launch.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#4f4f4f" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: footer__helper_back_label.right; leftMargin: aspectRatio === 43 ? vpx(4*screenRatio) : vpx(4*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_launch_label
		text: "launch"
		color: "#7b7d7f"
		font.pixelSize: aspectRatio === 43 ? vpx(16*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_launch.right; leftMargin: aspectRatio === 43 ? vpx(0*screenRatio) : vpx(0*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Image {
		id: footer__helper_system
		width: aspectRatio === 43 ? vpx(20*screenRatio) : vpx(20*screenRatio)
		height: aspectRatio === 43 ? vpx(20*screenRatio) : vpx(20*screenRatio)
		fillMode: Image.PreserveAspectFit
		source: "../assets/icons/helper_system.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#4f4f4f" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: footer__helper_launch_label.right; leftMargin: aspectRatio === 43 ? vpx(10*screenRatio) : vpx(10*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_system_label
		text: "system"
		color: "#7b7d7f"
		font.pixelSize: aspectRatio === 43 ? vpx(16*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_system.right; leftMargin: aspectRatio === 43 ? vpx(6*screenRatio) : vpx(6*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Image {
		id: footer__helper_choose
		width: aspectRatio === 43 ? vpx(20*screenRatio) : vpx(20*screenRatio)
		height: aspectRatio === 43 ? vpx(20*screenRatio) : vpx(20*screenRatio)
		fillMode: Image.PreserveAspectFit
		source: "../assets/icons/helper_choose.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#4f4f4f" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: footer__helper_system_label.right; leftMargin: aspectRatio === 43 ? vpx(10*screenRatio) : vpx(10*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_choose_label
		text: "choose"
		color: "#7b7d7f"
		font.pixelSize: aspectRatio === 43 ? vpx(16*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_choose.right; leftMargin: aspectRatio === 43 ? vpx(6*screenRatio) : vpx(6*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	MouseArea {
		anchors.fill: footer__helper_back && footer__helper_back_label
		onClicked: {
		collectionsView.focus = true
		return;
	}

}

}

}
