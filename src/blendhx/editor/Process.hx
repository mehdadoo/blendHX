package blendhx.editor;

import flash.desktop.NativeApplication;
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.desktop.NativeApplication;
import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.events.ProgressEvent;
import flash.events.NativeProcessExitEvent;
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.ErrorEvent;

import flash.filesystem.File;
import flash.desktop.NotificationType;
import flash.Vector;


class Process extends EventDispatcher
{
	private var process:NativeProcess;
	
	private static var instance:Process;
	
	public static inline function getInstance()
  	{
    	if (instance == null)
          return instance = new Process();
      	else
          return instance;
  	}	
	
	public function new()
	{
		super();
		
		process = new NativeProcess();

		process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onProcessErrorData);
		process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
	}
	
	public function startProcess(args:Vector<String>=null, file:File=null, workingDirectory:File= null)
	{
		var e:ErrorEvent = null;
		
		if ( process.running )
		{
			e = new ErrorEvent( ErrorEvent.ERROR );
			e.text = "There is another process of the same type already running.";
			
			dispatchEvent( e );
			dispose();
			return;
		}

		var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
		
		if(workingDirectory!= null)
			nativeProcessStartupInfo.workingDirectory = workingDirectory;
		
		nativeProcessStartupInfo.arguments = args;
		nativeProcessStartupInfo.executable = file;


		try 
		{
			process.start(nativeProcessStartupInfo);
		} catch (ioe:IllegalOperationError) 
		{
			e = new ErrorEvent( ErrorEvent.ERROR );
			e.text = e.toString();
		} catch (ae:ArgumentError) 
		{
			e = new ErrorEvent( ErrorEvent.ERROR );
			e.text = ae.toString();
		} catch (error:Error)
		{
			e = new ErrorEvent( ErrorEvent.ERROR );
			e.text = e.toString();
		}
		
		if( e != null )
		{
			dispatchEvent(e);
			dispose();
		}
	}
	
	public function onProcessExit(e:NativeProcessExitEvent):Void
	{
		dispose();
		
		dispatchEvent( new Event(Event.COMPLETE) );
	}


	public function onProcessErrorData(pe:ProgressEvent):Void
	{
		try
		{
			NativeApplication.nativeApplication.activeWindow.notifyUser(NotificationType.CRITICAL);
		}
		catch(e:Dynamic){}
		
		var errorData:String = process.standardError.readUTFBytes(process.standardError.bytesAvailable);
		
		var e = new ErrorEvent( ErrorEvent.ERROR );
		e.text = "process error:"+errorData;
		dispatchEvent(e);
		
		dispose();
	}
	public function isRunning():Bool
	{
		return process.running;
	}
	public function dispose()
	{
		if(process.running)
			process.exit( true );
	}
}
