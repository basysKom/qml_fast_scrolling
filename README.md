# How scrolling in Qt/QML ListViews is implemented
In order to display something in a listview, you need to provide a data model and a delegate. The delegate defines how each data item from the model is displayed. By default, QML will not create all list entries (aka. delegates) upfront. Instead, the engine will create and show only visible entries as well as a few additional ones (for caching). This results in faster loading times and less memory usage compared to an approach where all entries are created upfront.

When scrolling, additional list entries are created on-demand. QML will create a delegate for each newly visible model entry. At the same time, delegates, that become invisible and move out of the cached range are destroyed.

To learn more about this, checkout our blog at https://blog.basyskom.com/2020/how-to-speedup-your-qt-qml-lists/