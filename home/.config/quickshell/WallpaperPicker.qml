import QtQuick
import Qt.labs.folderlistmodel
import QtQuick.Window
import Quickshell

FloatingWindow {
    id: window

    // -------------------------------------------------------------------------
    // WINDOW CONFIG
    // -------------------------------------------------------------------------
    title: "wallpaper-picker"
    implicitWidth: Screen.width
    implicitHeight: Math.round(Screen.height * 0.46)
    color: "transparent"

    // -------------------------------------------------------------------------
    // PROPERTIES
    // -------------------------------------------------------------------------
    readonly property string homeDir: "file://" + Quickshell.env("HOME")
    readonly property string thumbDir: homeDir + "/.cache/arch-rice/wallpaper/thumbs"
    readonly property string srcDir: Quickshell.env("HOME") + "/Pictures/Wallpapers"

    // SWWW Command Template
    readonly property string awwwCommand: "wpchanger.sh '%1'"

    // MPVPAPER Command Template (OPTIMIZED)
    // -l auto: Fixes layer issues
    // --hwdec=auto: Forces GPU usage (Fixes lag)
    // --no-audio: Prevents audio processing (Saves CPU)
    readonly property string mpvCommand: "pkill mpvpaper; mpvpaper -o 'loop --hwdec=auto --no-audio' '*' '%1'"

    readonly property int itemWidth: Math.round(Screen.width * 0.156)
    readonly property int itemHeight: Math.round(height * 0.84)
    readonly property int borderWidth: 3
    readonly property int spacing: 0
    readonly property real skewFactor: -0.35

    property string searchText: ""
    property string originalWallpaper: Quickshell.env("CURRENT_WALLPAPER")

    // -------------------------------------------------------------------------
    // FILTER MODEL
    // -------------------------------------------------------------------------
    DelegateModel {
        id: visualModel
        model: FolderListModel {
            id: folderModel
            folder: window.thumbDir
            nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif", "*.mp4", "*.mkv", "*.mov", "*.webm"]
            showDirs: false
            sortField: FolderListModel.Name
        }
        filterOnGroup: "filtered"
        groups: DelegateModelGroup { name: "filtered"; includeByDefault: true }

        // Re-apply filter whenever the underlying model changes (initial load)
        items.onChanged: refilter(window.searchText)

        function refilter(query) {
            if (items.count === 0) return
            query = (query || "").toLowerCase()
            for (var i = 0; i < items.count; i++) {
                var entry = items.get(i)
                entry.inFiltered = !query || entry.model.fileName.toLowerCase().indexOf(query) !== -1
            }
        }
    }

    onSearchTextChanged: visualModel.refilter(searchText)

    // -------------------------------------------------------------------------
    // CONTENT
    // -------------------------------------------------------------------------
    ListView {
        id: view
        anchors.fill: parent
        anchors.margins: 0

        spacing: window.spacing
        orientation: ListView.Horizontal

        clip: false

        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width / 2) - (window.itemWidth / 2)
        preferredHighlightEnd: (width / 2) + (window.itemWidth / 2)

        // --- SPEED SETTINGS ---
        highlightMoveDuration: 300

        focus: true

        // --- NEW: Snap to active wallpaper on load ---
        property bool initialFocusSet: false
        onCountChanged: {
            if (!initialFocusSet && count > 0) {
                var idx = parseInt(Quickshell.env("WALLPAPER_INDEX") || "0")
                // Only jump if the index exists in the current count
                if (count > idx) {
                    currentIndex = idx
                    positionViewAtIndex(idx, ListView.Center)
                    initialFocusSet = true
                }
            }
        }

        model: visualModel

        Keys.onReturnPressed: {
            if (currentItem) currentItem.pickWallpaper()
        }
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                if (window.searchText.length > 0) {
                    window.searchText = ""
                } else {
                    if (window.originalWallpaper.length > 0)
                        var restorePath = window.originalWallpaper.replace(/'/g, "'\\''")
                        Quickshell.execDetached(["bash", "-c", "awww img -t none '" + restorePath + "'"])
                    Qt.quit()
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Backspace) {
                window.searchText = window.searchText.slice(0, -1)
                event.accepted = true
            } else if (event.key === Qt.Key_S && (event.modifiers & Qt.ControlModifier)) {
                if (view.currentItem) {
                    var p = view.currentItem.sourcePath.replace(/'/g, "'\\''")
                    Quickshell.execDetached(["bash", "-c", "awww img -t none '" + p + "'"])
                }
                event.accepted = true
            } else if (event.key === Qt.Key_N && (event.modifiers & Qt.ControlModifier)) {
                incrementCurrentIndex()
                event.accepted = true
            } else if (event.key === Qt.Key_P && (event.modifiers & Qt.ControlModifier)) {
                decrementCurrentIndex()
                event.accepted = true
            } else if (event.text.length > 0 && !(event.modifiers & Qt.ControlModifier)) {
                window.searchText += event.text
                event.accepted = true
            }
        }

        delegate: Item {
            id: delegateRoot
            width: window.itemWidth
            height: window.itemHeight
            anchors.verticalCenter: parent.verticalCenter

            readonly property bool isCurrent: ListView.isCurrentItem
            readonly property bool isVideo: fileName.startsWith("000_")
            readonly property string sourcePath: {
                let cleanName = fileName
                if (cleanName.startsWith("000_")) cleanName = cleanName.substring(4)
                return window.srcDir + "/" + cleanName.split("%").join("/")
            }

            z: isCurrent ? 10 : 1

            function pickWallpaper() {
                let cleanName = fileName
                if (cleanName.startsWith("000_")) {
                    cleanName = cleanName.substring(4)
                }

                // Decode % back to / to reconstruct subfolder paths
                const originalFile = window.srcDir + "/" + cleanName.split("%").join("/")

                if (isVideo) {
                     const finalCmd = window.mpvCommand.arg(originalFile)
                     Quickshell.execDetached(["bash", "-c", finalCmd])
                } else {
                     const finalCmd = window.awwwCommand.arg(originalFile)
                     Quickshell.execDetached(["bash", "-c", finalCmd])
                }

                Qt.quit()
            }

            // PARALLELOGRAM CONTAINER
            Item {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height

                scale: delegateRoot.isCurrent ? 1.15 : 0.95
                opacity: delegateRoot.isCurrent ? 1.0 : 0.6

                Behavior on scale { NumberAnimation { duration: 500; easing.type: Easing.OutBack } }
                Behavior on opacity { NumberAnimation { duration: 500 } }

                transform: Matrix4x4 {
                    property real s: window.skewFactor
                    matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                }

                // 1. DYNAMIC BORDER (Background Layer)
                Image {
                    anchors.fill: parent
                    source: fileUrl
                    sourceSize: Qt.size(1, 1)
                    fillMode: Image.Stretch
                }

                // 2. THE IMAGE (Inset Layer)
                Item {
                    anchors.fill: parent
                    anchors.margins: window.borderWidth 

                    Rectangle { anchors.fill: parent; color: "black" }
                    clip: true

                    Image {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -parent.height * Math.abs(window.skewFactor) / 2

                        width: parent.width + (parent.height * Math.abs(window.skewFactor)) + 50
                        height: parent.height

                        fillMode: Image.PreserveAspectCrop
                        source: fileUrl

                        transform: Matrix4x4 {
                            property real s: -window.skewFactor
                            matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                        }
                    }

                    // 3. VIDEO INDICATOR (Top Right, Subtle)
                    Rectangle {
                        visible: delegateRoot.isVideo
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 10

                        width: 32
                        height: 32
                        radius: 6
                        color: "#60000000" // Subtle semi-transparent black

                        transform: Matrix4x4 {
                            property real s: -window.skewFactor
                            matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                        }

                        Canvas {
                            anchors.fill: parent
                            anchors.margins: 8 
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.fillStyle = "#EEFFFFFF"; 
                                ctx.beginPath();
                                ctx.moveTo(4, 0);
                                ctx.lineTo(14, 8);
                                ctx.lineTo(4, 16);
                                ctx.closePath();
                                ctx.fill();
                            }
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // SEARCH BAR OVERLAY
    // -------------------------------------------------------------------------
    Rectangle {
        visible: window.searchText.length > 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 12

        width: searchLabel.implicitWidth + 48
        height: 36
        radius: 8
        color: "#CC000000"

        Row {
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: "󰍉"
                color: "#AAFFFFFF"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: searchLabel
                text: window.searchText
                color: "white"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
