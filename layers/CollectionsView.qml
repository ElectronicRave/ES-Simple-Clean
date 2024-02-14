import QtQuick 2.12


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
		fillMode: Image.PreserveAspectCrop 
		source: modelData.shortName ? "../assets/images/backgrounds/%1_art_blur.png".arg(modelData.shortName) : ""
		asynchronous: true

		anchors {
			fill: parent
		}

	}

}

}

	Item {
		id: logoBar
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		height: aspectRatio === 43 ? vpx(90*screenRatio) : vpx(90*screenRatio)

	//Background

	Rectangle {
		anchors.fill: parent
		color: "#fff"
		opacity: 0.85
}

	//The main carousel that we actually control

	Carousel {
		id: logoAxis

		anchors.fill: parent
		itemWidth:  aspectRatio === 43 ? vpx(255*screenRatio) : vpx(255*screenRatio)

		model: api.collections

	delegate:

	 CollectionLogo {
		longName: modelData.name
		shortName: modelData.shortName
}

		focus: true

	//Launch content

	Keys.onPressed: {
		if (api.keys.isAccept(event)) {
		event.accepted = true;
		onItemSelected: detailsView.focus = true
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

	MouseArea {
		anchors.fill: parent
		onClicked: {
			onItemSelected: detailsView.focus = true
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
		font.pixelSize: aspectRatio === 43 ? vpx(14*screenRatio) : vpx(14*screenRatio)
		font.family: "Open Sans"

		anchors {
			centerIn: parent
		}

}

}

}
