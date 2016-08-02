package org.openu.demo;

public class Main {

	public static void main(String[] args) {
		final BoundedBuffer buf = new BoundedBuffer(10000);

		new Thread() {
			public void run() {
				try {
					buf.add(new Object());
				} catch (Exception e) {
					e.printStackTrace();
				}
			};
		}.start();

		new Thread() {
			public void run() {
				try {
					buf.add(new Object());
				} catch (Exception e) {
					e.printStackTrace();
				}
			};
		}.start();
	}
}
