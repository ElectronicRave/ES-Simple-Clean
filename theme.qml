import QtQuick 2.12
import "layers" as Layers


	FocusScope {
		id: root

	// When the theme loads, try to restore the last selected game and collection.

	Component.onCompleted: {
		collectionsView.currentCollectionIndex = api.memory.get('collectionIndex') || 0;
		detailsView.currentGameIndex = api.memory.get('gameIndex') || 0;
}

	//Calculates screen ratio

	property var screenRatio: root.height < 481 ? 1.98 : 1.88;

	//calculates screen proportion

	property var screenProportion: root.width / root.height;

	//calculates screen aspect

	property var aspectRatio : calculateAspectRatio(screenProportion)

	function calculateAspectRatio(screenProportion){
		if (screenProportion < 1.34){
		return 43;
	}
		return 169;
}

	//Percentage calculator

	function vw(pixel){
		switch (aspectRatio) {
		case 43:
		return vpx(pixel*12.8)
		break;
		case 169:
		return vpx(pixel*12.8)
		break;
		default:
		return vpx(pixel*12.8)
		break;
	}

}


	// Loading the fonts here makes them usable in the rest of the theme

	FontLoader { source: "./assets/fonts/OPENSANS.TTF" }
	FontLoader { source: "./assets/fonts/OPENSANS-LIGHT.TTF" }

	// The actual views are defined in their own QML files. They activate each other by setting the focus.

	Layers.CollectionsView {
		id: collectionsView
		focus: true

		anchors {
			bottom: parent.bottom
		}

}

	Layers.DetailsView {
		id: detailsView

		anchors {
			top: collectionsView.bottom
		}

}

	// I animate the collection view's bottom anchor to move it to the top of the screen. This, in turn, pulls up the details view.

	states: [
		State {
			when: detailsView.focus
		AnchorChanges {
			target: collectionsView;
			anchors.bottom: parent.top
		}

	}

]

	// Add some animations.

	transitions: Transition {
		AnchorAnimation {
			duration: 400
			easing.type: Easing.OutQuad
		}

	}

}
