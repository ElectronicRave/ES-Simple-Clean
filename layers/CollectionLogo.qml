import QtQuick 2.12

	// The collection logo on the collection carousel.

	Item {
		property string longName: "" // set on the PathView side
		property string shortName: "" // set on the PathView side
		property bool selected: PathView.isCurrentItem

		width: vpx(480)
		height: vpx(120)
		visible: PathView.onPath // optimization: do not draw if not visible
		opacity: selected ? 1.0 : 0.5
		Behavior on opacity { NumberAnimation { duration: 150 } }


	Image {
		id: logo
		fillMode: Image.PreserveAspectFit
		source: shortName ? "../assets/images/logos/%1.svg".arg(shortName) : ""
		asynchronous: true
		sourceSize { width: 256; height: 256 } // optimization: render SVGs in at most 256x256
		scale: selected ? 1.0 : 0.66
		Behavior on scale { NumberAnimation { duration: 200 } }

		anchors {
			fill: parent
		}

}

	Text {
		id: logo__title
		color: "#000"
		font.family: "Open Sans"
		font.pixelSize: vpx(50)
		text: shortName || longName
		visible: logo.status != Image.Ready
		scale: selected ? 1.5 : 1.0
		Behavior on scale { NumberAnimation { duration: 150 } }

		anchors {
			centerIn: parent
		}

	}

}
