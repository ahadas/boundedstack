package org.openu.demo;

public class BoundedBuffer {

	private Object[] buffer;
	private int usedSlots = 0;
	private int writePos = 0;
	private int readPos = 0;
	private static BoundedBuffer singleton = null;

	public static BoundedBuffer getInstance() {
		return singleton;
	}

	public BoundedBuffer(int capacity) {
		this.buffer = new Object[capacity];
		singleton = this;
	}

	public Object remove() {
		if (usedSlots == 0) { return null; }
		Object result = buffer[readPos];
		buffer[readPos] = null;
		usedSlots--; readPos++;
		if (readPos == buffer.length) readPos=0;
		return result;
	}

	public void add(Object obj) throws Exception {
		if (usedSlots == buffer.length)
			throw new Exception("buffer is full");
		buffer[writePos] = obj;
		usedSlots++;
		writePos++;
		if (writePos==buffer.length) writePos=0;
	}
}
