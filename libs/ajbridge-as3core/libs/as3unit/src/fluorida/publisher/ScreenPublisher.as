package fluorida.publisher {
    import mx.controls.Alert;

	public class ScreenPublisher extends Publisher {
		protected override function publishXML(xml:XML) : void {
			Alert.show(xml.toXMLString());
		}
	}
}