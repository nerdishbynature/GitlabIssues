#PBLog#

This is a simple NSLog() replacement, which can send your logs directly to an HTTP Server and creates a log file.
You can even share the LogFile through iTunes by enabling FileSharingSupport in your Info.plist file (like in the sample provided).

You need to have your own webserver listening to your POST requests.

You can use [this](http://fragments.turtlemeat.com/pythonwebserver.php) sample and add the following statements 
to your do_POST() method before self.end_headers() .

<pre><code>logstring = self.headers.getheader('log')           
            print logstring</code></pre>
            
            
Or use the webserver I provided.
            
Feel free to ask any questions and follow me on Twitter [@piet_nbn](https://www.twitter.com/piet_nbn).

#Documentation#

*logFile:withLineNumber:andFormat:*

            Method used for logging

*+ (void)logFile:(char *)file withLineNumber:(int)lineNumber andFormat:(NSString *)format, ...*

Parameters

*file*

            The class from which the log comes

*lineNumber*

            The line number where the log was sent from

*format, …*

            The formatted string, which should be logged

*sharedInstance*

            Is the sharedInstance singleton for loggin into the same file

*+ (PBFileLogger *)sharedInstance*

Instance Methods

*log:*

            Method used for loggin

*- (void)log:(NSString *)format, ...*

            Parameters

*format, …*

            The formatted string supposed to be logged
