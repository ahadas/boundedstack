package org.openu.demo;

import java.util.*;
import org.aspectj.lang.annotation.*;

@HideType public privileged aspect BoundedBufferCoord perthis(execution(org.openu.demo.BoundedBuffer.new(..) ))
{
  @HideField private boolean org.openu.demo.BoundedBuffer.full = false;

  @HideField private boolean org.openu.demo.BoundedBuffer.empty = true;

  @HideField private int org.openu.demo.BoundedBuffer.top = 0;

  @HideField private List add0State = Collections.synchronizedList(new Vector());

  @HideField private List remove1State = Collections.synchronizedList(new Vector());

  @HideMethod private static boolean isRunByOthers(List methState)
  { 
    return !methState.isEmpty() && !methState.contains(Thread.currentThread());
  }

  @HideMethod public boolean org.openu.demo.BoundedBuffer.requires_add0()
  { 
    return !full;
  }

  @HideMethod public boolean org.openu.demo.BoundedBuffer.requires_remove1()
  { 
    return !empty;
  }

  @HideMethod public void org.openu.demo.BoundedBuffer.on_entry_add0()
  { 
    top = top + 1;
  }

  @HideMethod public void org.openu.demo.BoundedBuffer.on_entry_remove1()
  { 
    top = top - 1;
  }

  @HideMethod public void org.openu.demo.BoundedBuffer.on_exit_add0()
  { 
    empty = false;
    if(top == buffer.length)
      full = true;
  }

  @HideMethod public void org.openu.demo.BoundedBuffer.on_exit_remove1()
  { 
    full = false;
    if(top == 0)
      empty = true;
  }

  @HideMethod @BridgedSourceLocation(file = "/home/ahadas/git/AOP-Awesome-Frontends/COOL/test/src/example.cool", line = 3, module = "BoundedStack.cool") @Before("execution(* add(..)) && this(obj)") public synchronized void lock_add(org.openu.demo.BoundedBuffer obj)
  { 
    while(!obj.requires_add0() || isRunByOthers(add0State) || isRunByOthers(remove1State))
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
    obj.on_entry_add0();
    add0State.add(Thread.currentThread());
  }

  @HideMethod @After("execution(* add(..)) && this(obj)") public synchronized void unlock_add(org.openu.demo.BoundedBuffer obj)
  { 
    add0State.remove(Thread.currentThread());
    obj.on_exit_add0();
    notifyAll();
  }

  @HideMethod @BridgedSourceLocation(file = "/home/ahadas/git/AOP-Awesome-Frontends/COOL/test/src/example.cool", line = 3, module = "BoundedStack.cool") @Before("execution(* remove(..)) && this(obj)") public synchronized void lock_remove(org.openu.demo.BoundedBuffer obj)
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

  @HideMethod @After("execution(* remove(..)) && this(obj)") public synchronized void unlock_remove(org.openu.demo.BoundedBuffer obj)
  { 
    remove1State.remove(Thread.currentThread());
    obj.on_exit_remove1();
    notifyAll();
  }
}
