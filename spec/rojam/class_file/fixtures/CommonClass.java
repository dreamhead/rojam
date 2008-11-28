public class CommonClass implements CommonInterface {
	private static final String CONSTANT = "constant";
	private static final int INT = 5;
	private String text;

	public String getText() {
		return this.text;
	}

	public void assignment() {
		int i = 1;
		int j = i;
	}

	public void conditional() {
		int i = 1;
		if (i == 1) {
			i = 2;
		} else if (i == 2) {
			i = 3;
		} else {
			i = 4;
		}
	}
}
