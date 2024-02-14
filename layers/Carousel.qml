import QtQuick 2.12

	// A carousel is a PathView that goes horizontally and keeps its current item in the center.

	PathView {
		id: root
		property int itemWidth
		property int pathWidth: pathItemCount * itemWidth
		snapMode: PathView.SnapOneItem

		preferredHighlightBegin: 0.5
		preferredHighlightEnd: 0.5

		Keys.onLeftPressed: { decrementCurrentIndex() }
		Keys.onRightPressed: { incrementCurrentIndex() }

		pathItemCount: Math.ceil(width / itemWidth) + 2
		path: Path {
			startX: (root.width - root.pathWidth) / 2
			startY: root.height / 2
		PathLine {
			x: root.path.startX + root.pathWidth
			y: root.path.startY
		}

	}

}