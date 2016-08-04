package org.openu.demo;

import java.util.*;

import org.aspectj.lang.annotation.HideMethod;

public privileged aspect BoundedBufferCoord perthis(execution(org.openu.demo.BoundedBuffer.new(..) ))
{
  private boolean org.openu.demo.BoundedBuffer.full = false;

  private boolean org.openu.demo.BoundedBuffer.empty = true;

  private int org.openu.demo.BoundedBuffer.top = 0;

  private List add0State = Collections.synchronizedList(new Vector());

  private List remove1State = Collections.synchronizedList(new Vector());

  private static boolean isRunByOthers(List methState)
  { 
    return !methState.isEmpty() && !methState.contains(Thread.currentThread());
  }

  public boolean org.openu.demo.BoundedBuffer.requires_add0()
  { 
    return !full;
  }

  public boolean org.openu.demo.BoundedBuffer.requires_remove1()
  { 
    return !empty;
  }

  public void org.openu.demo.BoundedBuffer.on_entry_add0()
  { 
    top = top + 1;
  }

  public void org.openu.demo.BoundedBuffer.on_entry_remove1()
  { 
    top = top - 1;
  }

  public void org.openu.demo.BoundedBuffer.on_exit_add0()
  { 
    empty = false;
    if(top == buffer.length)
      full = true;
  }

  public void org.openu.demo.BoundedBuffer.on_exit_remove1()
  { 
    full = false;
    if(top == 0)
      empty = true;
  }

  @HideMethod
  @org.aspectj.lang.annotation.Before("execution(* add(..)) && this(obj)") public synchronized void lock_add(org.openu.demo.BoundedBuffer obj)
  { 
//	  System.out.println("arik1");
    while(!obj.requires_add0() || isRunByOthers(add0State) || isRunByOthers(remove1State))
    { 
//    	System.out.println("arik2");
      try
      { 
//    	  System.out.println("arik3");
        wait();
      }
      catch(InterruptedException e)
      { 
        throw new RuntimeException();
      }
    }
///    System.out.println("arik4");
    obj.on_entry_add0();
    add0State.add(Thread.currentThread());
  }

  @org.aspectj.lang.annotation.After("execution(* add(..)) && this(obj)") public synchronized void unlock_add(org.openu.demo.BoundedBuffer obj)
  { 
    add0State.remove(Thread.currentThread());
    obj.on_exit_add0();
    notifyAll();
  }

  @org.aspectj.lang.annotation.Before("execution(* remove(..)) && this(obj)") public synchronized void lock_remove(org.openu.demo.BoundedBuffer obj)
  { 
    while(!obj.requires_remove1() || isRunByOthers(remove1State) || isRunByOthers(add0State))
    { 
      try
      { 
        wait();
      }
      catch(InterruptedException e)
      { 
        throw new RuntimeException();
      }
    }
    obj.on_entry_remove1();
    remove1State.add(Thread.currentThread());
  }

  @org.aspectj.lang.annotation.After("execution(* remove(..)) && this(obj)") public synchronized void unlock_remove(org.openu.demo.BoundedBuffer obj)
  { 
    remove1State.remove(Thread.currentThread());
    obj.on_exit_remove1();
    notifyAll();
  }
}
