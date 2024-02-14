import QtQuick 2.12

	// The collection logo on the collection carousel.

	Item {
		property string longName: "" 
		property string shortName: "" 
		property bool selected: PathView.isCurrentItem

		width: aspectRatio === 43 ? vpx(255*screenRatio) : vpx(255*screenRatio)
		height: aspectRatio === 43 ? vpx(75*screenRatio) : vpx(75*screenRatio)
		visible: PathView.onPath 
		opacity: selected ? 1.0 : 0.5
		Behavior on opacity { NumberAnimation { duration: 150 } }


	Image {
		id: image
		fillMode: Image.PreserveAspectFit
		source: shortName ? "../assets/images/logos/%1.svg".arg(shortName) : ""
		asynchronous: true
		sourceSize { width: 256; height: 256 } 
		scale: selected ? 1.0 : 0.66
		Behavior on scale { NumberAnimation { duration: 200 } }

		anchors {
			fill: parent
		}

}

	Text {
		id: label
		color: "#000"
		font.family: "Open Sans"
		font.pixelSize: aspectRatio === 43 ? vpx(26*screenRatio) : vpx(26*screenRatio)
		text: shortName || longName
		visible: image.status != Image.Ready
		scale: selected ? 1.5 : 1.0
		Behavior on scale { NumberAnimation { duration: 150 } }

		anchors {
			centerIn: parent
		}

	}

}
