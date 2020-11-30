import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: root

    width: 800
    height: 480
    visible: true
    title: qsTr("blog.basysKom.com, QML Fast Scrolling")

    property alias elementCache: elementCache

    Item {
        id: elementCache

        visible: false

        property var delegateCache: []

        function getDelegate() {
            console.log("blog.basysKom.com: getDelegate, cache size", delegateCache.length)
            if (delegateCache.length > 0)
            {
                return delegateCache.pop()
            }
            else
            {
                return delegateComponent.createObject(elementCache)
            }
        }

        function returnDelegate( item ) {
            console.log("blog.basysKom.com: returnDelegate", item, "cache size", delegateCache.length)

            item.parent = elementCache

            /*
                    reset all properties of the delegate
                    this is important to get rid of bindings
                    if you dont do this, you may experience crashes

                    i.e.

                    item.myProperty = ""
                    item.myBindedProperty = false
                */
            item.anchors.fill = elementCache
            item.name = ""
            item.aStaticProperty = false
            item.color = "red"

            delegateCache.push( item )
        }

        Component.onCompleted: {
            for (var i = 0; i < 50; ++i)
            {
                var element = delegateComponent.createObject(elementCache)
                delegateCache.push(element)
            }
        }

        Component {
            id: delegateComponent

            Rectangle {
                id: complexDelegate

                color: "red"

                signal action()

                property alias name: text.text
                property bool aStaticProperty: false

                Grid{
                    anchors.fill: parent

                    columns: 100

                    Repeater {
                        model: 500

                        delegate: Rectangle {
                            height: 5
                            width: 5
                            color:  Qt.rgba(Math.random(),
                                            Math.random(),
                                            complexDelegate.color * Math.random(), 1);
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        complexDelegate.action()
                    }
                }

                Text {
                    id: text

                    anchors.centerIn: parent

                    color: "white"
                }
            }
        }
    }

    ListView {
        anchors.fill: parent

        model: 3000

        spacing: 1

        delegate: Item {
            id: delegate

            height: 45
            width: parent.width

            property Item item

            Connections {
                target: item
                ignoreUnknownSignals: true

                onAction: {
                   console.log("blog.basysKom.com: And Action!")
                   item.color = Qt.rgba(Math.random(),Math.random(),Math.random(),1);
                }
            }

            Component.onCompleted: {
                item = elementCache.getDelegate()
                item.parent = delegate
                item.anchors.fill = Qt.binding(function (){ return delegate })
                item.color = Qt.rgba(Math.random(),Math.random(),Math.random(),1);
                item.name = Qt.binding(function (){ return "Current Index:" + index })
                item.aStaticProperty = true
            }

            Component.onDestruction: {
                elementCache.returnDelegate(item)
            }
        }
    }
}
