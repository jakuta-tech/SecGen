/* ###
 * IP: Apache License 2.0 with LLVM Exceptions
 */
/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (https://www.swig.org).
 * Version 4.1.1
 *
 * Do not make changes to this file unless you know what you are doing - modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package SWIG;

public class SBSymbolContextList {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected SBSymbolContextList(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(SBSymbolContextList obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected static long swigRelease(SBSymbolContextList obj) {
    long ptr = 0;
    if (obj != null) {
      if (!obj.swigCMemOwn)
        throw new RuntimeException("Cannot release ownership as memory is not owned");
      ptr = obj.swigCPtr;
      obj.swigCMemOwn = false;
      obj.delete();
    }
    return ptr;
  }

  @SuppressWarnings("deprecation")
  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        lldbJNI.delete_SBSymbolContextList(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public SBSymbolContextList() {
    this(lldbJNI.new_SBSymbolContextList__SWIG_0(), true);
  }

  public SBSymbolContextList(SBSymbolContextList rhs) {
    this(lldbJNI.new_SBSymbolContextList__SWIG_1(SBSymbolContextList.getCPtr(rhs), rhs), true);
  }

  public boolean IsValid() {
    return lldbJNI.SBSymbolContextList_IsValid(swigCPtr, this);
  }

  public long GetSize() {
    return lldbJNI.SBSymbolContextList_GetSize(swigCPtr, this);
  }

  public SBSymbolContext GetContextAtIndex(long idx) {
    return new SBSymbolContext(lldbJNI.SBSymbolContextList_GetContextAtIndex(swigCPtr, this, idx), true);
  }

  public boolean GetDescription(SBStream description) {
    return lldbJNI.SBSymbolContextList_GetDescription(swigCPtr, this, SBStream.getCPtr(description), description);
  }

  public void Append(SBSymbolContext sc) {
    lldbJNI.SBSymbolContextList_Append__SWIG_0(swigCPtr, this, SBSymbolContext.getCPtr(sc), sc);
  }

  public void Append(SBSymbolContextList sc_list) {
    lldbJNI.SBSymbolContextList_Append__SWIG_1(swigCPtr, this, SBSymbolContextList.getCPtr(sc_list), sc_list);
  }

  public void Clear() {
    lldbJNI.SBSymbolContextList_Clear(swigCPtr, this);
  }

  public String __repr__() {
    return lldbJNI.SBSymbolContextList___repr__(swigCPtr, this);
  }

}