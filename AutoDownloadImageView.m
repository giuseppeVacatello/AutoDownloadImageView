//
//  AutoDownloadImageView.m
//  ImageViewAutoDownload
//
//  Created by Ignazio Calò on 10/1/11.
//  Copyright 2011 Ignazio Calò. All rights reserved.
//

#import "AutoDownloadImageView.h"

@implementation AutoDownloadImageView
@synthesize receivedData;
@synthesize delegate;


-(id)initWithFrame:(CGRect)frame
			URL:(NSURL *)url
	   persistency:(BOOL)persist
	 forceDownload:(BOOL)force
{
	self = [super initWithFrame:frame];
	if (self) {
		imageURL		= [url retain];
		persistency		= persist;
		forceDownload	= force;
		
		/**
		 * Imposto la proprietà image usanto una immagine
		 * placeholder.
		 * Questo approccio è migliorabile, generando una view a runtime al posto di una
		 * jpg
		 */
		self.image		= [UIImage imageNamed:@"unavailable_image.jpeg"];
		filename		= [[url lastPathComponent] retain];
		[self startDownload];
	}
	return self;
}




-(void)startDownload {
	/**
	 * Se non devo necessariamente scaricare provo a verificare
	 * se il file è già stato scaricato sul filesystem
	 */
	if (! forceDownload) {
		NSString *documentsPath = 
		
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		NSString *fileFullPath = [documentsPath stringByAppendingPathComponent:filename];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:fileFullPath]) {
			[self setImage:[UIImage imageWithContentsOfFile:fileFullPath]];
			NSLog(@"Image loaded from disk");
			return;
		}
	}

	
	/**
	 * creo la connessione per il download dell'immagine
	 */
	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:imageURL];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
	[conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[conn start];
	
	if (conn) {
		NSMutableData *data = [[NSMutableData alloc] init];
		self.receivedData = data;
		[data release];
	}
	else {
		NSError *error = [NSError errorWithDomain:AutoDownloadImageViewErrorDomain 
											 code:AutoDownloadImageViewErrorNoConnection 
										 userInfo:nil];
		/**
		 * Invio al delegate il messaggio che il download non è andato a buon fine.
		 */
		if ([self.delegate respondsToSelector:@selector(autoDownload:didFailWithError:)])
			[delegate autoDownload:self didFailWithError:error];
		
	}
	[req release];
}


-(void)dealloc {
	[imageURL release];
	[filename release];
	[super dealloc];
}




#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error 
{
    [connection release];
	/**
	 * Invio al delegate il messaggio che il download non è andato a buon fine.
	 */
    if ([delegate respondsToSelector:@selector(autoDownload:didFailWithError:)])
        [delegate autoDownload:self didFailWithError:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    /**
	 * Imposto la proprietà image con l'immagine scaricata da internet
	 * questo spesso è sufficiente affinché venga visualizzata
	 * l'immagine corretta, se così non fosse il delegate dovrà invocare un setNeedDisplay
	 */
	self.image = [UIImage imageWithData:receivedData];
	
	/**
	 * Salvo l'immagine nel filesystem se è stato specificato.
	 */
	if (persistency) {
		NSString *documentsPath = 
		
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		NSString *dbFullPath = [documentsPath stringByAppendingPathComponent:filename];
		[receivedData writeToFile:dbFullPath atomically:YES];
	}
	/**
	 * Invio al delegate il messaggio che il download è stato completato.
	 */
    if ([delegate respondsToSelector:@selector(autoDownloadImageViewFinishDownloading:)])
        [delegate autoDownloadImageViewFinishDownloading:self];
    
    [connection release];
    self.receivedData = nil;
}
@end









