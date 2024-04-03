import QtQuick 2.12
import QtGraphicalEffects 1.12


	//Properties to display the list and images in the current collection

	FocusScope {
		id: root
		property var currentCollection: home.currentCollection
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
		api.memory.set('collectionIndex', home.currentCollectionIndex);
		api.memory.set('gameIndex', currentGameIndex);
		currentGame.launch();
		return;
	}

		//Back to home

		if (api.keys.isCancel(event)) {
		event.accepted = true;
		home.focus = true
		return;
	}

}

	// The header ba on the top, with the collection's logo and name

	Rectangle {
		id: header
		property int paddingH: aspectRatio === 43 ? vpx(26*screenRatio) : vpx(16*screenRatio)
		property int paddingV: aspectRatio === 43 ? vpx(22*screenRatio) : vpx(12*screenRatio)
		height: aspectRatio === 43 ? vpx(75*screenRatio) : vpx(65*screenRatio)
		color: "#c5c6c7"

	anchors {
		top: parent.top
		left: parent.left
		right: parent.right
	}

	Image {
		sourceSize.height: aspectRatio === 43 ? parent.height - header.paddingV * 1 : parent.height - header.paddingV * 2
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
		width: aspectRatio === 43 ? parent.width * 0.40 : parent.width * 0.35
		text: currentCollection.name
		wrapMode: Text.WordWrap
		color: "#7b7d7f"
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		font.pixelSize: aspectRatio === 43 ? vpx(22*screenRatio) : vpx(20*screenRatio)
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
		property int paddingH: aspectRatio === 43 ? vpx(43*screenRatio) : vpx(53*screenRatio)
		property int paddingV: aspectRatio === 43 ? vpx(42*screenRatio) : vpx(32*screenRatio)
		color: "#97999a"

	anchors {
		top: header.bottom
		left: parent.left
		right: parent.right
		bottom: footer__helper.top
	}

	Item {
		id: boxart
		height: aspectRatio === 43 ? vpx(290*screenRatio) : vpx(220*screenRatio)
		width: Math.max(aspectRatio === 43 ? vpx(230*screenRatio) : vpx(230*screenRatio), Math.min(height * boxartImage.aspectRatio, aspectRatio === 43 ? vpx(260*screenRatio) : vpx(260*screenRatio)))
		z: 1

	anchors {
		top: parent.top; topMargin: content.paddingV
		right: parent.right; rightMargin: content.paddingH
		bottom: parent.bottom; bottomMargin: content.paddingV
	}

	Image {
		id: boxartImage
		property double aspectRatio: (implicitWidth / implicitHeight) || 0
		source: currentGame.assets.boxFront || currentGame.assets.logo
		sourceSize { width: 256; height: 256 }
		fillMode: Image.PreserveAspectFit
		asynchronous: true

	anchors {
		fill: parent
	}

}

}

	ListView {
		id: gameView
		width: aspectRatio === 43 ? parent.width * 0.40 : parent.width * 0.35
		model: currentCollection.games
		focus: true

	anchors {
		top: parent.top; topMargin: content.paddingV
		left: parent.left; leftMargin: content.paddingH
		bottom: parent.bottom; bottomMargin: content.paddingV
	}

		Keys.onLeftPressed: { home.currentCollectionIndex = home.currentCollectionIndex + 1 } 
		Keys.onRightPressed: { home.currentCollectionIndex = home.currentCollectionIndex - 1 }

	delegate:

	Rectangle {
		property bool selected: ListView.isCurrentItem
		property color clrDark: "#393a3b"
		property color clrLight: "#97999b"
		width: ListView.view.width
		height: game__title.height
		color: selected ? clrDark : clrLight

	Text {
		id: game__title
		width: parent.width
		leftPadding: aspectRatio === 43 ? vpx(6*screenRatio) : vpx(6*screenRatio)
		rightPadding: leftPadding
		lineHeight: aspectRatio === 43 ? 1.3 : 1.2
		text: modelData.title
		color: selected ? clrLight : clrDark
		font.pixelSize: aspectRatio === 43 ? vpx(15*screenRatio) : vpx(13*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter
		elide: Text.ElideRight
		visible: selected ? 0 : 1

}

	Item {
		id: game__title_animation_item
		property alias text: game__title_animation.text
		property int spacing: 80
  		width: game__title_animation.width + spacing
   		height: game__title_animation.height
  		clip: true

	Text {
		id: game__title_animation
		leftPadding: game__title.leftPadding
		rightPadding: game__title.rightPadding
		lineHeight: game__title.lineHeight
		text: game__title.text
		color: game__title.color
		font.pixelSize: game__title.font.pixelSize
		font.capitalization: game__title.font.capitalization
		font.family: game__title.font.family
		verticalAlignment: game__title.verticalAlignment
		visible: selected ? 1 : 0

	SequentialAnimation on x {
		running: selected ? game__title.truncated : 0
		loops: Animation.Infinite

	NumberAnimation {
		from: 0;
		to: - game__title_animation_item.width
		duration: 16 * Math.abs (to - from) //Speed at which text moves
	}

	PauseAnimation {
		duration: 1000 //Wait 1 second to continue
	}

}

	Text {
		id: game__title_animation_sequence
		x: game__title_animation_item.width
		leftPadding: game__title_animation.leftPadding
		rightPadding: game__title_animation.rightPadding
		lineHeight: game__title_animation.lineHeight
		text: game__title_animation.text
		color: game__title_animation.color
		font.pixelSize: game__title_animation.font.pixelSize
		font.capitalization: game__title_animation.font.capitalization
		font.family: game__title_animation.font.family
		verticalAlignment: game__title_animation.verticalAlignment
		visible: game__title_animation.visible
      }

}

}

	MouseArea {
		id: game__title_mouse
		anchors.fill: game__title
		onClicked: {
			if (selected) {
			api.memory.set('collectionIndex', home.currentCollectionIndex);
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
	preferredHighlightBegin: height * 0.5 - vpx(2)
	preferredHighlightEnd: height * 0.5 + vpx(2)
	clip: true

}

}

	//Footer bar

	Rectangle {
		id: footer__helper
		height: aspectRatio === 43 ? vpx(24*screenRatio) * 1.5 : vpx(22*screenRatio) * 1.5
		color: header.color

	anchors {
		left: parent.left
		right: parent.right
		bottom: parent.bottom
	}

	Image {
		id: footer__helper_back
		sourceSize.width: aspectRatio === 43 ? vpx(34*screenRatio) : vpx(32*screenRatio)
		fillMode: Image.PreserveAspectCrop
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
		font.pixelSize: aspectRatio === 43 ? vpx(18*screenRatio) : vpx(16*screenRatio)
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
		sourceSize.width: aspectRatio === 43 ? vpx(34*screenRatio) : vpx(32*screenRatio)
		fillMode: Image.PreserveAspectCrop
		source: "../assets/icons/helper_launch.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#4f4f4f" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: footer__helper_back_label.right; leftMargin: aspectRatio === 43 ? vpx(6*screenRatio) : vpx(4*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_launch_label
		text: "launch"
		color: "#7b7d7f"
		font.pixelSize: aspectRatio === 43 ? vpx(18*screenRatio) : vpx(16*screenRatio)
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
		sourceSize.width: aspectRatio === 43 ? vpx(22*screenRatio) : vpx(20*screenRatio)
		fillMode: Image.PreserveAspectCrop
		source: "../assets/icons/helper_system.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#4f4f4f" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: footer__helper_launch_label.right; leftMargin: aspectRatio === 43 ? vpx(12*screenRatio) : vpx(10*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_system_label
		text: "system"
		color: "#7b7d7f"
		font.pixelSize: aspectRatio === 43 ? vpx(18*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_system.right; leftMargin: aspectRatio === 43 ? vpx(8*screenRatio) : vpx(6*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Image {
		id: footer__helper_choose
		sourceSize.width: aspectRatio === 43 ? vpx(22*screenRatio) : vpx(20*screenRatio)
		fillMode: Image.PreserveAspectCrop
		source: "../assets/icons/helper_choose.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#4f4f4f" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: footer__helper_system_label.right; leftMargin: aspectRatio === 43 ? vpx(12*screenRatio) : vpx(10*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_choose_label
		text: "choose"
		color: "#7b7d7f"
		font.pixelSize: aspectRatio === 43 ? vpx(18*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_choose.right; leftMargin: aspectRatio === 43 ? vpx(8*screenRatio) : vpx(6*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	MouseArea {
		id: footer__helper_back_label_mouse
		anchors.fill: footer__helper_back_label
		onClicked: {
		home.focus = true
		return;
	}

}

}

}
