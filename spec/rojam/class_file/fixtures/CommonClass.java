import java.util.ArrayList;
public class CommonClass implements CommonInterface {
	private static final String CONSTANT = "constant";
	private static final int INT = 5;
	private static final long LONG = 10L;
	private String text;
	private static final float FLOAT = 3.5F;
	private ArrayList<String> theArrayList = new ArrayList<String>();
	
	public String getText() {
		return this.text;
	}

	public void assignment() {
		int i = 1;
		int j = i;
		float k = 8f;
		float g = k;
	}
	
	public void conditional() {
		int i = -1;
		if (i == 1) {
			i = 2;
		} else if (i == 2) {
			i = 3;
		} else {
			i = 4;
		}
	}

	public void loop() {
		for (int i = 0; i < 10; i++) {
		}
	}

	public void arith() {
		int a = 5;
		int b = a + 1;
		int c = a - 1;
		int d = a * 1;
		int e = a / 1;
	}

	public void object() {
		Object a = null;
		Object b = new Object();
	}

	public void arith_for_long() {
		long a = 5;
		long b = a + 1;
		long c = a - 1;
		long d = a * 1;
		long e = a / 1;
	}

	public int return_for_int() {
		return 1;
	}

	public long return_for_long() {
		return 1L;
	}

	public void array() {
		int[] int_array = new int[1];
		Object[] object_array = new Object[1];
		int length = int_array.length;
		int_array[0] = 1;
		int int_element = int_array[0];
		object_array[0] = null;
		Object object_element = object_array[0];
	}

	public void exception() throws Exception {
		throw new Exception("exception");
	}

	public void switch_case() {
		int a = 1;
		switch(a) {
		case 1:
			break;
		default:
			break;
		}
	}

	public ArrayList<Integer> return_for_arraylist(){
		return new ArrayList<Integer>();
	}
	
	public void use_arraylist(){
		ArrayList<Integer> theArrayList = new ArrayList<Integer>();
		theArrayList.add(1);
		Integer one = theArrayList.get(0);
	}
	
	public boolean check_instance_of(){
		Integer one = new Integer(1);
		return one instanceof Integer;
	}
}
