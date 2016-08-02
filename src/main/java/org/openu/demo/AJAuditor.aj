package org.openu.demo;

import org.aspectj.lang.JoinPoint;

public aspect AJAuditor {

	pointcut toLog():
		call(* *.*(..)) && !cflow(within(org.openu.demo.AJAuditor)) && !call(* requires_add0(..)) && !call(* isRunByOthers(..))
		&& !call(* isEmpty(..)) && !call(* contains(..)) && !call(* add(..)) && !call(* currentThread(..));

	before(): toLog() {
		log("ENTER", thisJoinPoint);
	}

	after() returning: toLog() {
		log("EXIT", thisJoinPoint);
	}

	after() throwing: toLog() {
		log("THROW", thisJoinPoint);
	}

	protected void log(String aType, JoinPoint jp) {
		BoundedBuffer buf = BoundedBuffer.getInstance();
		if (buf==null) return;
		try{
			buf.add(jp);
			System.out.println("audit: " + aType + " , " + jp);
		} catch(Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
