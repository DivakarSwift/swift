//
//  HTTPFileResponse.swift
//  LinComm
//
//  Created by lin on 5/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

let NULL_FD:CInt = -1

@objc public class HTTPFileResponse : NSObject,HTTPResponse{

//#define NULL_FD  -1

//@implementation HTTPFileResponse
//
//- (id)initWithFilePath:(NSString *)fpath forConnection:(HTTPConnection *)parent
//{
//	if((self = [super init]))
//	{
//		HTTPLogTrace();
    private let connection:HTTPConnection;
    private let _filePath:String;
    private let _fileLength:UInt64
    private var _fileOffset:UInt64 = 0;
    private var _aborted:Bool = false;
    private var fileFD:CInt = NULL_FD;
    private var buffer:UnsafeMutablePointer<Void> = UnsafeMutablePointer<Void>.alloc(0);
    private var bufferSize:UInt = 0;
    
    public init(filePath fpath:String,forConnection parent:HTTPConnection){
		connection = parent; // Parents retain children, children do NOT retain parents

//		fileFD = NULL_FD;
//		filePath = [[fpath copy] stringByResolvingSymlinksInPath];
        _filePath = (fpath as NSString).stringByResolvingSymlinksInPath;
//		if (filePath == nil)
//		{
//			HTTPLogWarn(@"%@: Init failed - Nil filePath", THIS_FILE);
//
//			return nil;
//		}

//		NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        let fileAttributes = try! NSFileManager.defaultManager().attributesOfItemAtPath(_filePath);
//		if (fileAttributes == nil)
//		{
//			HTTPLogWarn(@"%@: Init failed - Unable to get file attributes. filePath: %@", THIS_FILE, filePath);
//
//			return nil;
//		}

//		fileLength = (UInt64)[[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
//		fileOffset = 0;
//
//		aborted = NO;
        _fileLength = fileAttributes[NSFileSize]?.unsignedLongLongValue ?? 0;

		// We don't bother opening the file here.
		// If this is a HEAD request we only need to know the fileLength.
	}
//	return self;
//}

    public func abort(){
//	HTTPLogTrace();

//	[connection responseDidAbort:self];
        connection.responseDidAbort(self);
//	aborted = YES;
        _aborted = true;
    }

    public func openFile()->Bool{
//	HTTPLogTrace();

//	fileFD = open([filePath UTF8String], O_RDONLY);
        fileFD = open((filePath as NSString).UTF8String, O_RDONLY);
	if (fileFD == NULL_FD)
	{
//		HTTPLogError(@"%@[%p]: Unable to open file. filePath: %@", THIS_FILE, self, filePath);

//		[self abort];
//		return NO;
        self.abort();
        return false;
	}

//	HTTPLogVerbose(@"%@[%p]: Open fd[%i] -> %@", THIS_FILE, self, fileFD, filePath);

//	return YES;
        return true;
    }

    public func openFileIfNeeded()->Bool{
        if (_aborted)
        {
            // The file operation has been aborted.
            // This could be because we failed to open the file,
            // or the reading process failed.
            return false;
        }

        if (fileFD != NULL_FD)
        {
            // File has already been opened.
            return true;
        }

        return self.openFile();
    }

    public var contentLength:UInt64{
//	HTTPLogTrace();

        return _fileLength;
    }

    public var offset:UInt64{
//	HTTPLogTrace();
        get{
            return _fileOffset;
        }
        set{
//            HTTPLogTrace2(@"%@[%p]: setOffset:%llu", THIS_FILE, self, offset);
            
            if (!self.openFileIfNeeded())
            {
                // File opening failed,
                // or response has been aborted due to another error.
                return;
            }
            
            _fileOffset = newValue;
            
            let result = lseek(fileFD, off_t(_fileOffset), SEEK_SET);
            if (result == -1)
            {
//                HTTPLogError(@"%@[%p]: lseek failed - errno(%i) filePath(%@)", THIS_FILE, self, errno, filePath);
                
                self.abort();
            }
        }
    }
//- (void)setOffset:(UInt64)offset
//{
//	
//}

//    public func readDataOfLength(length:UInt64)->NSData?{
    public func readDataOfLength(length: UInt) -> NSData!{
//	HTTPLogTrace2(@"%@[%p]: readDataOfLength:%lu", THIS_FILE, self, (unsigned long)length);

        if (!self.openFileIfNeeded())
        {
            // File opening failed,
            // or response has been aborted due to another error.
            return nil;
        }

        // Determine how much data we should read.
        //
        // It is OK if we ask to read more bytes than exist in the file.
        // It is NOT OK to over-allocate the buffer.

        let bytesLeftInFile = UInt(_fileLength - _fileOffset);

            let bytesToRead = (length < bytesLeftInFile) ? length : bytesLeftInFile;

        // Make sure buffer is big enough for read request.
        // Do not over-allocate.

    //	if (buffer == NULL || bufferSize < bytesToRead)
            if bufferSize < bytesToRead {
    //            bufferSize = bytesToRead;
    //		buffer = reallocf(buffer, (size_t)bufferSize);
//                buffer.dealloc(bufferSize);
                free(buffer);
                bufferSize = bytesToRead;
                buffer = UnsafeMutablePointer<Void>.alloc(Int(bufferSize));

    //		if (buffer == NULL)
    //		{
    //			HTTPLogError(@"%@[%p]: Unable to allocate buffer", THIS_FILE, self);
    //
    //			[self abort];
    //			return nil;
    //		}
        }

        // Perform the read

    //	HTTPLogVerbose(@"%@[%p]: Attempting to read %lu bytes from file", THIS_FILE, self, (unsigned long)bytesToRead);

        let result = read(fileFD, buffer, Int(bytesToRead));

        // Check the results

        if (result < 0)
        {
    //		HTTPLogError(@"%@: Error(%i) reading file(%@)", THIS_FILE, errno, filePath);

            self.abort();
            return nil;
        }
        else if (result == 0)
        {
    //		HTTPLogError(@"%@: Read EOF on file(%@)", THIS_FILE, filePath);

            self.abort();
            return nil;
        }
        else // (result > 0)
        {
    //		HTTPLogVerbose(@"%@[%p]: Read %ld bytes from file", THIS_FILE, self, (long)result);

            _fileOffset += UInt64(result);

    //		return [NSData dataWithBytes:buffer length:result];
            return NSData(bytes: buffer, length: result);
        }
    }

    public var isDone:Bool{
        let result = _fileOffset == _fileLength;

    //	HTTPLogTrace2(@"%@[%p]: isDone - %@", THIS_FILE, self, (result ? @"YES" : @"NO"));

        return result;
    }

    public var filePath:String{
        return _filePath;
    }

    deinit{
//	HTTPLogTrace();

	if (fileFD != NULL_FD)
	{
//		HTTPLogVerbose(@"%@[%p]: Close fd[%i]", THIS_FILE, self, fileFD);

		close(fileFD);
	}

//	if (buffer)
		free(buffer);
    }

}

//@end
