import QtQuick 2.12
import QtGraphicalEffects 1.12


	//The collections view consists of two carousels, one for the collection logo bar and one for the background images.

	FocusScope {
		id: root
		property alias currentCollectionIndex: logoAxis.currentIndex
		property var currentCollection: logoAxis.model.get(logoAxis.currentIndex)
		property bool selected: currentIndex
		width: parent.width
		height: parent.height
		enabled: focus
		visible: y + height >= 0

	//The carousel of background images.

	Carousel {
		id: bgAxis
		itemWidth: width
		model: api.collections
		delegate: bgAxisItem
		currentIndex: logoAxis.currentIndex
		highlightMoveDuration: 500

		anchors {
			fill: parent
		}

}

	//Either the image for the collection or a single colored rectangle

	Component {
		id: bgAxisItem

	Item {
		width: root.width
		height: root.height
		visible: PathView.onPath

	Rectangle {
		color: "#777"
		visible: realBg.status != Image.Ready

		anchors {
			fill: parent
		}

}

	Image {
		id: realBg
		fillMode: Image.PreserveAspect
		source: modelData.shortName ? "../assets/images/backgrounds/%1_art_blur.png".arg(modelData.shortName) : ""
		asynchronous: true

		anchors {
			fill: parent
		}

	}

}

}

	//Footer bar helper

	Rectangle {
		id: footer__helper
		height: aspectRatio === 43 ? vpx(24*screenRatio) * 1.5 : vpx(22*screenRatio) * 1.5
		color: "transparent"

	anchors {
		left: parent.left
		right: parent.right
		bottom: parent.bottom
	}

	Image {
		id: footer__helper_select
		sourceSize.width: aspectRatio === 43 ? vpx(34*screenRatio) : vpx(32*screenRatio)
		fillMode: Image.PreserveAspectCrop
		source: "../assets/icons/helper_launch.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#2c2c2c" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: parent.left; leftMargin: aspectRatio === 43 ? vpx(5*screenRatio) : vpx(5*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_select_label
		text: "select"
		color: "#2c2c2c"
		font.pixelSize: aspectRatio === 43 ? vpx(18*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_select.right; leftMargin: aspectRatio === 43 ? vpx(0*screenRatio) : vpx(0*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Image {
		id: footer__helper_choose
		sourceSize.width: aspectRatio === 43 ? vpx(22*screenRatio) : vpx(20*screenRatio)
		fillMode: Image.PreserveAspectCrop
		source: "../assets/icons/helper_system.svg"
		layer.enabled: true
		layer.effect: ColorOverlay { color: "#2c2c2c" }
		antialiasing: true
		smooth: true
		opacity: 0.8

	anchors {
		left: footer__helper_select_label.right; leftMargin: aspectRatio === 43 ? vpx(12*screenRatio) : vpx(10*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

	Text {
		id: footer__helper_choose_label
		text: "choose"
		color: "#2c2c2c"
		font.pixelSize: aspectRatio === 43 ? vpx(18*screenRatio) : vpx(16*screenRatio)
		font.capitalization: Font.AllUppercase
		font.family: "Open Sans"
		verticalAlignment: Text.AlignVCenter

	anchors {
		left: footer__helper_choose.right; leftMargin: aspectRatio === 43 ? vpx(6*screenRatio) : vpx(6*screenRatio)
		verticalCenter: parent.verticalCenter
	}

}

}

	//Logo bar

	Item {
		id: logoBar
		height: aspectRatio === 43 ? vpx(100*screenRatio) : vpx(90*screenRatio)

	anchors {
		top: parent.top; topMargin: aspectRatio === 43 ? vpx(175*screenRatio) : vpx(132*screenRatio)
		left: parent.left
		right: parent.right
	}

	//Background

	Rectangle {
		anchors.fill: parent
		color: "#fff"
		opacity: 0.85
}

	//The main carousel that we actually control

	Carousel {
		id: logoAxis
		itemWidth:  aspectRatio === 43 ? vpx(238*screenRatio) : vpx(255*screenRatio)
		model: api.collections

		anchors {
			fill: parent
		}

	delegate:

	Logo {
		longName: modelData.name
		shortName: modelData.shortName
}

		focus: true

	//Launch content

	Keys.onPressed: {
		if (api.keys.isAccept(event)) {
		event.accepted = true;
		onItemSelected: software.focus = true
	}

}

	MouseArea {
		id: logoAxis_mouse
		anchors.fill: logoAxis
		onClicked: {
			onItemSelected: software.focus = true
	}

}

}
    
}

	// Game count bar

	Item {
		height: label.height * 1.5

		anchors {
			top: logoBar.bottom
			left: parent.left
			right: parent.right
		}

	Rectangle {
		color: "#ddd"
		opacity: 0.85

		anchors {
			fill: parent
		}

}

	Text {
		id: label
		text: "%1 GAMES AVAILABLE".arg(currentCollection.games.count)
		color: "#333"
		font.pixelSize: aspectRatio === 43 ? vpx(16*screenRatio) : vpx(14*screenRatio)
		font.family: "Open Sans"

		anchors {
			centerIn: parent
		}

}

}

}
